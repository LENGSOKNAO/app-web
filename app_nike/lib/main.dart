import 'package:app_nike/screen/home/home.dart';
import 'package:app_nike/screen/home/page/home/home_page.dart';
import 'package:app_nike/screen/home/page/profile/profile.dart';
import 'package:app_nike/screen/home/page/shop/new.dart';
import 'package:app_nike/screen/home/page/shop/search.dart';
import 'package:app_nike/screen/home/page/shop/shop.dart';
import 'package:app_nike/screen/page/account/account.dart';
import 'package:app_nike/screen/page/account/loading.dart';
import 'package:app_nike/screen/page/account/onboard.dart';
import 'package:app_nike/screen/page/auth/login/again.dart';
import 'package:app_nike/screen/page/auth/choose_auth.dart';
import 'package:app_nike/screen/page/auth/loading.dart';
import 'package:app_nike/screen/page/auth/login/continue.dart';
import 'package:app_nike/screen/page/auth/login/email.dart';
import 'package:app_nike/screen/page/auth/login/password.dart';
import 'package:app_nike/screen/page/auth/register/create_account.dart';
import 'package:app_nike/screen/page/auth/register/email_register.dart';
import 'package:app_nike/screen/page/auth/register/success.dart';
import 'package:app_nike/screen/page/splash/splash.dart';
import 'package:app_nike/util/constants/route.dart';
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
        routes: {
          chooseRoute: (context) => const ChooseAuth(),
          continueRoute: (context) => const Continue(),
          emailRoute: (context) => const Email(),
          emailRegister: (context) => const EmailRegister(),
          passRoute: (context) => const Password(),
          againRoute: (context) => const Again(),
          loading: (context) => const Loading(),
          create: (context) => const CreateAccount(),
          success: (context) => const Success(),
          accountRoute: (context) => const AccountSetting(),
          onboardRoute: (context) => const Onboard(),
          loadingHome: (context) => const LoadingHome(),
          homePageRoute: (context) => const HomePage(),
          homeRoute: (context) => const Home(),
          showRoute: (context) => const Shop(),
          newRoute: (context) => const NewArrival(),
          searchRoute: (context) => const SearchShop(),
          profileRoute: (context) => const ProfileApp(),
        },
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
