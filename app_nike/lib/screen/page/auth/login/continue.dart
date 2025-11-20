import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn_black.dart';
import 'package:app_nike/util/common/buttom/btn_full.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:app_nike/util/common/text/text_uderline.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Continue extends StatelessWidget {
  const Continue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BtnBlack(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(ImagePng.logo, color: Colors.black87, width: 50),
                  SizedBox(height: 36),
                  Image.asset(ImagePng.men, width: 120.w, fit: BoxFit.contain),
                  SizedBox(height: 50.h),
                  _text(),
                  SizedBox(height: 50.h),
                  BtnFull(
                    text: 'Continue',
                    route: () {
                      Navigator.of(context).pushNamed(emailRoute);
                    },
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    child: TextUderline(
                      text: 'No, use another account.',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250.w,
          child: TextNike(
            text: 'Would you like to continue  as John Smith?',
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15.h),
        TextGrey(text: 'john@mail.com', color: Colors.grey.shade500),
        SizedBox(height: 30.h),
        TextGrey(
          text: 'By continuing, I agree to Nike’s',
          color: Colors.grey.shade500,
        ),
        Row(
          children: [
            TextUderline(text: 'Privacy Policy', color: Colors.grey.shade500),
            TextGrey(text: 'and', color: Colors.grey.shade500),
            TextUderline(text: 'Terms of Use.', color: Colors.grey.shade500),
          ],
        ),
      ],
    );
  }
}
