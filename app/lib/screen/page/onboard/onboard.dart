import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/data/onboard.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  late final PageController _onboard;
  bool firstData = true;
  bool lastData = false;
  @override
  void initState() {
    super.initState();
    _onboard = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(ImagePng.ellipse),
                ),
                Expanded(
                  flex: 2,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        firstData = index == dataOnboard.length + 1;
                        lastData = index == dataOnboard.length - 1;
                      });
                    },
                    controller: _onboard,
                    itemCount: dataOnboard.length,
                    itemBuilder: (context, index) {
                      final data = dataOnboard[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(data.background),
                              ),
                            ),
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Image.asset(data.image),
                            ),
                          ),
                          AppText(
                            text: data.name,
                            font: FontWeight.bold,
                            size: 45.sp,
                            color: Colors.black,
                          ),
                          AppText(
                            text: data.description,
                            font: FontWeight.w400,
                            size: 20.sp,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 15.w,
            right: 15.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _onboard,
                  count: dataOnboard.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 3,
                    dotWidth: 15.w,
                    dotColor: Color(0xffE5EEF7),
                    activeDotColor: AppColor.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    lastData
                        ? Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          )
                        : _onboard.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: firstData
                        ? AppText(
                            text: 'Get Started',
                            font: FontWeight.w500,
                            size: 18.sp,
                            color: AppColor.white,
                          )
                        : AppText(
                            text: 'Next',
                            font: FontWeight.w500,
                            size: 18.sp,
                            color: AppColor.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
