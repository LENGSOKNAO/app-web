import 'package:app/screen/home/widget/home.dart';
import 'package:app/screen/home/widget/payment/checkout.dart';
import 'package:app/screen/home/widget/product/cart.dart';
import 'package:app/screen/page/auth/forgot_password.dart';
import 'package:app/screen/page/auth/login_screen.dart';
import 'package:app/screen/page/auth/register_screen.dart';
import 'package:app/screen/page/onboard/onboard.dart';
import 'package:app/screen/page/splash/splash.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          onboardRoute: (context) => const Onboard(),
          loginRoute: (context) => const LoginScreen(),
          registerRoute: (context) => const RegisterScreen(),
          forget: (context) => const ForgotPassword(),
          homeRoute: (context) => const Home(),
          cartRoute: (context) => const CartProduct(),
          checkoutRoute: (context) => const Checkout(),
        },

        home: Splash(),
      ),
    );
  }
}
