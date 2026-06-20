import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/appButton.dart';
import 'package:tiki/view/widgets/app_text_field.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword();

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;

  RxBool isChecked = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newPassword = TextEditingController();

    confirmPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      padding: EdgeInsets.all(Dimension.borderRadius),
      body: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reset\npassword",
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Row(
            children: [
              const Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                "Please type something you will remember ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          AppTextFormField(
              controller: newPassword!,
              isPrefixIcon: true,
              prefixIcon: const Icon(Icons.lock),
              isSuffixIcon: true,
              suffixIcon: Icon(Icons.visibility_outlined),
              validator: (val) {},
              hintText: "New password "),
          const SizedBox(
            height: 24,
          ),
          AppTextFormField(
              controller: confirmPassword!,
              isPrefixIcon: true,
              prefixIcon: const Icon(Icons.lock),
              isSuffixIcon: true,
              suffixIcon: Icon(Icons.visibility_outlined),
              validator: (val) {},
              hintText: "Confirm Password"),
          const SizedBox(
            height: 24,
          ),
          appButton(context, "Reset password", () {}),
          const SizedBox(
            height: 16,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Remember Password ? ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.login);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Login',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColor,
                                    decorationStyle: TextDecorationStyle.solid,
                                  )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
