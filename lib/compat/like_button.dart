import 'package:flutter/material.dart';

typedef LikeButtonTapCallback = Future<bool?> Function(bool isLiked);
typedef LikeWidgetBuilder = Widget Function(bool isLiked);
typedef LikeCountWidgetBuilder = Widget Function(
  int? likeCount,
  bool isLiked,
  String text,
);

enum CountPostion { left, right, top, bottom }

enum LikeCountAnimationType { none, part, all }

class CircleColor {
  final Color start;
  final Color end;

  const CircleColor({required this.start, required this.end});
}

class BubblesColor {
  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color? dotThirdColor;
  final Color? dotLastColor;

  const BubblesColor({
    required this.dotPrimaryColor,
    required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });
}

class LikeButton extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final double size;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final CountPostion countPostion;
  final CircleColor? circleColor;
  final BubblesColor? bubblesColor;
  final bool isLiked;
  final int? likeCount;
  final EdgeInsetsGeometry? likeCountPadding;
  final LikeWidgetBuilder? likeBuilder;
  final LikeCountWidgetBuilder? countBuilder;
  final LikeButtonTapCallback? onTap;
  final LikeCountAnimationType likeCountAnimationType;

  const LikeButton({
    super.key,
    this.padding,
    this.size = 30,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.countPostion = CountPostion.right,
    this.circleColor,
    this.bubblesColor,
    this.isLiked = false,
    this.likeCount,
    this.likeCountPadding,
    this.likeBuilder,
    this.countBuilder,
    this.onTap,
    this.likeCountAnimationType = LikeCountAnimationType.part,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLiked;
  late int? _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      _isLiked = widget.isLiked;
    }
    if (oldWidget.likeCount != widget.likeCount) {
      _likeCount = widget.likeCount;
    }
  }

  Future<void> _handleTap() async {
    final previousLiked = _isLiked;
    final previousCount = _likeCount;
    final nextLiked = await widget.onTap?.call(_isLiked) ?? !_isLiked;
    if (!mounted) return;

    setState(() {
      _isLiked = nextLiked;
      if (_likeCount != null && previousLiked != nextLiked) {
        _likeCount = _likeCount! + (nextLiked ? 1 : -1);
      } else {
        _likeCount = previousCount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final like = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: widget.likeBuilder?.call(_isLiked) ??
            Icon(
              Icons.favorite,
              color: _isLiked ? Colors.red : Colors.grey,
              size: widget.size,
            ),
      ),
    );

    final count = _buildCount();
    final children = _orderedChildren(like, count);
    final isVertical = widget.countPostion == CountPostion.top ||
        widget.countPostion == CountPostion.bottom;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(widget.size),
        child: isVertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: children,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: children,
              ),
      ),
    );
  }

  Widget _buildCount() {
    if (_likeCount == null && widget.countBuilder == null) {
      return const SizedBox.shrink();
    }

    final text = (_likeCount ?? 0).toString();
    return Padding(
      padding: widget.likeCountPadding ?? EdgeInsets.zero,
      child: widget.countBuilder?.call(_likeCount, _isLiked, text) ?? Text(text),
    );
  }

  List<Widget> _orderedChildren(Widget like, Widget count) {
    switch (widget.countPostion) {
      case CountPostion.left:
      case CountPostion.top:
        return [count, like];
      case CountPostion.right:
      case CountPostion.bottom:
        return [like, count];
    }
  }
}
