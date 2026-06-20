import 'dart:math';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video_item_config.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../helpers/quick_actions.dart';
import '../../../../../helpers/quick_help.dart';
import 'default_video_info.dart';

class VideoItemWidget<V extends VideoInfo> extends StatefulWidget {
  final int pageIndex;
  final int currentPageIndex;
  final bool isPaused;
  final bool singleReel;

  /// Video ended callback
  ///
  final void Function()? videoEnded;

  final VideoItemConfig config;

  /// Video Information: like count, like, more, name song, ....
  ///
  final V videoInfo;

//  /// Video network url
//  ///
//  final String url;

  /// Video Info Customizable
  ///
  final Widget? customVideoInfoWidget;

  const VideoItemWidget(
      {
      /// video information
      required this.videoInfo,
      this.singleReel = false,

      /// video config
      this.config = const VideoItemConfig(
          loop: true,
          itemLoadingWidget: CircularProgressIndicator(),
          autoPlayNextVideo: true),
      required this.pageIndex,
      required this.currentPageIndex,
      required this.isPaused,
      this.customVideoInfoWidget,
      this.videoEnded});

  @override
  State<StatefulWidget> createState() => _VideoItemWidgetState<V>();
}

class _VideoItemWidgetState<V extends VideoInfo>
    extends State<VideoItemWidget<V>> {
  CachedVideoPlayerPlus? _cachedVideoPlayer;
  VideoPlayerController? _videoPlayerController;
  bool initialized = false;
  bool actualDisposed = false;
  bool isEnded = false;

  bool isPauseClicked = false;
  bool isBuffering = false;
  bool isVideoPlaying = false;

  ///
  ///
  @override
  void initState() {
    super.initState();
    if (widget.currentPageIndex == 0 && widget.pageIndex == 0)
      isBuffering = true;

    _initVideoController();
  }

  ///
  ///
  @override
  Widget build(BuildContext context) {
    bool isLandscape = false;
    _pauseAndPlayVideo();
    if (initialized && _videoPlayerController!.value.isInitialized) {
      isLandscape = _videoPlayerController!.value.size.width >
          _videoPlayerController!.value.size.height;
    }

    return GestureDetector(
      onTap: playAndPayBtn,
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Always show thumbnail as background (visible while video loads/buffers)
            if (widget.videoInfo.postModel!.getVideoThumbnail != null)
              Positioned.fill(
                child: QuickActions.getVideoPlaceHolder(
                  widget.videoInfo.postModel!.getVideoThumbnail!.url!,
                  adaptive: true,
                  showLoading: false,
                ),
              ),
            // Show video player on top once initialized
            if (initialized)
              isLandscape
                  ? _renderLandscapeVideo()
                  : _renderPortraitVideo(),
            _renderVideoInfo(),
            // Show loading indicator while video is initializing or buffering
            if (!initialized || (isBuffering && !isVideoPlaying))
              Center(
                child: QuickHelp.showLoadingAnimation(),
              ),
            Visibility(
              visible: getPlayAndPauseBtn(),
              child: Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playAndPayBtn() {
    setState(() {
      if (widget.pageIndex == widget.currentPageIndex) {
        isPauseClicked = true;

        if (initialized &&
            _videoPlayerController != null &&
            _videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.pause().then((value) {});
        } else if (initialized &&
            _videoPlayerController != null &&
            !_videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.play().then((value) {});
        }
      } else {
        isPauseClicked = false;
      }
    });
  }

  bool getPlayAndPauseBtn() {
    if (isPauseClicked &&
        !_videoPlayerController!.value.isPlaying &&
        _videoPlayerController!.value.isInitialized) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///
  @override
  void dispose() {
    if (initialized && _videoPlayerController != null) {
      _videoPlayerController!.removeListener(_videoListener);
      _cachedVideoPlayer!.dispose();
      _videoPlayerController = null;
      _cachedVideoPlayer = null;
    }

    actualDisposed = true;
    super.dispose();
  }

  /// Video initialization
  ///
  Future<void> _initVideoController() async {
    if (widget.videoInfo.url == null) return;

    if (widget.videoInfo.file != null) {
      // Use cached file if available
      _cachedVideoPlayer = CachedVideoPlayerPlus.file(
        widget.videoInfo.file,
      );
      _cachedVideoPlayer!.initialize().then((_) {
        if (!mounted) return;
        _videoPlayerController = _cachedVideoPlayer!.controller;
        _videoPlayerController!.addListener(_videoListener);
        setState(() {
          _videoPlayerController!.setLooping(widget.config.loop);
          initialized = true;
        });
      });
    } else {
      // Start network player immediately for faster loading
      // Cache check happens in parallel but doesn't block initialization
      _cachedVideoPlayer = CachedVideoPlayerPlus.networkUrl(
        Uri.parse(widget.videoInfo.url!),
      );
      
      // Start initialization immediately without waiting for cache check
      _cachedVideoPlayer!.initialize().then((_) {
        if (!mounted) return;
        _videoPlayerController = _cachedVideoPlayer!.controller;
        _videoPlayerController!.addListener(_videoListener);
        setState(() {
          _videoPlayerController!.setLooping(widget.config.loop);
          initialized = true;
        });
      });
    }
  }

  Future<FileInfo?> checkedCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  Future<void> cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url);
  }

  /// Video controller listener

  void _videoListener() {
    if (!initialized) return;

    // Avoid setState spam: only update UI when the state actually changes.
    if (widget.pageIndex == widget.currentPageIndex) {
      final bufferingNow = _videoPlayerController!.value.isBuffering;
      final playingNow = _videoPlayerController!.value.isPlaying;

      // Only update state if it actually changed to prevent rebuild spam.
      final needsUpdate = (bufferingNow != isBuffering) || (playingNow != isVideoPlaying);
      if (needsUpdate) {
        setState(() {
          isBuffering = bufferingNow;
          isVideoPlaying = playingNow;
        });
      }
    }

    if (_videoPlayerController?.value.position != null &&
        _videoPlayerController?.value.duration != null) {
      /// check if video has ended
      ///
      if (_videoPlayerController!.value.position >=
          _videoPlayerController!.value.duration) {
        if (widget.config.autoPlayNextVideo &&
            widget.videoEnded != null &&
            !isEnded) {
          isEnded = true;
          widget.videoEnded!();
        }
      }
    }
  }

  void _pauseAndPlayVideo() {
    if (initialized && _videoPlayerController != null) {
      if (widget.pageIndex == widget.currentPageIndex &&
          !widget.isPaused &&
          initialized) {
        if (isPauseClicked) {
          return;
        }
        _videoPlayerController?.play().then((value) {});
      } else {
        _videoPlayerController?.pause().then((value) {});
      }
    }
  }

  Widget _renderLandscapeVideo() {
    if (!initialized) return Container();
    if (_videoPlayerController == null) return Container();
    return Center(
      child: AspectRatio(
        child: VisibilityDetector(
            child: VideoPlayer(_videoPlayerController!),
            onVisibilityChanged: _handleVisibilityDetector,
            key: Key('key_${widget.currentPageIndex}')),
        aspectRatio: _videoPlayerController!.value.aspectRatio,
      ),
    );
  }

  Widget _renderPortraitVideo() {
    if (!initialized) return Container();
    if (_videoPlayerController == null) return Container();

    var tmp = MediaQuery.of(context).size;

    var screenH = max(tmp.height, tmp.width);
    var screenW = min(tmp.height, tmp.width);
    tmp = _videoPlayerController!.value.size;

    var previewH = max(tmp.height, tmp.width);
    var previewW = min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Center(
      child: OverflowBox(
        child: VisibilityDetector(
            onVisibilityChanged: _handleVisibilityDetector,
            key: Key('key_${widget.currentPageIndex}'),
            child: VideoPlayer(_videoPlayerController!)),
        maxHeight: screenRatio > previewRatio
            ? screenH
            : screenW / previewW * previewH,
        maxWidth: screenRatio > previewRatio
            ? screenH / previewH * previewW
            : screenW,
      ),
    );
  }

  Widget _renderVideoInfo() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h,
      child: widget.customVideoInfoWidget != null
          ? widget.customVideoInfoWidget
          : DefaultVideoInfoWidget(
              /*name: widget.videoInfo.userName,
              time: widget.videoInfo.dateTime,
              liked: widget.videoInfo.liked,
              text: widget.videoInfo.songName,
              likes: widget.videoInfo.likes,*/
              postModel: widget.videoInfo.postModel,
              currentIndex: widget.currentPageIndex,
              singleReel: widget.singleReel,
            ),
    );
  }

  void _handleVisibilityDetector(VisibilityInfo info) {
    var visiblePercentage = info.visibleFraction * 100;

    if (widget.currentPageIndex == widget.pageIndex &&
        _videoPlayerController != null &&
        !actualDisposed) {
      // Respect pause signals (route covered / app background / user paused).
      // Without this, the VisibilityDetector can re-start playback even when the app is paused,
      // causing background playback and battery drain.
      if (widget.isPaused || isPauseClicked) {
        _videoPlayerController?.pause();
        return;
      }

      if (visiblePercentage > 0.0) {
        _videoPlayerController?.play();
      } else {
        _videoPlayerController?.pause();
      }
    } else if (_videoPlayerController != null &&
        !actualDisposed &&
        !widget.isPaused) {
      _videoPlayerController?.pause();
    }
  }
}
