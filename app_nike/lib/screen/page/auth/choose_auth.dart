import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn.dart';
import 'package:app_nike/util/common/buttom/btn_white.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseAuth extends StatefulWidget {
  const ChooseAuth({super.key});

  @override
  State<ChooseAuth> createState() => _ChooseAuthState();
}

class _ChooseAuthState extends State<ChooseAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePng.auth),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImagePng.logo, width: 70),
                SizedBox(height: 50.h),
                TextNike(
                  text:
                      'Nike App Bringing Nike Members the best products,inspiration and stories in sport.',
                  color: Colors.white,
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    BtnWhite(
                      text: 'Join Us',
                      route: () {
                        Navigator.of(context).pushNamed(emailRegister);
                      },
                    ),
                    SizedBox(width: 20),
                    Btn(
                      text: 'Sign In',
                      route: () {
                        Navigator.of(context).pushNamed(continueRoute);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
