import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../view_model/live_messages_controller.dart';
import 'chat_card.dart';

class ChatFeature extends StatelessWidget {
  /// When null, fills the parent [Expanded] height instead of a fixed size.
  final double? height;
  ChatFeature({Key? key, this.height = 185}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveMessagesViewModel liveMessagesViewModel = Get.find();
    return GetBuilder<LiveMessagesViewModel>(
      init: liveMessagesViewModel,
      builder: (liveMessagesViewModel) {
        final listView = ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemCount: liveMessagesViewModel.liveMessagesModelList.length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.topLeft,
              child: ChatCard(
                liveMessagesModel:
                    liveMessagesViewModel.liveMessagesModelList[index],
                index: index,
                lastMessage:
                    liveMessagesViewModel.liveMessagesModelList.length - 1 ==
                        index,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 9.h);
          },
        );

        if (height == null) {
          return listView;
        }

        return SizedBox(
          height: height!.h,
          child: listView,
        );
      },
    );
  }
}
