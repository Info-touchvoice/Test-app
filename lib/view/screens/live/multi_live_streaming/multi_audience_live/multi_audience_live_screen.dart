import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../parse/LiveStreamingModel.dart';
import '../../../../../view_model/gift_contoller.dart';
import '../../../../../view_model/live_messages_controller.dart';
import '../../../../../view_model/zego_controller.dart';
import '../../single_live_streaming/single_audience_live/widgets/gift_animation_view.dart';
import '../../widgets/background_image.dart';
import '../../widgets/for_you_widget.dart';
import '../../zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import '../multi_live_widgets.dart';
import '../widgets/gift_received_widget.dart';

class AudienceMultiLive extends StatelessWidget {
  AudienceMultiLive();
  bool hideNav = false;

  @override
  Widget build(BuildContext context) {
    final LiveViewModel liveViewModel =
        Get.put(LiveViewModel(ZegoLiveRole.audience, Get.arguments));
    final GiftViewModel giftViewModel = Get.put(GiftViewModel());
    ZegoController zegoController = Get.put(ZegoController(
        ZegoLiveRole.audience, LiveStreamingModel.keyTypeMultiGuestLive));
    final LiveMessagesViewModel liveMessagesViewModel =
        Get.put(LiveMessagesViewModel(liveViewModel));

    return BaseScaffold(
      // Keep video full-bleed; SafeArea is applied inside widgets where needed.
      safeArea: true,
      resizeToAvoidBottomInset: false,
      body: GetBuilder<GiftViewModel>(
          init: giftViewModel,
          builder: (giftViewModel) {
            return Container(
              child: Stack(
                children: [
                  BackgroundImage(),
                  SafeArea(child: MultiLiveWidget()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: GiftAnimationView(
                        giftViewModel: giftViewModel,
                      )),
                  GiftReceivedWidget(),
                ],
              ),
            );
          }),
      endDrawer: ForYou(),
    );
  }
}
