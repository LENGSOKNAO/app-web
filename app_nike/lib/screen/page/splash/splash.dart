import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/service/app_service.dart';
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
    await _service.splash(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          width: 140.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePng.logo),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
