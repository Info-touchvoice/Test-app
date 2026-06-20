import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

import '../../../../../../../utils/constants/typography.dart';

class WinCount extends StatelessWidget {
  final bool left;
  final int winCount;
  WinCount(this.left, this.winCount);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        left: left ? 5 : null,
        right: left ? null : 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.black.withOpacity(0.6),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: ShaderMask(
                    shaderCallback: (bounds) => AppColors.secondaryGradient(
                            stops: [0.0, 1.0])
                        .createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      'WIN',
                      style: sfProDisplayBlack.copyWith(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors
                            .white, // Required for ShaderMask to show properly
                      ),
                    ),
                  ),
                ),
                if (winCount > 0)
                  TextSpan(
                    text: '  X$winCount',
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
