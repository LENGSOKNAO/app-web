import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageBage extends StatelessWidget {
  final String image;
  final VoidCallback route;
  const ImageBage({super.key, required this.image, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.w,
      width: 150.w,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onTap: route,
        child: Align(
          alignment: Alignment.topRight,
          child: Icon(Icons.remove_circle_outline_sharp, color: Colors.red),
        ),
      ),
    );
  }
}
