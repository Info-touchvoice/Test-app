import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/view/screens/live/widgets/background_image.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../view_model/gift_contoller.dart';
import '../../../../../view_model/live_messages_controller.dart';
import '../../../../../view_model/music_controller.dart';
import '../../../../../view_model/zego_controller.dart';
import '../../../../widgets/base_scaffold.dart';
import '../../single_live_streaming/single_audience_live/widgets/gift_animation_view.dart';
import '../../widgets/for_you_widget.dart';
import '../multi_live_widgets.dart';
import '../widgets/gift_received_widget.dart';

class StreamerMultiLive extends StatelessWidget {
  StreamerMultiLive();
  @override
  Widget build(BuildContext context) {
    final GiftViewModel giftViewModel = Get.put(GiftViewModel());
    final MusicController musicController = Get.put(MusicController());
    ZegoController zegoController = Get.put(ZegoController(
        ZegoLiveRole.host, LiveStreamingModel.keyTypeMultiGuestLive,
        isCameraOn: Get.find<LiveViewModel>().isCameraOn.value));
    final LiveMessagesViewModel liveMessagesViewModel =
        Get.put(LiveMessagesViewModel(Get.find<LiveViewModel>()));

    return WillPopScope(
      onWillPop: () async => await false,
      child: BaseScaffold(
        safeArea: true,
        resizeToAvoidBottomInset: false,
        body: GetBuilder<GiftViewModel>(builder: (giftViewModel) {
          return Container(
            child: Stack(
              children: [
                BackgroundImage(),
                MultiLiveWidget(),
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
      ),
    );
  }
}
