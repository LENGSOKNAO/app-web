import 'package:app/screen/page/auth/widget/email.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: AppBanBack(icon: Icons.arrow_back_ios_new),
                ),
                Align(
                  child: AppText(
                    text: 'Recovery Password',
                    font: FontWeight.w500,
                    size: 30.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    child: AppText(
                      text:
                          'Please Enter Your Email Address To Recieve a Verification Code',
                      font: FontWeight.w400,
                      size: 16.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AppText(
                    text: 'Email Address',
                    font: FontWeight.w500,
                    size: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Email(email: 'AlissonBecker@gmail.com', controller: _email),
                SizedBox(height: 50.h),
                AppBtn(text: 'Sign Up'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
