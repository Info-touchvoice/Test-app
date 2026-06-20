import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/widgets/live_bottom_card.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/widgets/live_view_top_menu.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/widgets/room_announcement.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';
import '../widgets/background_image.dart';
import '../zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'audio_live/audio_preview.dart';

class LivePreviewScreen extends StatefulWidget {
  @override
  State<LivePreviewScreen> createState() => _LivePreviewScreenState();
}

class _LivePreviewScreenState extends State<LivePreviewScreen> {
  late final LiveViewModel _liveViewModel;

  @override
  void initState() {
    super.initState();
    _liveViewModel = Get.put(LiveViewModel(ZegoLiveRole.host, null));
    _liveViewModel.selectedLiveType.value = LiveStreamingModel.keyTypeAudioLive;
    _liveViewModel.nineMemberIndex.value = 1;

    final user = Get.find<UserViewModel>().currentUser;
    _liveViewModel.applyProfileDefaults(user);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      safeArea: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFF12323A)),
          ),
          const BackgroundImage(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  RoomAnnouncementCard(),
                  const SizedBox(height: 16),
                  const LiveViewTopMenu(),
                  const SizedBox(height: 4),
                  Expanded(child: AudioEmptyPreview()),
                  LiveBottomCard(_liveViewModel),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
