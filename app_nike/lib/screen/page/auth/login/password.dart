import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn_black.dart';
import 'package:app_nike/util/common/buttom/btn_full.dart';
import 'package:app_nike/util/common/form/pass.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:app_nike/util/common/text/text_uderline.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _ = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            BtnBlack(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(ImagePng.logo, color: Colors.black87, width: 50),
                  SizedBox(height: 20.h),
                  TextNike(text: 'What’s your password?', color: Colors.black),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      TextGrey(
                        text: 'John@mail.com',
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 10),
                      TextUderline(text: 'Edit', color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PassForm(controller: _, text: "Password"),
                        SizedBox(height: 40.h),
                        TextGrey(
                          text: 'By continuing, I agree to Nike’s',
                          color: Colors.grey.shade500,
                        ),
                        Row(
                          children: [
                            TextUderline(
                              text: 'Privacy Policy',
                              color: Colors.grey.shade500,
                            ),
                            TextGrey(text: 'and', color: Colors.grey.shade500),
                            TextUderline(
                              text: 'Terms of Use.',
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        BtnFull(
                          text: 'Next',
                          route: () {
                            // if (_formkey.currentState!.validate()) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text("Valid Email")),
                            //   );
                            // }
                            Navigator.of(context).pushNamed(againRoute);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
