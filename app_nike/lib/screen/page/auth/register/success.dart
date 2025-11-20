import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn_black.dart';
import 'package:app_nike/util/common/buttom/btn_full.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
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
