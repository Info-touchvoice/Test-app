import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tiki/data/app/setup.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/PaymentsModel.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/view/screens/dashboard/wallet/hilo_wallet_constants.dart';
import 'package:tiki/view/screens/dashboard/wallet/receipt.dart';
import 'package:tiki/view_model/ranking_controller.dart';
import 'package:tiki/view_model/transaction_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

enum WalletPlanCurrency { diamond, beans, gold }

class WalletPlanItem {
  WalletPlanItem({
    required this.id,
    required this.amount,
    required this.price,
    required this.productKey,
    required this.currency,
    this.storeProduct,
    this.bonusLabel,
  });

  final String id;
  final int amount;
  final double price;
  final String productKey;
  final WalletPlanCurrency currency;
  final StoreProduct? storeProduct;
  final String? bonusLabel;

  WalletPlanItem copyWith({StoreProduct? storeProduct}) => WalletPlanItem(
        id: id,
        amount: amount,
        price: price,
        productKey: productKey,
        currency: currency,
        storeProduct: storeProduct ?? this.storeProduct,
        bonusLabel: bonusLabel,
      );

  String get priceLabel => storeProduct != null
      ? '${storeProduct!.currencyCode} ${storeProduct!.priceString}'
      : '\$${price.toStringAsFixed(2)}';
}

class WalletController extends GetxController {
  final selectedTab = 0.obs;
  final isLoadingPlans = true.obs;
  final isPurchasing = false.obs;

  final diamondPlans = <WalletPlanItem>[].obs;
  final beanPlans = <WalletPlanItem>[].obs;
  final goldPlans = <WalletPlanItem>[].obs;

  UserViewModel get userVm => Get.find<UserViewModel>();

  @override
  void onInit() {
    super.onInit();
    loadPlans();
    refreshBalances();
  }

  Future<void> refreshBalances() async {
    try {
      await userVm.currentUser.fetch();
      userVm.update();
    } catch (_) {}
  }

  Future<void> loadPlans() async {
    isLoadingPlans.value = true;
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('CoinPlan'))
        ..whereEqualTo('isActive', true)
        ..orderByAscending('coin');

      final response = await query.query();
      final results =
          response.success ? (response.results ?? []).whereType<ParseObject>() : <ParseObject>[];

      final diamonds = <WalletPlanItem>[];
      final beans = <WalletPlanItem>[];
      final golds = <WalletPlanItem>[];

      for (final obj in results) {
        final currencyRaw =
            (obj.get<String>('currency') ?? obj.get<String>('currencyType') ?? 'diamond')
                .toLowerCase();
        final plan = WalletPlanItem(
          id: obj.objectId ?? '',
          amount: (obj.get<num>('coin') ?? 0).toInt(),
          price: (obj.get<num>('amount') ?? 0).toDouble(),
          productKey: (obj.get<String>('productKey') ?? '').trim(),
          currency: _currencyFromString(currencyRaw),
          bonusLabel: obj.get<String>('bonusLabel'),
        );
        switch (plan.currency) {
          case WalletPlanCurrency.beans:
            beans.add(plan);
            break;
          case WalletPlanCurrency.gold:
            golds.add(plan);
            break;
          default:
            diamonds.add(plan);
        }
      }

      if (beans.isEmpty) {
        beans.addAll(_fallbackBeanPlans());
      }
      if (golds.isEmpty) {
        golds.addAll(_fallbackGoldPlans(diamonds));
      }

      diamondPlans.assignAll(diamonds);
      beanPlans.assignAll(beans);
      goldPlans.assignAll(golds);

      await _attachStoreProducts([...diamonds, ...beans, ...golds]);
    } catch (e) {
      diamondPlans.assignAll(_fallbackDiamondPlans());
      beanPlans.assignAll(_fallbackBeanPlans());
      goldPlans.assignAll(_fallbackGoldPlans(diamondPlans));
    } finally {
      isLoadingPlans.value = false;
    }
  }

  WalletPlanCurrency _currencyFromString(String raw) {
    if (raw.contains('bean')) return WalletPlanCurrency.beans;
    if (raw.contains('gold') || raw.contains('gem')) {
      return WalletPlanCurrency.gold;
    }
    return WalletPlanCurrency.diamond;
  }

  List<WalletPlanItem> _fallbackDiamondPlans() => Get.find<TransactionController>()
      .coins
      .map(
        (c) => WalletPlanItem(
          id: 'd_${c.coins}',
          amount: c.coins,
          price: c.amount,
          productKey: '',
          currency: WalletPlanCurrency.diamond,
        ),
      )
      .toList();

  List<WalletPlanItem> _fallbackBeanPlans() => [
        WalletPlanItem(
            id: 'b_500', amount: 500, price: 4.99, productKey: '', currency: WalletPlanCurrency.beans),
        WalletPlanItem(
            id: 'b_1200', amount: 1200, price: 9.99, productKey: '', currency: WalletPlanCurrency.beans, bonusLabel: '+20%'),
        WalletPlanItem(
            id: 'b_2500', amount: 2500, price: 19.99, productKey: '', currency: WalletPlanCurrency.beans),
        WalletPlanItem(
            id: 'b_5500', amount: 5500, price: 39.99, productKey: '', currency: WalletPlanCurrency.beans, bonusLabel: 'Best'),
        WalletPlanItem(
            id: 'b_12000', amount: 12000, price: 79.99, productKey: '', currency: WalletPlanCurrency.beans),
        WalletPlanItem(
            id: 'b_25000', amount: 25000, price: 149.99, productKey: '', currency: WalletPlanCurrency.beans),
      ];

  List<WalletPlanItem> _fallbackGoldPlans(List<WalletPlanItem> diamonds) {
    if (diamonds.isNotEmpty) {
      return diamonds
          .take(6)
          .map(
            (d) => WalletPlanItem(
              id: 'g_${d.amount}',
              amount: (d.amount * 2).clamp(100, 50000),
              price: d.price,
              productKey: d.productKey,
              currency: WalletPlanCurrency.gold,
            ),
          )
          .toList();
    }
    return [
      WalletPlanItem(id: 'g_1000', amount: 1000, price: 0.99, productKey: '', currency: WalletPlanCurrency.gold),
      WalletPlanItem(id: 'g_5000', amount: 5000, price: 4.99, productKey: '', currency: WalletPlanCurrency.gold),
      WalletPlanItem(id: 'g_12000', amount: 12000, price: 9.99, productKey: '', currency: WalletPlanCurrency.gold),
      WalletPlanItem(id: 'g_25000', amount: 25000, price: 19.99, productKey: '', currency: WalletPlanCurrency.gold),
      WalletPlanItem(id: 'g_60000', amount: 60000, price: 49.99, productKey: '', currency: WalletPlanCurrency.gold),
      WalletPlanItem(id: 'g_150000', amount: 150000, price: 99.99, productKey: '', currency: WalletPlanCurrency.gold),
    ];
  }

  Future<void> _attachStoreProducts(List<WalletPlanItem> plans) async {
    if (!Setup.isPurchasesEnabled) return;

    final keys = plans.map((e) => e.productKey).where((k) => k.isNotEmpty).toSet().toList();
    if (keys.isEmpty) return;

    try {
      final products = await Purchases.getProducts(
        keys,
        productCategory: ProductCategory.nonSubscription,
      );
      final byId = {for (final p in products) p.identifier: p};

      void patch(RxList<WalletPlanItem> list) {
        list.assignAll(
          list.map((p) => p.copyWith(storeProduct: byId[p.productKey])).toList(),
        );
      }

      patch(diamondPlans);
      patch(beanPlans);
      patch(goldPlans);
    } catch (_) {}
  }

  Future<void> purchasePlan(WalletPlanItem plan, BuildContext context) async {
    if (isPurchasing.value) return;

    if (!Setup.isPurchasesEnabled) return;

    if (plan.productKey.isEmpty || plan.storeProduct == null) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Unavailable',
        message: 'This pack is not linked to the store yet. Ask admin to set productKey.',
        isError: true,
      );
      return;
    }

    isPurchasing.value = true;
    QuickHelp.showLoadingDialog(context);
    try {
      await Purchases.purchaseStoreProduct(plan.storeProduct!);
      await _creditPurchase(plan);
      if (context.mounted) {
        QuickHelp.hideLoadingDialog(context);
        final ref = Get.find<TransactionController>().generateReferenceNumber();
        Get.to(() => Receipt(
              amount: plan.price,
              referenceNumber: ref,
              withdraw: false,
            ));
      }
    } catch (_) {
      if (context.mounted) {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: 'Payment Failed',
          message: 'Purchase was cancelled or failed.',
          isError: true,
        );
      }
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> _creditPurchase(WalletPlanItem plan) async {
    final user = userVm.currentUser;
    switch (plan.currency) {
      case WalletPlanCurrency.beans:
        user.setBeans = plan.amount;
        break;
      case WalletPlanCurrency.gold:
        user.setGold = plan.amount;
        break;
      case WalletPlanCurrency.diamond:
        user.setCoins = plan.amount;
        Get.find<RankingViewModel>().addRechargeRecord(plan.amount);
        break;
    }

    final response = await user.save();
    if (response.success && response.results != null) {
      userVm.currentUser = response.results!.first as UserModel;
      userVm.update();
      await _logPurchase(plan);
    }
  }

  Future<void> _logPurchase(WalletPlanItem plan) async {
    final user = userVm.currentUser;
    final payment = PaymentsModel()
      ..setAuthor = user
      ..setFullName = user.getFullName ?? ''
      ..setAuthorId = user.getUid?.toString() ?? ''
      ..setCoinsAmount = plan.amount
      ..setAmount = plan.price
      ..setTransactionType = _purchaseLabel(plan.currency)
      ..setMethod = PaymentsModel.keyTransactionTypePurchaseMethod
      ..setReferenceNumber = Get.find<TransactionController>().generateReferenceNumber();
    await payment.save();
  }

  String _purchaseLabel(WalletPlanCurrency currency) {
    switch (currency) {
      case WalletPlanCurrency.beans:
        return 'Buy Beans';
      case WalletPlanCurrency.gold:
        return 'Buy Gold';
      case WalletPlanCurrency.diamond:
        return PaymentsModel.keyTransactionTypePurchase;
    }
  }

  Future<bool> exchangeDiamondsForBeans(
      int diamondAmount, BuildContext context) async {
    if (diamondAmount < HiloWalletLayout.minDiamondExchange) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Minimum exchange',
        message:
            'Exchange at least ${HiloWalletLayout.minDiamondExchange} diamonds.',
        isError: true,
      );
      return false;
    }
    if (diamondAmount % HiloWalletLayout.minDiamondExchange != 0) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Invalid amount',
        message:
            'Diamonds must be a multiple of ${HiloWalletLayout.minDiamondExchange}.',
        isError: true,
      );
      return false;
    }
    if (userVm.coins < diamondAmount) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Insufficient diamonds',
        message: 'You do not have enough diamonds.',
        isError: true,
      );
      return false;
    }

    final beansOut = diamondAmount * HiloWalletLayout.beansPerDiamond;
    QuickHelp.showLoadingDialog(context);
    try {
      final ok = await userVm.exchangeDiamondsToBeans(diamondAmount, beansOut);
      if (!ok) throw Exception('save failed');

      final user = userVm.currentUser;
      final payment = PaymentsModel()
        ..setAuthor = user
        ..setFullName = user.getFullName ?? ''
        ..setAuthorId = user.getUid?.toString() ?? ''
        ..setCoinsAmount = beansOut
        ..setAmount = diamondAmount.toDouble()
        ..setTransactionType = 'Exchange Diamonds to Beans'
        ..setMethod = 'Exchange'
        ..setReferenceNumber =
            Get.find<TransactionController>().generateReferenceNumber();
      await payment.save();

      if (context.mounted) {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: 'Exchange successful',
          message: '$diamondAmount diamonds → $beansOut beans',
        );
      }
      return true;
    } catch (_) {
      if (context.mounted) {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: 'Exchange failed',
          message: 'Please try again.',
          isError: true,
        );
      }
      return false;
    }
  }
}
