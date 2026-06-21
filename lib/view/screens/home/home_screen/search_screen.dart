import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../../../view_model/search_controller.dart';
import '../../../widgets/recently_popular_search.dart';
import '../../../widgets/you_may_like.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textColor = AppColors.textPrimaryColor;

    SearchController searchController = Get.put(SearchController());
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 36.h,
                  width: 306.w,
                  child: TextField(
                    style: const TextStyle(color: AppColors.textPrimaryColor),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        searchController.getRecentPopularUserModel();
                      } else {
                        searchController.searchRecentPopularUserModel(value);
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.textFieldFilledColor,
                      hintText: 'Search for username or ID',
                      hintStyle: TextStyle(
                          color: AppColors.textPrimaryColor.withOpacity(0.70)),
                      prefixIcon: Icon(Icons.search,
                          color: AppColors.textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                        borderSide:
                            const BorderSide(color: AppColors.primaryPurple),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Recently Popular",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RecentlyPopular(),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You May Like",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  YouMayLike(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
