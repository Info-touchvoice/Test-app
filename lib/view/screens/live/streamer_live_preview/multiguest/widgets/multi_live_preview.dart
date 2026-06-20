import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/multiguest/widgets/six_multi_guest_preview.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/multiguest/widgets/three_multi_guest_preview.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/multiguest/widgets/twelve_multi_guest_preview.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../../utils/theme/colors_constant.dart';
import '../../../../../../view_model/camera_controller.dart';
import 'four_multi_guest_preview.dart';
import 'nine_multi_guest_preview.dart';

class MultiGuestPreview extends StatelessWidget {
  MultiGuestPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();
    CameraViewModel cameraViewModel = Get.find();
    List<String> guestSeats = ['3P', '4P', '6P', '9P', '12P'];

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 25.h),
      child: Obx(() {
        return Column(
          children: [
            if (liveViewModel.selectedGuestSeat.value == guestSeats[0])
              ThreePerson(),
            if (liveViewModel.selectedGuestSeat.value == guestSeats[1])
              FourPerson(),
            if (liveViewModel.selectedGuestSeat.value == guestSeats[2])
              SixPerson(),
            if (liveViewModel.selectedGuestSeat.value == guestSeats[3])
              NinePerson(),
            if (liveViewModel.selectedGuestSeat.value == guestSeats[4])
              TwelvePerson(),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    ...List.generate(
                      guestSeats.length,
                      (index) => GestureDetector(
                        onTap: () {
                          liveViewModel.selectedGuestSeat.value =
                              guestSeats[index];
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: liveViewModel.selectedGuestSeat.value ==
                                    guestSeats[index]
                                ? AppColors.black.withOpacity(0.8)
                                : AppColors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Image.asset(AppImagePath.bitCoinSofa,
                                  width: 20.w, height: 20.w),
                              SizedBox(width: 5),
                              Text(
                                guestSeats[index],
                                style: sfProDisplayMedium.copyWith(
                                    fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
