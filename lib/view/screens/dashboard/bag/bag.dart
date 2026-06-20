import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/theme/colors_constant.dart';
import '../../../../view_model/storeController.dart';
import 'bagmodel.dart';
import 'sticker_dialoge.dart';

class Bag extends StatefulWidget {
  const Bag();

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  StoreController storeController = Get.find();

  List<BagModel> get cat => [
        BagModel(name: 'Gift', list: [
          BagsList(name: "Castle", image: castle),
          BagsList(name: "Star", image: star),
          BagsList(name: "Heart", image: heart),
          BagsList(name: "Ride", image: ride),
        ]),
        BagModel(name: 'Cards', list: []),
        BagModel(name: 'Avatar\nFrame', list: []),
        BagModel(name: 'Cards\nFrame', list: []),
        BagModel(name: 'Room\nDecor', list: []),
        BagModel(name: 'Profile\nDecor', list: []),
        BagModel(name: 'Chat\nBubble', list: []),
      ];
  List<BagsList> avatarList= [];
  List<BagsList> decorList= [];


  @override
  void initState() {

    storeController.myAvatarItems.forEach((item) {
      avatarList.add(BagsList(name: item["name"], image: item["image"]));
    });

    storeController.myRoomDecorItems.forEach((item) {
      decorList.add(BagsList(name: item["name"], image: item["image"]));
    });

    setState(() {
      
    });
    super.initState();
  }

  int selectedIndex = 0;

  List<BagsList> item=[];

  @override
  Widget build(BuildContext context) {
    if(selectedIndex==2)
      item=avatarList;
    else if(selectedIndex==0)
      item=cat[0].list;
    else if(selectedIndex==3)
      item=decorList;
    else
      item=[];

    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Your Bag',
          style: SafeGoogleFont('sfProDisplayMedium', fontSize: 16.sp,
              color: Get.isDarkMode ? AppColors.white : AppColors.black
          ),

        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
                color: Get.isDarkMode ? AppColors.white : AppColors.black
            )),

      ),
      body: Column(
        children: [
          // Horizontal scrollable tabs
          Container(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: cat.length,
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Center(
                    child: Text(
                      cat[index].name.replaceAll('\n', ' '),
                      style: TextStyle(
                        color: selectedIndex == index 
                            ? amberColor 
                            : Get.isDarkMode 
                                ? Colors.white 
                                : AppColors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, index) => SizedBox(width: 8.w),
            ),
          ),
          // Content area
          Expanded(
            child: item.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 65.h,
                        width: 65.w,
                        child: Image.asset(
                          bag,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 9.h,),
                      Text(
                        "Empty Bag",
                        style: TextStyle(
                          color: Get.isDarkMode 
                              ? Colors.white70 
                              : Colors.black.withOpacity(0.4),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: item.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Get.dialog(
                        StickerDialoge(
                          sticker: item[index].image,
                          name: item[index].name,
                          avatarFrameSelected: selectedIndex == 2 ? true : false,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.isDarkMode 
                              ? Color(0xff252526) 
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                child: selectedIndex != 2
                                    ? Image.asset(
                                        item[index].image,
                                        fit: BoxFit.contain,
                                      )
                                    : SvgPicture.asset(
                                        item[index].image,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    item[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode 
                                          ? Colors.white 
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  String addLineBreaksAfterTwoWords(String input) {
    List<String> words = input.split(' '); // Split the string into words
    StringBuffer result = StringBuffer(); // Use StringBuffer for efficient string concatenation

    for (int i = 0; i < words.length; i++) {
      result.write(words[i]); // Add the current word
      if ((i + 1) % 2 == 0 && i != words.length - 1) {
        result.write('\n'); // Add a line break after every two words, except after the last word
      } else if (i != words.length - 1) {
        result.write(' '); // Add a space between words
      }
    }

    return result.toString();
  }

}
