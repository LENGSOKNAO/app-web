import 'dart:ui';

import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final PageController _page = PageController();
  final int totalPages = 4;
  int cureentpage = 0;
  bool isLastPage = false;
  int size = 0;
  final Map<String, bool> isChecked = {
    'Mens': false,
    'Womens': false,
    'Boys': false,
    'Girls': false,
    'Running': false,
    'Lifestyle': false,
    'Basketball': false,
    'Soccer': false,
    'Jordan': false,
    'Nike By You': false,
  };
  final Map<String, bool> isCategory = {
    'Running': false,
    'Lifestyle': false,
    'Basketball': false,
    'Soccer': false,
    'Jordan': false,
    'Nike By You': false,
  };

  Set<int> selectedIndex = {};
  final List<String> sizes = [
    "4",
    "4.5",
    "5",
    "5.5",
    "6",
    "6.5",
    "7",
    "7.5",
    "8",
    "8.5",
    "9",
    "9.5",
    "10",
    "10.5",
    "11",
    "11.5",
    "12",
    "12.5",
    "13",
    "13.5",
    "14",
    "14.5",
    "15",
    "15.5",
    "16",
    "16.5",
    "17",
    "17.5",
    "18",
    "18.5",
    "19",
    "19.5",
    "20",
    "20.5",
    "21",
    "21.5",
    "22",
    "22.5",
    "23",
    "23.5",
    "24",
    "24.5",
    "25",
    "25.5",
    "26",
    "26.5",
    "27",
    "27.5",
    "28",
    "28.5",
    "29",
    "29.5",
    "30",
    "30.5",
    "31",
    "31.5",
    "32",
    "32.5",
    "33",
    "33.5",
    "34",
    "34.5",
    "35",
    "35.5",
    "36",
    "36.5",
    "37",
    "37.5",
    "38",
    "38.5",
    "39",
    "39.5",
    "40",
    "40.5",
    "41",
    "41.5",
    "42",
    "42.5",
    "43",
    "43.5",
    "44",
    "44.5",
    "45",
    "45.5",
    "46",
    "46.5",
    "47",
    "47.5",
    "48",
  ];

  @override
  Widget build(BuildContext context) {
    double progress = (cureentpage + 1) / totalPages;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _page,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                cureentpage = value;
                isLastPage = value == totalPages - 1;
              });
            },
            children: [_getStart(), _sex(), _category(), _size()],
          ),
          _bar(progress),
        ],
      ),
    );
  }

  Widget _bar(double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 3,
          backgroundColor: Colors.grey.shade700,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.white,
          ), // active color
        ),
      ),
    );
  }

  Widget _getStart() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePng.banner4),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent, Colors.black],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100),
          child: TextNike(
            text:
                'To personalize your  experience andconnect you to sport, we’ve got a few questions for you.',
            color: Colors.white,
          ),
        ),
        _btn("Get Started"),
      ],
    );
  }

  Widget _sex() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePng.banner4),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.8)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextNike(
                text: 'First up, which product do you use the most?',
                color: Colors.white,
              ),
              SizedBox(height: 40.h),
              _check(ImagePng.men, 'Mens'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Container(height: 2, color: Colors.grey.shade500),
              ),
              _check(ImagePng.women, 'Womens'),
              SizedBox(height: 40.h),
              TextNike(text: 'Any others?', color: Colors.white),
              SizedBox(height: 20.h),
              _check(ImagePng.boy, 'Boys'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Container(height: 2, color: Colors.grey.shade500),
              ),
              _check(ImagePng.glril, 'Girls'),
            ],
          ),
        ),
        isChecked.containsValue(true) ? _btn("Next") : SizedBox(),
      ],
    );
  }

  Widget _category() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePng.banner4),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.8)),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextNike(
                      text:
                          'What sports, brands and collections are you interested in?',
                      color: Colors.white,
                    ),
                    SizedBox(height: 40.h),
                    _checkCategory(ImagePng.running, 'Running'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Container(height: 2, color: Colors.grey.shade500),
                    ),
                    _checkCategory(ImagePng.lifestyle, 'Lifestyle'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Container(height: 2, color: Colors.grey.shade500),
                    ),
                    _checkCategory(ImagePng.baskeball, 'Basketball'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Container(height: 2, color: Colors.grey.shade500),
                    ),
                    _checkCategory(ImagePng.soccer, 'Soccer'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Container(height: 2, color: Colors.grey.shade500),
                    ),
                    _checkCategory(ImagePng.jordan, 'Jordan'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Container(height: 2, color: Colors.grey.shade500),
                    ),
                    _checkCategory(ImagePng.nikebyu, 'Nike By You'),
                  ],
                ),
              ),
            ],
          ),
        ),
        isCategory.containsValue(true) ? _btn("Next") : SizedBox(),
      ],
    );
  }

  Widget _size() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePng.banner4),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.8)),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100),
                child: Column(
                  children: [
                    TextNike(
                      text: 'What’s your shoe size?',
                      color: Colors.white,
                    ),
                    GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 12.w,
                        mainAxisExtent: 50,
                      ),
                      itemCount: sizes.length,
                      itemBuilder: (context, index) {
                        final data = sizes[index];
                        final select = selectedIndex.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (select) {
                                selectedIndex.remove(index);
                              } else {
                                selectedIndex.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: select
                                  ? Colors.white
                                  : Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              data,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: select ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        selectedIndex.isEmpty ? _skip("Skip") : _btn("Next"),
      ],
    );
  }

  Widget _checkCategory(String image, String text) {
    return Row(
      children: [
        Image.asset(image, width: 70.w, fit: BoxFit.contain),
        SizedBox(width: 20.w),
        TextNike(
          text: text,
          color: isCategory[text]! ? Colors.white : Colors.grey.shade500,
        ),
        Spacer(),
        Transform.scale(
          scale: 1.7,
          child: Checkbox(
            value: isCategory[text],
            onChanged: (bool? newValue) {
              setState(() {
                isCategory[text] = newValue ?? false;
              });
            },

            activeColor: Colors.white,
            checkColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            side: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _check(String image, String text) {
    return Row(
      children: [
        Image.asset(image, width: 70.w, fit: BoxFit.contain),
        SizedBox(width: 20.w),
        TextNike(
          text: text,
          color: isChecked[text]! ? Colors.white : Colors.grey.shade500,
        ),
        Spacer(),
        Transform.scale(
          scale: 1.7,
          child: Checkbox(
            value: isChecked[text],
            onChanged: (bool? newValue) {
              setState(() {
                isChecked[text] = newValue ?? false;
              });
            },

            activeColor: Colors.white,
            checkColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            side: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _btn(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: TextButton(
            onPressed: () {
              isLastPage
                  ? Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loadingHome, (route) => false)
                  : _page.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
            },
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _skip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: TextButton(
            onPressed: () {
              isLastPage
                  ? Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loadingHome, (route) => false)
                  : _page.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
            },
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
