import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextNike extends StatelessWidget {
  final String text;
  final Color color;
  const TextNike({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 28.sp,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
    );
  }
}
