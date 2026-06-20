import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/view_model/ranking_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:english_words/english_words.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app/config.dart';
import '../helpers/quick_help.dart';
import '../parse/PaymentsModel.dart';
import '../parse/WithdrawModel.dart';
import '../view/screens/dashboard/wallet/receipt.dart';
import '../view/screens/dashboard/wallet/wallet.dart';

class TransactionController extends GetxController {

  int purchaseItemIndex=-1.obs;
  int withdrawItemIndex=-1.obs;
  double singleCoinPrice = 0.0106;


  List<CoinsModel> get coins => [
    CoinsModel(coins: 20, amount: 0.29),
    CoinsModel(coins: 1120, amount: 16.99),
    CoinsModel(coins: 1515, amount: 22.99),
    CoinsModel(coins: 2045, amount: 30.99),
    CoinsModel(coins: 2905, amount: 43.99),
    CoinsModel(coins: 4955, amount: 74.99),
    CoinsModel(coins: 6000, amount: 89.99),
    CoinsModel(coins: 16500, amount: 249.99)

  ];


  bool checkBalance(double amount){
    return Get.find<UserViewModel>().myBalance >= amount;
  }

  makeWithdrawRequest(String method, double balance, {BuildContext? context}) async {
    final BuildContext? ctx = context ?? Get.context;
    if (ctx == null) {
      print('ERROR: No BuildContext available for makeWithdrawRequest');
      return;
    }

    // Stripe Connect onboarding is handled by the Admin backend (not Back4App Cloud Code),
    // because Cloud Functions are currently not running on this Parse server.
    final UserModel currentUser = Get.find<UserViewModel>().currentUser;
    try {
      await currentUser.fetch();
    } catch (_) {
      // ignore (best effort)
    }

    final String stripeAccountId = (currentUser.get<String>("stripeAccountId") ?? "").trim();
    final String sessionToken = (currentUser.getSessionToken ?? "").trim();

    if (stripeAccountId.isEmpty) {
      if (sessionToken.isEmpty) {
        QuickHelp.showAppNotificationAdvanced(
          title: 'Stripe Connect error',
          message: 'Please login again and try.',
          context: ctx,
          isError: true,
        );
        return;
      }

      final Uri onboardUrl = Uri.parse("${Config.adminBackendUrl}/stripe/connect/onboard")
          .replace(queryParameters: {"sessionToken": sessionToken});

      final launched = await launchUrl(onboardUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        QuickHelp.showAppNotificationAdvanced(
          title: 'Failed to open Stripe',
          message: 'Please check your internet connection',
          context: ctx,
          isError: true,
        );
        return;
      }

      QuickHelp.showAppNotificationAdvanced(
        title: 'Connect your Stripe account',
        message: 'Complete the setup in the browser, then return to the app and press Confirm again.',
        context: ctx,
        isError: false,
      );
      return;
    }

    String referenceNumber = generateReferenceNumber();
    // Fee model:
    // - 20% platform fee
    // - 20% "Stripe fee reserve"
    // - user receives 60%
    final double platformFee = balance * 0.20;
    final double stripeFee = balance * 0.20;
    final double netPayout = balance - platformFee - stripeFee;
    
    print('Creating withdrawal: amount=$balance, net=$netPayout, ref=$referenceNumber');
    
    final success = await withdrawTransaction(
        // Withdraw method is Stripe only.
        "stripe",
        referenceNumber,
        balance,
        platformFee: platformFee,
        stripeFee: stripeFee,
        netPayout: netPayout,
    );
    
    if (!success) {
      QuickHelp.showAppNotificationAdvanced(
        title: 'Withdrawal failed',
        message: 'Could not create withdrawal request. Please try again.',
        context: ctx,
        isError: true,
      );
      return;
    }
    
    // Receipt should reflect what user will actually receive (net payout).
    Get.to(Receipt(
      amount: netPayout,
      referenceNumber: referenceNumber,
      withdraw : true,
      grossAmount: balance,
      platformFee: platformFee,
      stripeFee: stripeFee,
      netAmount: netPayout,
    ));
  }

  Future<bool> withdrawTransaction(
      String method,
      String referenceNumber,
      double balance, {
        double platformFee = 0,
        double stripeFee = 0,
        double netPayout = 0,
      }) async {
    UserModel currentUser = Get.find<UserViewModel>().currentUser;

    // Create Withdraw request for admin panel (Parse class: "Withdrawn").
    // This is what the New Admin Panel "Withdraw Request" section reads.
    final int diamondsToWithdraw = getCoinsFromAmount(balance);
    final String normalizedMethod = "stripe";
    final WithdrawModel withdrawRequest = WithdrawModel()
      ..setAuthor = currentUser
      ..set<String>(WithdrawModel.keyMethod, normalizedMethod)
      ..set<String>(WithdrawModel.keyCurrency, WithdrawModel.CURRENCY)
      ..set<bool>(WithdrawModel.keyCompleted, false)
      ..set<String>(WithdrawModel.keyStatus, WithdrawModel.PENDING)
      ..set<num>(WithdrawModel.keyTokens, diamondsToWithdraw)
      ..set<num>(WithdrawModel.keyAmount, balance)
      // Used to sync with `Payment` record (transaction history) and admin actions.
      ..set<String>(PaymentsModel.keyReferenceNumber, referenceNumber)
      // Fee breakdown fields (used by admin panel + future Stripe payout)
      ..set<num>("platformFee", platformFee)
      ..set<num>("stripeFee", stripeFee)
      ..set<num>("netAmount", netPayout);

    PaymentsModel paymentModel=PaymentsModel();
    // if(type==PaymentsModel.keyPaymentTypePayPal){
    //   paymentModel.setPayPalEmail=paymentId;
    // }
    // else {
    //   paymentModel.setQiwiWalletNo=paymentId;
    // }
    paymentModel.setAuthor=currentUser;
    paymentModel.setFullName=currentUser.getFullName!;
    paymentModel.setAuthorId=currentUser.getUid!.toString();
    paymentModel.setMethod=method;
    // In transaction history, show what the user will actually receive.
    paymentModel.setAmount=netPayout > 0 ? netPayout : balance;
    paymentModel.setStatus=PaymentsModel.paymentStatusPending;
    paymentModel.setTransactionType=PaymentsModel.keyTransactionTypeWithdraw;
    paymentModel.setReferenceNumber = referenceNumber;
    // Store extra fields for UI/debugging
    paymentModel.set<num>("grossAmount", balance);
    paymentModel.set<num>("platformFee", platformFee);
    paymentModel.set<num>("stripeFee", stripeFee);
    paymentModel.set<num>("netAmount", netPayout);

    // Save both:
    // - Withdrawn: for admin Withdraw Request section
    // - Payment: for in-app transaction history
    final ParseResponse withdrawResp = await withdrawRequest.save();
    final ParseResponse paymentResp = await paymentModel.save();

    // IMPORTANT:
    // Do NOT deduct coins locally when a withdraw is created.
    // Coins should only be deducted when the admin marks the request as paid,
    // otherwise users see 0 until app refresh.
    if(!(withdrawResp.success && paymentResp.success)){
      print('ERROR: Withdrawal save failed. Withdraw: ${withdrawResp.success}, Payment: ${paymentResp.success}');
      if (withdrawResp.error != null) {
        print('Withdraw error: ${withdrawResp.error}');
      }
      if (paymentResp.error != null) {
        print('Payment error: ${paymentResp.error}');
      }
      return false;
    }
    
    print('Withdrawal request created successfully');
    return true;
  }

  successfulPayment(int coins, double amount, {Function()? onReturn}){
      String referenceNumber = generateReferenceNumber();
     purchaseTransaction(
          referenceNumber,
         coins,
         amount);
      Get.to(Receipt(amount: amount,
        referenceNumber: referenceNumber,
        withdraw : false,
      ))!.then((value){
        if(onReturn!=null)
          onReturn();
      });
  }

  paymentFailed(){
    QuickHelp.showAppNotificationAdvanced(title: 'Payment Failed', context: Get.context!);
  }


  purchaseTransaction(String referenceNumber, int coins, double balance ) async {
    Get.find<UserViewModel>().addBalance(coins).then((value){
      UserModel currentUser = Get.find<UserViewModel>().currentUser;
      PaymentsModel paymentModel=PaymentsModel();
      paymentModel.setAuthor=currentUser;
      paymentModel.setFullName=currentUser.getFullName!;
      paymentModel.setAuthorId=currentUser.getUid!.toString();
      paymentModel.setCoinsAmount=coins;
      paymentModel.setAmount=balance;
      paymentModel.setTransactionType=PaymentsModel.keyTransactionTypePurchase;
      paymentModel.setMethod=PaymentsModel.keyTransactionTypePurchaseMethod;
      paymentModel.setReferenceNumber = referenceNumber;


      paymentModel.save();
      Get.find<RankingViewModel>().addRechargeRecord(coins);

    });
    }

  String generateReferenceNumber() {
    final random = Random();

    // Generate 4 random words with exactly 4 characters each
    final words = generateWordPairs()
        .map((wp) => wp.first)
        .where((word) => word.length == 2)
        .take(2)
        .toList();

    // Ensure we have exactly 4 words, regenerate if necessary
    while (words.length < 2) {
      words.addAll(generateWordPairs()
          .map((wp) => wp.first)
          .where((word) => word.length == 2)
          .take(2 - words.length));
    }

    // Generate 4 random numbers, each being 4 digits long
    final numbers = List.generate(2, (_) => random.nextInt(9999).toString().padLeft(2, '0'));

    // Combine words and numbers
    final combined = <String>[];
    for (var i = 0; i < 2; i++) {
      combined.add(words[i]);
      combined.add(numbers[i]);
    }

    return combined.join('-');
  }

  int getCoinsFromAmount(double amount){
    // `myBalance` uses a 50% share:
    // myBalance = coins * singleCoinPrice * 0.5
    // So to withdraw $X from "myBalance", we must deduct:
    // coins = X / (singleCoinPrice * 0.5)
    final double denom = singleCoinPrice * 0.5;
    if (denom <= 0) return 0;
    return (amount / denom).floor();
  }





}
