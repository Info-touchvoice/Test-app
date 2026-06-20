import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/audio_room_layout_helper.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/active_seat_widget.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/audio_seat_options_sheet.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/empty_seat_widget.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/live_audio_room_manager.dart';
import 'package:tiki/view_model/live_controller.dart';
import '../../../../../view_model/zego_controller.dart';
import '../../zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';

class AudioCoHostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LiveViewModel liveViewModel = Get.find();
    final ZegoController zegoController = Get.find();
    final hostUserId =
        liveViewModel.liveStreamingModel.getAuthor?.getUid.toString();
    final manager = ZegoLiveAudioRoomManager.instance;
    final isHostRole = zegoController.role == ZegoLiveRole.host;

    return GetBuilder<ZegoController>(
      init: zegoController,
      builder: (zegoController) {
        final seatCount =
            liveViewModel.liveStreamingModel.getAudioSeats ?? 8;

        return LayoutBuilder(
          builder: (context, constraints) {
            final metrics = AudioRoomLayoutHelper.gridMetricsFor(
              seatCount: seatCount,
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            );

            return ValueListenableBuilder<Set<int>>(
              valueListenable: manager.lockedSeatIndices,
              builder: (context, lockedSeats, _) {
                final grid = _AudioSeatGrid(
                  seatCount: seatCount,
                  metrics: metrics,
                  lockedSeats: lockedSeats,
                  hostUserId: hostUserId,
                  isHostRole: isHostRole,
                  zegoController: zegoController,
                );

                return Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: grid,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _AudioSeatGrid extends StatelessWidget {
  final int seatCount;
  final AudioSeatGridMetrics metrics;
  final Set<int> lockedSeats;
  final String? hostUserId;
  final bool isHostRole;
  final ZegoController zegoController;

  const _AudioSeatGrid({
    required this.seatCount,
    required this.metrics,
    required this.lockedSeats,
    required this.hostUserId,
    required this.isHostRole,
    required this.zegoController,
  });

  @override
  Widget build(BuildContext context) {
    final columns = metrics.columns;
    final rows = metrics.rows;

    return Padding(
      padding: EdgeInsets.only(top: metrics.topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (rowIndex) {
          final rowWidgets = <Widget>[];

          for (var colIndex = 0; colIndex < columns; colIndex++) {
            if (colIndex > 0) {
              rowWidgets.add(SizedBox(width: metrics.crossSpacing));
            }

            final index = rowIndex * columns + colIndex;
            if (index >= seatCount) {
              rowWidgets.add(SizedBox(width: metrics.cellWidth));
              continue;
            }

            rowWidgets.add(
              SizedBox(
                width: metrics.cellWidth,
                child: _SeatCell(
                  index: index,
                  metrics: metrics,
                  isLocked: lockedSeats.contains(index),
                  hostUserId: hostUserId,
                  isHostRole: isHostRole,
                  zegoController: zegoController,
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: rowIndex < rows - 1 ? metrics.mainSpacing : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowWidgets,
            ),
          );
        }),
      ),
    );
  }
}

class _SeatCell extends StatelessWidget {
  final int index;
  final AudioSeatGridMetrics metrics;
  final bool isLocked;
  final String? hostUserId;
  final bool isHostRole;
  final ZegoController zegoController;

  const _SeatCell({
    required this.index,
    required this.metrics,
    required this.isLocked,
    required this.hostUserId,
    required this.isHostRole,
    required this.zegoController,
  });

  @override
  Widget build(BuildContext context) {
    final seat = zegoController.getRoomSeatWithIndex(index);
    final displayNumber = index + 1;

    void openSeatSheet(ZegoSDKUser? user) {
      AudioSeatOptionsSheet.show(
        context,
        seat: seat,
        occupant: user,
        displayNumber: displayNumber,
        isHostRole: isHostRole,
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ValueListenableBuilder<ZegoSDKUser?>(
        valueListenable: seat.currentUser,
        builder: (context, user, _) {
          if (user != null) {
            final isHost = user.userID == hostUserId;
            return GestureDetector(
              onTap: () => openSeatSheet(user),
              child: ActiveSeat(
                user,
                iconSize: metrics.iconSize,
                nameFontSize: metrics.nameFontSize,
                labelGap: metrics.labelGap,
                labelMaxWidth: metrics.cellWidth,
                compact: metrics.compact,
                isHost: isHost,
              ),
            );
          }

          return GestureDetector(
            onTap: () => openSeatSheet(null),
            child: EmptySeat(
              displayNumber,
              iconSize: metrics.iconSize,
              nameFontSize: metrics.nameFontSize,
              labelGap: metrics.labelGap,
              isLocked: isLocked,
            ),
          );
        },
      ),
    );
  }
}
