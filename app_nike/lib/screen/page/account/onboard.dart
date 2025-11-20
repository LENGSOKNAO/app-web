import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  late final AppService _service;

  @override
  void initState() {
    super.initState();
    _service = AppService();
    _get();
  }

  Future<void> _get() async {
    await _service.onboard(context);
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImagePng.logo, color: Colors.white, width: 50),
                SizedBox(height: 20.h),
                TextNike(
                  text:
                      'Hi John, \nWelcome to Nike. \nThanks for becoming a Member!',
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
