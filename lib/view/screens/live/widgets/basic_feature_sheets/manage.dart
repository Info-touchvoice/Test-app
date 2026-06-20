import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../../../view_model/live_controller.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/status.dart';
import '../../../../../view_model/userViewModel.dart';
import 'manage_modal.dart';

class ManageSheet extends StatefulWidget {
  final UserModel user;
  const ManageSheet(this.user);

  @override
  State<ManageSheet> createState() => _ManageSheetState();
}

class _ManageSheetState extends State<ManageSheet> {
  List<String> languages = [
    'Disable chat',
    'Kick out',
    'Block permanently',
    'Report',
    'Admin'
  ];
  final LiveViewModel liveViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;
    return SafeArea(
      top: false,
      child: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h + bottomSafe),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    languages.length,
                    (index) => GestureDetector(
                      onTap: () {
                        switch (languages[index]) {
                    case 'Disable chat':
                      Get.back();
                      Get.find<LiveViewModel>()
                          .addDisableChatUser(widget.user.getUid!);
                      Get.find<LiveViewModel>().status = Status.Loading;
                      _showModal(context,
                          ManageModalSheet(initialTab: 'Disable Chat'));
                      break;
                    case 'Block permanently':
                      Get.back();
                      Get.find<LiveViewModel>()
                          .addBlockUser(widget.user.getUid!);
                      Get.find<UserViewModel>()
                          .addToBlockList(widget.user.getUid!);
                      Get.find<LiveViewModel>().status = Status.Loading;
                      _showModal(
                          context, ManageModalSheet(initialTab: 'Blocked'));
                      break;
                    case 'Admin':
                      Get.back();
                      Get.find<LiveViewModel>().addAdmin(widget.user.getUid!);
                      Get.find<LiveViewModel>().status = Status.Loading;
                      _showModal(
                          context, ManageModalSheet(initialTab: 'Admin List'));
                      break;
                    case 'Report':
                      Get.back();
                      Get.toNamed(AppRoutes.chatReportScreen,
                          arguments: widget.user);
                      break;
                    case 'Kick out':
                      Get.back();
                      Get.find<LiveViewModel>()
                          .addKickOutUser(widget.user.getUid!);
                      break;
                  }
                      },
                      child: Container(
                        color: const Color(0xff363339),
                        child: Column(
                          children: [
                            const Divider(color: AppColors.divider),
                            SizedBox(height: 16.h),
                            Text(
                              languages[index],
                              style: sfProDisplaySemiBold.copyWith(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 26.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    title: 'Cancel',
                    gradient:
                        AppColors.secondaryGradient(stops: const [0.0, 1.0]),
                    borderRadius: 12.r,
                    height: 48.h,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showModal(BuildContext context, Widget modalContent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: AppColors.grey500,
      isScrollControlled: true,
      builder: (context) => modalContent,
    );
  }
}
