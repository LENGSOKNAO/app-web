import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn_black.dart';
import 'package:app_nike/util/common/buttom/btn_full.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Again extends StatefulWidget {
  const Again({super.key});

  @override
  State<Again> createState() => _AgainState();
}

class _AgainState extends State<Again> {
  bool isChecked = false;
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
                  SizedBox(height: 20.h),
                  TextNike(
                    text: 'You have been signed in successfully.',
                    color: Colors.black,
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      TextGrey(
                        text: 'Don’t show me again',
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  BtnFull(
                    text: 'Next',
                    route: () {
                      // if (_formkey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text("Valid Email")),
                      //   );
                      // }
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(loading, (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
