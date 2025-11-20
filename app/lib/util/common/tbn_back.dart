import 'package:app/core/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBanBack extends StatelessWidget {
  final IconData icon;
  const AppBanBack({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColor.white, shape: BoxShape.circle),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Icon(icon, size: 15.sp),
      ),
    );
  }
}
