import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/view/widgets/nothing_widget.dart';

import '../../utils/permission/go_live_permission.dart';
import '../../view_model/global_live_stream_controller.dart';

class YouMayLike extends StatelessWidget {
  const YouMayLike({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalLiveStreamViewModel globalViewModel = Get.find();
    return GetBuilder<GlobalLiveStreamViewModel>(
        init: globalViewModel,
        builder: (controller) {
          if (globalViewModel.liveStreamingModelList.isNotEmpty)
            return Container(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1,
                ),
                itemCount: globalViewModel.liveStreamingModelList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => LivePermissionHandler.checkPermission(
                        globalViewModel.liveStreamingModelList[index].liveModel
                            .getStreamingType,
                        context,
                        liveStreamingModel: globalViewModel
                            .liveStreamingModelList[index].liveModel),
                    child: Container(
                      width: 110.w,
                      height: 110.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              globalViewModel
                                  .liveStreamingModelList[index].image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            right: 8.w,
                            child: Row(
                              children: [
                                Image.asset(AppImagePath.trendPic),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '${globalViewModel.liveStreamingModelList[index].liveModel.getViewersId!.length}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            left: 8.w,
                            child: Row(
                              children: [
                                Text(
                                  globalViewModel
                                      .liveStreamingModelList[index].name
                                      .split(" ")[0],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 65.h,
              ),
              NothingIsHere(
                height: 195.h,
                width: 180.w,
              ),
            ],
          );
        });
  }
}
