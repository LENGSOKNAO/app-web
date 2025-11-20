import 'package:app/core/config/color.dart';
import 'package:app/util/common/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBtn extends StatelessWidget {
  final String text;
  const AppBtn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.blue,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Align(
          child: AppText(
            text: text,
            font: FontWeight.w500,
            size: 16.sp,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
