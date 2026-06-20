import 'dart:async';

import 'package:flutter/material.dart';

import '../../components/audio_room/seat_item_view.dart';
import '../../components/common/zego_apply_cohost_list_page.dart';
import '../../internal/business/audioRoom/live_audio_room_seat.dart';
import '../../internal/business/business_define.dart';
import '../../internal/sdk/zim/Define/zim_define.dart';
import '../../live_audio_room_manager.dart';
import '../../zego_sdk_manager.dart';
import '../../internal/business/audioRoom/layout_config.dart';

class AudioRoomPage extends StatefulWidget {
  const AudioRoomPage({ required this.roomID, required this.role});

  final String roomID;
  final ZegoLiveRole role;

  @override
  State<AudioRoomPage> createState() => _AudioRoomPageState();
}

class _AudioRoomPageState extends State<AudioRoomPage> {
  List<StreamSubscription> subscriptions = [];

  final liveAudioRoomManager = ZegoLiveAudioRoomManager.instance;

  @override
  void initState() {
    super.initState();
    hostTakeSeat();
  }

  @override
  void dispose() {
    super.dispose();
    liveAudioRoomManager.leaveRoom();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  }

  Future<void> hostTakeSeat() async {
    if (widget.role == ZegoLiveRole.host) {
      //take seat
      await liveAudioRoomManager.setSelfHost();
      final result = await liveAudioRoomManager.takeSeat(0);
      if (result != null &&
          !result.errorKeys.contains('0')) {
        openMicAndStartPublishStream();
      }
    }
  }

  void openMicAndStartPublishStream() {
    ZEGOSDKManager.instance.expressService.turnCameraOn(false);
    ZEGOSDKManager.instance.expressService.turnMicrophoneOn(true);
    ZEGOSDKManager.instance.expressService
        .startPublishingStream(generateStreamID());
  }

  String generateStreamID() {
    final userID = ZEGOSDKManager.instance.currentUser?.userID ?? '';
    final roomID = ZEGOSDKManager.instance.expressService.currentRoomID;
    final streamID =
        '${roomID}_${userID}_${liveAudioRoomManager.roleNoti.value == ZegoLiveRole.host ? 'host' : 'coHost'}';
    return streamID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        child: Stack(
          children: [
            Positioned(top: 80, right: 40, child: leaveButton()),
            Positioned(top: 200, child: creatSeatView()),
            Positioned(bottom: 40, child: bottomView()),
          ],
        ),
      ),
    );
  }

  Widget bottomView() {
    return ValueListenableBuilder<ZegoLiveRole>(
        valueListenable: liveAudioRoomManager.roleNoti,
        builder: (context, currentRole, _) {
          if (currentRole == ZegoLiveRole.host) {
            return Container(
              color: Colors.transparent,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  requestMemberButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  micorphoneButton(),
                ],
              ),
            );
          } else if (currentRole == ZegoLiveRole.coHost) {
            return SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  leaveSeatButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  micorphoneButton(),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'Tap any empty seat to speak',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget requestMemberButton() {
    return GestureDetector(
      onTap: () {
        ApplyCoHostListView().showBasicModalBottomSheet(context);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/icons/bottom_member.png'),
      ),
    );
  }

  Widget micorphoneButton() {
    return ValueListenableBuilder<bool>(
        valueListenable: ZEGOSDKManager.instance.currentUser!.isMicOnNotifier,
        builder: (context, isOn, _) {
          return GestureDetector(
            onTap: () {
              ZEGOSDKManager.instance.expressService.turnMicrophoneOn(!isOn);
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: isOn
                  ? Image.asset('assets/icons/bottom_mic_on.png')
                  : Image.asset('assets/icons/bottom_mic_off.png'),
            ),
          );
        });
  }

  Widget leaveSeatButton() {
    return OutlinedButton(
        onPressed: () {
          for (final element in liveAudioRoomManager.seatList) {
            if (element.currentUser.value?.userID ==
                ZEGOSDKManager.instance.currentUser?.userID) {
              liveAudioRoomManager.leaveSeat(element.seatIndex).then((value) {
                liveAudioRoomManager.roleNoti.value = ZegoLiveRole.audience;
                ZEGOSDKManager().expressService.stopPublishingStream();
              });
            }
          }
        },
        child: const Text('leave seat'));
  }

  Widget leaveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/icons/top_close.png'),
      ),
    );
  }

  Widget creatSeatView() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          left: (size.width - 270) / 2,
          right: (size.width - 270) / 2,
          bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: seatListView(),
      ),
    );
  }

  List<Widget> seatListView() {
    final column = <Widget>[];
    var currentIndex = 0;
    for (var columIndex = 0;
        columIndex < liveAudioRoomManager.layoutConfig!.rowConfigs.length;
        columIndex++) {
      final rowConfig =
          liveAudioRoomManager.layoutConfig!.rowConfigs[columIndex];
      column
        ..add(Row(
          children: seatRow(columIndex, currentIndex, rowConfig),
        ))
        ..add(const SizedBox(height: 10));
      currentIndex = currentIndex + rowConfig.count;
    }
    return column;
  }

  List<Widget> seatRow(
      int columIndex, int seatIndex, ZegoLiveAudioRoomLayoutRowConfig config) {
    final seatViews = <Widget>[];
    // todo user list.gen
    for (var rowIndex = 0; rowIndex < config.count; rowIndex++) {
      final view = ZegoSeatItemView(
        seat: getRoomSeatWithIndex(seatIndex + rowIndex),
        lockSeatNoti: liveAudioRoomManager.isLockSeat,
        onPressed: (seat) {
          // Seat 0 is always reserved for the host.
          if (_isHostSeatReservedForCurrentUser(seat.seatIndex)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This seat is reserved for the host')),
            );
            return;
          }

          if (seat.currentUser.value == null) {
            if (liveAudioRoomManager.roleNoti.value == ZegoLiveRole.audience) {
              liveAudioRoomManager.takeSeat(seat.seatIndex).then((value) {
                if (value == null) return;
                if (!value.errorKeys.contains(seat.seatIndex.toString())) {
                  openMicAndStartPublishStream();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seat is already taken')),
                  );
                }
              }).catchError((_) {});
            } else if (liveAudioRoomManager.roleNoti.value == ZegoLiveRole.host) {
              // Host seat is fixed; host does not switch seats.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Host seat is fixed')),
              );
              return;
            } else if (liveAudioRoomManager.roleNoti.value == ZegoLiveRole.coHost) {
              final fromIndex = getLocalUserSeatIndex();
              if (fromIndex != -1) {
                ZegoLiveAudioRoomManager.instance
                    .switchSeatSafely(fromIndex, seat.seatIndex)
                    .then((ok) {
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seat is already taken')),
                    );
                  }
                });
              } else {
                liveAudioRoomManager.takeSeat(seat.seatIndex).then((value) {
                  if (value == null) return;
                  if (!value.errorKeys.contains(seat.seatIndex.toString())) {
                    // If we had no seat before (edge case), ensure we publish as well.
                    openMicAndStartPublishStream();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seat is already taken')),
                    );
                  }
                });
              }
            }
          } else {
            if (widget.role == ZegoLiveRole.host &&
                (ZEGOSDKManager().currentUser?.userID !=
                    seat.currentUser.value?.userID)) {
              showRemoveSpeakerAndKitOutSheet(context, seat.currentUser.value!);
            }
          }
        },
      );
      seatViews
        ..add(view)
        ..add(const SizedBox(width: 10));
    }
    return seatViews;
  }

  void showRemoveSpeakerAndKitOutSheet(
      BuildContext context, ZegoSDKUser targetUser) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: const Text('remove speaker', textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager.instance
                    .removeSpeakerFromSeat(targetUser.userID);
              },
            ),
            ListTile(
              title: Text(
                  targetUser.isMicOnNotifier.value
                      ? 'mute speaker'
                      : 'unMute speaker',
                  textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager.instance.muteSpeaker(
                    targetUser.userID, targetUser.isMicOnNotifier.value);
              },
            ),
            ListTile(
              title: const Text('kick out user', textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager.instance
                    .kickOutRoom(targetUser.userID);
              },
            ),
          ],
        );
      },
    );
  }

  int getLocalUserSeatIndex() {
    for (final element in ZegoLiveAudioRoomManager.instance.seatList) {
      if (element.currentUser.value?.userID ==
          ZEGOSDKManager.instance.currentUser?.userID) {
        return element.seatIndex;
      }
    }
    return -1;
  }

  ZegoLiveAudioRoomSeat getRoomSeatWithIndex(int seatIndex) {
    for (final element in ZegoLiveAudioRoomManager.instance.seatList) {
      if (element.seatIndex == seatIndex) {
        return element;
      }
    }
    return ZegoLiveAudioRoomSeat(0, 0, 0);
  }

  bool _isHostSeatReservedForCurrentUser(int seatIndex) {
    final hostSeatIndex = liveAudioRoomManager.hostSeatIndex;
    if (seatIndex != hostSeatIndex) return false;

    // Host can always use the host seat; everyone else cannot.
    return liveAudioRoomManager.roleNoti.value != ZegoLiveRole.host;
  }
}
