import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late final AppService _service;

  @override
  void initState() {
    super.initState();
    _service = AppService();
    _loading();
  }

  Future<void> _loading() async {
    await _service.loading(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 70.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePng.logo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 100.w,
              width: 100.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.w,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
