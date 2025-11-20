import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowBlack extends StatelessWidget {
  const ArrowBlack({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.w),
    );
  }
}
