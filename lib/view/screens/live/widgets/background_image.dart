import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_constants.dart';
import 'package:tiki/view_model/live_controller.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveViewModel = Get.find<LiveViewModel>();
    return GetBuilder<LiveViewModel>(
      init: liveViewModel,
      builder: (vm) {
        if (vm.presetThemeUrl != null && vm.presetThemeUrl!.isNotEmpty) {
          return Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  image: CachedNetworkImageProvider(vm.presetThemeUrl!),
                ),
              ),
            ),
          );
        }

        if (vm.presetThemeAsset != null && vm.presetThemeAsset!.isNotEmpty) {
          return Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(vm.presetThemeAsset!),
                ),
              ),
            ),
          );
        }

        if (vm.backgroundImage != null) {
          return Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  image: NetworkImage(vm.backgroundImage!.url!),
                ),
              ),
            ),
          );
        }

        if (vm.customThemeUrl != null && vm.customThemeUrl!.isNotEmpty) {
          return Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  image: CachedNetworkImageProvider(vm.customThemeUrl!),
                ),
              ),
            ),
          );
        }

        if (vm.isAudioLive) {
          return Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HiloAudioRoomColors.defaultBgTop,
                    HiloAudioRoomColors.defaultBgMid,
                    HiloAudioRoomColors.defaultBgBottom,
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
