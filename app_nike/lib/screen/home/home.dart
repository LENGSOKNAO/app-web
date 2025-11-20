import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/screen/home/page/bag/Bag.dart';
import 'package:app_nike/screen/home/page/favourite/favourite.dart';
import 'package:app_nike/screen/home/page/home/home_page.dart';
import 'package:app_nike/screen/home/page/profile/profile.dart';
import 'package:app_nike/screen/home/page/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final List<Widget> _screen;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _screen = [HomePage(), Shop(), Favourite(), Bag(), ProfileApp()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
        unselectedLabelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14.sp,
        ),
        backgroundColor: Colors.white,
        items: [
          buildNavItem(ImagePng.home, 'Home', 0),
          buildNavItem(ImagePng.shop, 'Shop', 1),
          buildNavItem(ImagePng.favourite, 'Favourites', 2),
          buildNavItem(ImagePng.bag, 'Bag', 3),
          buildNavItem(ImagePng.profile, 'Profile', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem buildNavItem(String asset, String label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        asset,
        color: currentIndex == index ? Colors.black : Colors.grey.shade400,
      ),
      label: label,
    );
  }
}
