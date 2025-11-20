import 'package:app/screen/page/auth/widget/email.dart';
import 'package:app/screen/page/auth/widget/pass.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/google.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _pass = TextEditingController();
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
                    ).pushNamedAndRemoveUntil(onboardRoute, (route) => false);
                  },
                  child: AppBanBack(icon: Icons.arrow_back_ios_new),
                ),
                SizedBox(height: 50.h),
                Align(
                  child: AppText(
                    text: 'Hello Again!',
                    font: FontWeight.w500,
                    size: 30.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Align(
                  child: AppText(
                    text: 'Welcome Back You’ve Been Missed!',
                    font: FontWeight.w400,
                    size: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 50.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AppText(
                    text: 'Email Address',
                    font: FontWeight.w500,
                    size: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Email(email: 'AlissonBecker@gmail.com', controller: _email),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AppText(
                    text: 'Password',
                    font: FontWeight.w500,
                    size: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Pass(email: 'Password', controller: _pass),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(forget, (route) => false);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AppText(
                      text: 'Recovery Password',
                      font: FontWeight.w400,
                      size: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                AppBtn(text: 'Sign In'),
                SizedBox(height: 20.h),
                Google(text: 'Sign in with google'),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AppText(
                          text: 'Don’t have an account? ',
                          font: FontWeight.w400,
                          size: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (route) => false,
                            );
                          },
                          child: AppText(
                            text: 'Sign Up for free',
                            font: FontWeight.w500,
                            size: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
