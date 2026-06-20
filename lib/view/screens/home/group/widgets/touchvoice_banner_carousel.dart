import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../touchvoice_group_constants.dart';

/// Auto-rotating banner carousel for network URLs or local assets.
class TouchVoiceBannerCarousel extends StatefulWidget {
  const TouchVoiceBannerCarousel({
    Key? key,
    required this.items,
    this.height,
    this.padding,
    this.useNetwork = true,
  }) : super(key: key);

  final List<String> items;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool useNetwork;

  @override
  State<TouchVoiceBannerCarousel> createState() => _TouchVoiceBannerCarouselState();
}

class _TouchVoiceBannerCarouselState extends State<TouchVoiceBannerCarousel> {
  static const _autoSlideInterval = Duration(seconds: 4);

  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.items.length > 1) _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || !_pageController.hasClients || widget.items.length < 2) {
        return;
      }
      final next = (_currentPage + 1) % widget.items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _bannerImage(String item) {
    if (widget.useNetwork) {
      return CachedNetworkImage(
        imageUrl: item,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _errorWidget(),
      );
    }
    return Image.asset(item, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
      return _errorWidget();
    });
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8E8E8),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: const Color(0xFFE8E8E8),
      alignment: Alignment.center,
      child: Icon(Icons.live_tv, size: 36.sp, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final bannerHeight = widget.height ?? 100.h;
    final padding = widget.padding ?? EdgeInsets.zero;

    return Padding(
      padding: padding,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: bannerHeight,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => _bannerImage(widget.items[index]),
              ),
            ),
          ),
          if (widget.items.length > 1) ...[
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: active ? 14.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: active
                        ? TouchVoiceGroupColors.brandPurple
                        : const Color(0xFFD8D8D8),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
