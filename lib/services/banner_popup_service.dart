import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../parse/BannerModel.dart';
import '../parse/UserModel.dart';

class BannerPopupService {
  static bool _shownThisSession = false;

  static Future<void> showOnAppStartIfNeeded() async {
    if (_shownThisSession) return;
    // Only show banners after the user is in-app (logged in).
    // Prevents banners popping up on auth/initial screens.
    final UserModel? currentUser = await ParseUser.currentUser();
    if (currentUser == null) return;

    _shownThisSession = true;

    try {
      // Fetch latest active banner from Parse class "Banner" (created via admin panel).
      final query = QueryBuilder<BannerModel>(BannerModel())
        ..whereEqualTo(BannerModel.keyIsActive, true)
        ..orderByDescending(BannerModel.keyCreatedAt)
        ..setLimit(1);

      final resp = await query.query();
      if (!resp.success || resp.results == null || resp.results!.isEmpty) return;

      final banner = resp.results!.first as BannerModel;
      final imageUrl = banner.getImage?.url;
      if (imageUrl == null || imageUrl.isEmpty) return;

      // Ensure we have a context (app may still be building routes).
      await Future.delayed(const Duration(milliseconds: 400));

      if (Get.isDialogOpen == true) return;

      Get.dialog(
        _BannerPopup(imageUrl: imageUrl),
        barrierDismissible: false,
      );
    } catch (_) {
      // no-op: banner is optional
    }
  }
}

class _BannerPopup extends StatelessWidget {
  final String imageUrl;

  const _BannerPopup({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text(
                      'Failed to load banner',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: Colors.black.withOpacity(0.6),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Get.back(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

