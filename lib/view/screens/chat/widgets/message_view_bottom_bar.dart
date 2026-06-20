import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/view_model/chat_controller.dart';

import '../../../../parse/MessageModel.dart';
import '../../../../utils/theme/colors_constant.dart';
import 'message_gift_sheet.dart';

class MessageViewBottomBar extends StatelessWidget {
  StateSetter setState;
  MessageViewBottomBar({Key? key, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatViewModel chatViewModel = Get.find();

    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40.h,
            width: chatViewModel.text.isNotEmpty ? 300.w : 190.w,
            child: TextField(
              controller: chatViewModel.messageController,
              onChanged: (value) {
                chatViewModel.text.value = value;
              },
              onSubmitted: (value) {
                chatViewModel.text.value = '';
                chatViewModel.messageController.text = '';
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff494848),
                hintText: ' Aa',
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: Icon(Icons.emoji_emotions),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              ),
            ),
          ),
          if (chatViewModel.text.value.isEmpty)
            GestureDetector(
              onTap: () => chatViewModel.choosePhotoFromGallery(context),
              child: Container(
                height: 36.h,
                width: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    AppImagePath.chatPhoto,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : null,
                    height: 22.h,
                    width: 22.w,
                  ),
                ),
              ),
            ),
          if (chatViewModel.text.value.isEmpty)
            GestureDetector(
              onTap: () => chatViewModel.choosePhotoFromCamera(context),
              child: Container(
                height: 36.h,
                width: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    AppImagePath.chatCamera,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : null,
                    height: 22.h,
                    width: 25.w,
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              if (chatViewModel.text.value.isNotEmpty) {
                chatViewModel
                    .saveMessage(chatViewModel.messageController.text,
                        messageType: MessageModel.messageTypeText, onTap: () {})
                    .then((value) {
                  if (chatViewModel.results.length <= 2) {
                    setState(() {});
                  }
                });
                chatViewModel.messageController.text = "";
                chatViewModel.text.value = '';
                // chatViewModel.changeButtonIcon("");
                // chatViewModel.update();
              } else {
                openBottomSheet(MessageGiftSheet(), context);
              }
            },
            child: Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: chatViewModel.text.value.isEmpty
                      ? null
                      : AppColors.secondaryGradient(stops: [0, 1]),
                  color: chatViewModel.text.value.isEmpty
                      ? Color(0xffE5375A)
                      : AppColors.yellowBtnColor),
              child: Center(
                child: chatViewModel.text.value.isEmpty
                    ? Image.asset(
                        AppImagePath.giftIcon,
                        height: 20.h,
                        width: 20.w,
                      )
                    : Icon(
                        Icons.send,
                        color: AppColors.white,
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
