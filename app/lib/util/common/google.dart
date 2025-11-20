import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/util/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Google extends StatelessWidget {
  final String text;
  const Google({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePng.logoGoogle),
              SizedBox(width: 10),
              AppText(
                text: text,
                font: FontWeight.w500,
                size: 16.sp,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
