import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../view_model/userViewModel.dart';



class Receipt extends StatelessWidget {
  bool withdraw;
  double amount;
  String referenceNumber;
  // Optional breakdown (used for withdraw receipts)
  final double? grossAmount;
  final double? platformFee;
  final double? stripeFee;
  final double? netAmount;

  Receipt({
    this.withdraw=false,
    required this.amount,
    required this.referenceNumber,
    this.grossAmount,
    this.platformFee,
    this.stripeFee,
    this.netAmount,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('MMMM d, yyyy').format(now);
    final String formattedTime = DateFormat('HH:mm').format(now);
    List<ReceiptModel> details = [
      ReceiptModel(title: "Date", value: formattedDate),
      ReceiptModel(title: "Time", value: formattedTime),
      ReceiptModel(title: "Reference Number", value: referenceNumber),
    ];

    if (withdraw == true) {
      if (grossAmount != null) {
        details.add(ReceiptModel(title: "Requested", value: "\$ ${grossAmount!.toStringAsFixed(2)}"));
      }
      if (platformFee != null) {
        details.add(ReceiptModel(title: "Platform fee (20%)", value: "- \$ ${platformFee!.toStringAsFixed(2)}"));
      }
      if (stripeFee != null) {
        details.add(ReceiptModel(title: "Stripe fee (20%)", value: "- \$ ${stripeFee!.toStringAsFixed(2)}"));
      }
      if (netAmount != null) {
        details.add(ReceiptModel(title: "You will receive", value: "\$ ${netAmount!.toStringAsFixed(2)}"));
      }
    }
    return BaseScaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 453.23.h,
                  width: 343.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21.11.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 48.h),
                      Text(
                        withdraw==true ? "Transfer Successful" : "Payment Successful",
                        style: TextStyle(
                          color: amberColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "\$ ${amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalSpace,
                      if(withdraw==true)
                      Text(
                        "Withdraw to",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      if(withdraw==true)
                        SizedBox(height: 16.h),
                      if(withdraw==true)
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           CircleAvatar(
                            backgroundImage: QuickHelp.getUserAvatarProvider(
                                Get.find<UserViewModel>().currentUser),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Get.find<UserViewModel>().currentUser.getFullName!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "${Get.find<UserViewModel>().currentUser.getUid}",
                                style: TextStyle(
                                  fontSize: 12.31.sp,
                                    color: Colors.black.withOpacity(0.6)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transaction Detail",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ...List.generate(
                              details.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      details[index].title,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Text(
                                      details[index].value,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            verticalSpace,
                            if(withdraw==false)
                            verticalSpace,
                            if(withdraw==false)
                              verticalSpace,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Payment",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: amberColor,
                                  ),
                                ),
                                Text(
                                  "\$ $amount",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -35.h,
                  left: Get.width * 0.35,
                  child: Image.asset(
                    check,
                    height: 70.h,
                  ),
                )
              ],
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: (){
                if(withdraw==true){
                  Get.back();
                  Get.back();
                }
                else {
                  Get.back();
                }
              },
              child: Container(
                height: 51.93.h,
                width: 342.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.r),
                  color: amberColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget get verticalSpace => SizedBox(height: 35.h);
}

class ReceiptModel {
  final String title;
  final String value;
  ReceiptModel({required this.title, required this.value});
}
