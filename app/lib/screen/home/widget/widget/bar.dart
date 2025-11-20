import 'package:app/core/config/color.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bar extends StatelessWidget {
  final String icon;
  final String icon2;
  final Widget name;
  final VoidCallback top;
  const Bar({
    super.key,
    required this.icon,
    required this.icon2,
    required this.name,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: top,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(15.h),
              child: Image.asset(icon, width: 20),
            ),
          ),
        ),
        name,
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(cartRoute, (route) => false);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.h),
                  child: Image.asset(icon2, width: 20),
                ),
              ),
              // Badge for number of items
              if (AppService.product.isNotEmpty)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${AppService.product.fold<int>(0, (sum, item) => sum + item.qty)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
