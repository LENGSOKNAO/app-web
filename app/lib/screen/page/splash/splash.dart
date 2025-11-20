import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late final AppService _service;

  @override
  void initState() {
    super.initState();
    _service = AppService();
    _get();
  }

  Future<void> _get() async {
    await _service.getSplash(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePng.splash),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AppText(
            text: 'OXY BOOTS',
            font: FontWeight.bold,
            size: 40.w,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
