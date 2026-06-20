import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:tiki/main.dart';
import 'package:tiki/utils/constants/status.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/screen_config.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video_item.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video_item_config.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view_model/home_nav_controller.dart';

import '../../../../../helpers/quick_help.dart';
import '../../../../../parse/PostsModel.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/communityController.dart';
import '../../../../../view_model/userViewModel.dart';
import 'api.dart';

class VideoNewFeedScreen extends StatefulWidget {
  /// Is case you want to keep the screen
  ///
  final bool keepPage;
  final bool singleReel;
  final PostsModel? post;

  /// Screen config
  final ScreenConfig screenConfig;

  ///
  /// Video Item config
  final VideoItemConfig config;

  final VideoNewFeedApi<VideoInfo> api;

  /// Video ended callback
  ///
  final void Function()? videoEnded;
  final Function(int page, UserModel user, PostsModel post)? pageChanged;

  //final void Function()? pageChanged;

  /// Video Info Customizable
  ///
  final Widget Function(BuildContext context, VideoInfo v)?
      customVideoInfoWidget;

  const VideoNewFeedScreen({
    this.keepPage = false,
    this.singleReel = false,
    this.screenConfig = const ScreenConfig(
      backgroundColor: Colors.black,
      loadingWidget: CircularProgressIndicator(),
    ),

    /// video config
    this.config = const VideoItemConfig(
        loop: true,
        itemLoadingWidget: CircularProgressIndicator(),
        autoPlayNextVideo: true),
    this.customVideoInfoWidget,
    this.videoEnded,
    this.pageChanged,
    required this.api,
    this.post,
  });

  @override
  State<StatefulWidget> createState() => _VideoNewFeedScreenState();
}

class _VideoNewFeedScreenState<V extends VideoInfo>
    extends State<VideoNewFeedScreen> with WidgetsBindingObserver, RouteAware {
  /// PageController
  ///
  //late PageController _pageController;
  late PreloadPageController _pageController;

  /// Current page is on screen
  ///
  int _currentPage = 0;

  /// Page is on turning or off, use to check how much percent the next video will render and play
  ///
  bool _isOnPageTurning = false;

  // When true, force-pause the reel even if the user is on the current page.
  // This is used when navigating to other routes (Live/Profile/etc.) or when app goes background.
  bool _forcePaused = false;

  final _listVideoStream = StreamController<List<VideoInfo>>();

  CommunityController communityController = Get.find();

  /// Temp to update list video data
  ///
  List<VideoInfo> temps = [];

  void setList(List<VideoInfo> items) {
    if (!_listVideoStream.isClosed) {
      _listVideoStream.sink.add(items);
    }
  }

  void _notifyDataChanged() => setList(temps);

  /// Check to play next video when user scroll
  /// If the next video appear about 30% (0.7) the next video will play
  ///
  void _scrollListener() {
    if (_isOnPageTurning &&
        _pageController.page == _pageController.page!.roundToDouble()) {
      setState(() {
        _currentPage = _pageController.page!.toInt();
        _isOnPageTurning = false;
      });
    } else if (!_isOnPageTurning &&
        _currentPage.toDouble() != _pageController.page) {
      if ((_currentPage.toDouble() - _pageController.page!).abs() > 0.7) {
        setState(() {
          _isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController(keepPage: widget.keepPage);
    _pageController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);

    _getListVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  // RouteAware: another page covered this one -> pause
  @override
  void didPushNext() {
    if (mounted) {
      setState(() => _forcePaused = true);
    } else {
      _forcePaused = true;
    }
  }

  // RouteAware: user came back to this page -> resume
  @override
  void didPopNext() {
    if (mounted) {
      setState(() => _forcePaused = false);
    } else {
      _forcePaused = false;
    }
  }

  // App lifecycle: background/inactive -> pause; foreground -> resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final shouldPause = state != AppLifecycleState.resumed;
    if (mounted) {
      setState(() => _forcePaused = shouldPause);
    } else {
      _forcePaused = shouldPause;
    }
  }

  void _getListVideo() {
    if (communityController.videosList.isNotEmpty) {
      temps.addAll(communityController.videosList);
      _notifyDataChanged();
      // Pre-cache first video for faster playback
      _prefetchFirstVideo(communityController.videosList);
    } else {
      widget.api.getListVideo().then((value) {
        _notifyDataChanged();
        // Pre-cache first video for faster playback
        _prefetchFirstVideo(communityController.videosList);
      });
    }
  }

  /// Pre-cache the first video URL to reduce initial load time
  void _prefetchFirstVideo(List<VideoInfo> videos) {
    if (videos.isNotEmpty && videos.first.url != null) {
      communityController.cachedForUrl(videos.first.url!);
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeNavController homeNavController = Get.find();
    return BaseScaffold(
        topSafeArea: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _renderVideoPageView(),
            // if (widget.singleReel == false)
            //   Positioned(
            //       top: 36.h,
            //       left: 17.w,
            //       child: GestureDetector(
            //         onTap: () {
            //           homeNavController.setHomeLiveView = true;
            //         },
            //         child: Row(
            //           children: [
            //             Image.asset(
            //               AppImagePath.icReelLive,
            //               height: 26.h,
            //               width: 26.w,
            //               fit: BoxFit.fill,
            //             ),
            //           ],
            //         ),
            //       )),
            Positioned(
              top: 40.h,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GetBuilder<CommunityController>(builder: (controller) {
                  return SizedBox(
                    height: 28.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.selectReelsTypeFollowing = true;
                          },
                          behavior: HitTestBehavior
                              .opaque, // Ensures it receives gestures even if child is transparent
                          child: Column(
                            children: [
                              Text(
                                "Following",
                                style: sfProDisplaySemiBold.copyWith(
                                  color: controller.isReelTypeFollowing
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              if (controller.isReelTypeFollowing)
                                Container(
                                  color: AppColors.primaryColor,
                                  width: 10.w,
                                  height: 2.h,
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.selectReelsTypeFollowing = false;
                          },
                          behavior: HitTestBehavior
                              .opaque, // Ensures it receives gestures even if child is transparent
                          child: Column(
                            children: [
                              Text(
                                "For You",
                                style: sfProDisplaySemiBold.copyWith(
                                  color: !controller.isReelTypeFollowing
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              if (controller.isReelTypeFollowing == false)
                                Container(
                                  color: AppColors.primaryColor,
                                  width: 10.w,
                                  height: 2.h,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listVideoStream.close();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Page View
  ///
  Widget _renderVideoPageView() {
    return GetBuilder<CommunityController>(
        init: communityController,
        builder: (controller) {
          List<VideoInfo> videosList = controller.isReelTypeFollowing
              ? controller.followerVideosList
              : controller.videosList;

          if (controller.status == Status.Loading &&
              widget.singleReel == false) {
            return Center(
              child: QuickHelp.showLoadingAnimation(),
            );
          }

          if (videosList.isEmpty && widget.singleReel == false) {
            return Center(
              child: widget.screenConfig.emptyWidget ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/no_result.json"),
                      Text("No result.")
                    ],
                  ),
            );
          }
          return PreloadPageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: widget.singleReel == false ? videosList.length : 1,
            // Preloading too many pages starts multiple video initializations/downloads at once,
            // which can saturate bandwidth and cause constant buffering. Keep it small.
            preloadPagesCount: 2,
            pageSnapping: true,
            onPageChanged: (page) {
              UserModel? user = widget.singleReel == false
                  ? videosList[page].currentUser
                  : Get.find<UserViewModel>().currentUser;
              PostsModel? post = widget.singleReel == false
                  ? videosList[page].postModel
                  : widget.post;

              // Prefetch only the next reel into cache (one at a time) to reduce buffering
              // without creating many concurrent downloads.
              if (widget.singleReel == false) {
                final nextIndex = page + 1;
                if (nextIndex >= 0 && nextIndex < videosList.length) {
                  final nextUrl = videosList[nextIndex].url;
                  if (nextUrl != null) {
                    // Fire-and-forget: only download if not already cached.
                    communityController.checkedCacheFor(nextUrl).then((fileInfo) {
                      if (fileInfo == null) {
                        communityController.cachedForUrl(nextUrl);
                      }
                    });
                  }
                }
              }

              if (widget.pageChanged != null && user != null) {
                widget.pageChanged!(page, user, post!) as void Function()?;
              }
            },
            itemBuilder: (context, index) {
              VideoInfo videoInfo = VideoInfo();
              if (widget.singleReel == true)
                videoInfo = VideoInfo(
                  postModel: widget.post!,
                  currentUser: Get.find<UserViewModel>().currentUser,
                  url: widget.post!.getVideo!.url,
                );
              return VideoItemWidget(
                videoInfo:
                    widget.singleReel == true ? videoInfo : videosList[index],
                pageIndex: index,
                singleReel: widget.singleReel,
                currentPageIndex: _currentPage,
                isPaused: _isOnPageTurning || _forcePaused,
                config: widget.config,
                videoEnded: widget.videoEnded,
                customVideoInfoWidget: widget.customVideoInfoWidget != null
                    ? widget.customVideoInfoWidget!(context, temps[index])
                    : null,
              );
            },
          );
        });
  }
}
