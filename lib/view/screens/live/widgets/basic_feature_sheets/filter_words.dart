import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../utils/theme/colors_constant.dart';

class FilterWordWidget extends StatefulWidget {
  const FilterWordWidget();

  @override
  State<FilterWordWidget> createState() => _FilterWordWidgetState();
}

class _FilterWordWidgetState extends State<FilterWordWidget> {
  final FocusNode _focusNode = FocusNode();
  RxBool openKeyBoard = false.obs;
  int inset = 0;
  List filterWords = [];
  TextEditingController textEditingController = TextEditingController();
  LiveViewModel liveViewModel = Get.find();

  @override
  void initState() {
    filterWords = liveViewModel.liveStreamingModel.getFilteredList ?? [];
    // liveViewModel.liveStreamingModel.removeFilteredList = filterWords;
    super.initState();
  }

  @override
  void dispose() {
    // liveViewModel.liveStreamingModel.setFilteredList = filterWords;
    liveViewModel.liveStreamingModel.save();
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveViewModel>(
        init: liveViewModel,
        builder: (liveViewModel) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final bottomSafe = MediaQuery.of(context).viewPadding.bottom;

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            const SizedBox(width: 40),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Filter words',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: AppColors.divider, height: 3),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            children: [
                              Text(
                                "Edit the words you don't want to see in the comments, and the relevant comments will be automatically filtered.\nOne user can set (50) filtered words. It is not recommended to block common words such as 'Hi, Hello, a, good...'",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 20.h),
                              if (filterWords.isNotEmpty)
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    childAspectRatio: 2.6,
                                  ),
                                  itemCount: filterWords.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff212121),
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${filterWords[index]}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          GestureDetector(
                                            onTap: () async {
                                              liveViewModel.liveStreamingModel
                                                      .removeFilteredList =
                                                  filterWords[index];
                                              ParseResponse response =
                                                  await liveViewModel
                                                      .liveStreamingModel
                                                      .save();
                                              if (response.success) {
                                                filterWords.removeAt(index);
                                              }
                                              setState(() {});
                                            },
                                            child: Image.asset(
                                                AppImagePath.deleteIcon),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        return Visibility(
                          visible: openKeyBoard.value == true,
                          child: Container(
                            width: Get.width,
                            color: AppColors.navBarColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 8.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: textEditingController,
                                    focusNode: _focusNode,
                                    onSaved: (_) => openKeyBoard.value = false,
                                    onFieldSubmitted: (_) =>
                                        openKeyBoard.value = false,
                                    style: sfProDisplayRegular.copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.white70),
                                    scrollPadding: EdgeInsets.zero,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.w, 10.h, 15.w, 0),
                                      hintText: "Aa",
                                      filled: true,
                                      hintStyle: sfProDisplayRegular.copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.white70),
                                      fillColor: const Color(0xff494848),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                PrimaryButton(
                                  height: 52.h,
                                  width: 70.w,
                                  bgColor: AppColors.yellowBtnColor,
                                  borderRadius: 38.r,
                                  textStyle: sfProDisplayRegular.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.black),
                                  onTap: () {
                                    final text =
                                        textEditingController.text.trim();
                                    if (text.isEmpty) return;
                                    filterWords.add(text);
                                    liveViewModel.liveStreamingModel
                                        .setFilteredList = text;
                                    liveViewModel.liveStreamingModel.save();
                                    textEditingController.text = '';
                                    openKeyBoard.value = false;
                                    setState(() {});
                                  },
                                  title: 'Send',
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Obx(() {
                        return Visibility(
                          visible: openKeyBoard.value == false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlineButton(
                                    onTap: () {
                                      filterWords.clear();
                                      // NOTE: if you have a server-side "clear all" API,
                                      // call it here too.
                                      setState(() {});
                                    },
                                    height: 44.h,
                                    parentBgColor: AppColors.card,
                                    title: "Clear",
                                    useTextGradient: true,
                                    borderRadius: 50.r,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: PrimaryButton(
                                    onTap: () {
                                      openKeyBoard.value = true;
                                      _requestFocus();
                                    },
                                    height: 44.h,
                                    title: "Add",
                                    gradient:
                                        AppColors.gradient(stops: [0.0, 1.0]),
                                    borderRadius: 50.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 12.h + bottomSafe),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
