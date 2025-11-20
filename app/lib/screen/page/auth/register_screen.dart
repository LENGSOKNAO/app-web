import 'package:app/screen/page/auth/widget/email.dart';
import 'package:app/screen/page/auth/widget/pass.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/google.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: AppBanBack(icon: Icons.arrow_back_ios_new),
                ),
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
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AppText(
                    text: 'Your Name',
                    font: FontWeight.w500,
                    size: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Email(email: 'Alisson Becker', controller: _email),
                SizedBox(height: 15.h),
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
                SizedBox(height: 15.h),
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
                SizedBox(height: 50.h),
                AppBtn(text: 'Sign Up'),
                SizedBox(height: 20.h),
                Google(text: 'Sign Up with google'),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AppText(
                          text: 'Already have an account? ',
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
                              loginRoute,
                              (route) => false,
                            );
                          },
                          child: AppText(
                            text: 'Sign in',
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
