import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextGrey extends StatelessWidget {
  final String text;
  final Color color;
  const TextGrey({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
        color: color,
      ),
    );
  }
}
