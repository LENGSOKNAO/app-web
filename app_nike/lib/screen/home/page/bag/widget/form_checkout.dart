import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormCheckout extends StatelessWidget {
  final String text;
  final String select;
  final VoidCallback route;
  final bool color;
  const FormCheckout({
    super.key,
    required this.text,
    required this.select,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
              Spacer(),
              Text(
                select,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: color ? Colors.redAccent : Colors.grey.shade800,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 20),
              Icon(Icons.add, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
