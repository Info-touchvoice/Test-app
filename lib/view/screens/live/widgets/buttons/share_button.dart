import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../utils/constants/app_constants.dart';

class ShareBtn extends StatelessWidget {
  const ShareBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Share.share("Checkout this live stream on Tiki");
      },
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: Image.asset(AppImagePath.shareIcon, width: 22, height: 22),
      ),
    );
  }
}
