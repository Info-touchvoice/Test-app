import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../view_model/zego_controller.dart';
import '../../../zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';
import '../zego_multi_live_view.dart';

class TwelveMultiGuestView extends StatelessWidget {
  const TwelveMultiGuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ZegoController zegoController = Get.find();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: ValueListenableBuilder<ZegoSDKUser?>(
          valueListenable: zegoController.liveStreamingManager.hostNoti,
          builder: (context, host, _) {
            return ValueListenableBuilder<List<ZegoSDKUser>>(
                valueListenable:
                    zegoController.liveStreamingManager.coHostUserListNoti,
                builder: (context, coHostList, _) {
                  int length = coHostList.length;
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return ZegoMultiLiveView(
                        userInfo: index == 0
                            ? host
                            : length >= index
                                ? coHostList[index - 1]
                                : null,
                        seat: index,
                      );
                    },
                  );
                });
          }),
    );
  }
}
