import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/data/user.dart';
import 'package:app_nike/screen/home/page/profile/edit_profile.dart';
import 'package:app_nike/screen/home/page/profile/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  final owner = userOwner.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              _profile(),
              SizedBox(height: 20.h),
              _nameOwner(),
              SizedBox(height: 30.h),
              _editProfile(),
              SizedBox(height: 30.h),
              _list(),
              SizedBox(height: 30.h),
              Container(height: 10, color: Colors.grey.shade100),
              _listView('Inbox', 'View message'),
              _underLine(),
              _listView('Your Nike Member Rewards', '2 available'),
              Container(height: 10, color: Colors.grey.shade100),
              _listFollowing(),
              _nameDevepoler(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _nameDevepoler() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        'Leng Soknao 2025',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  SizedBox _listFollowing() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text('Following (3)'),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 150,
                    child: Image.asset(ImagePng.banner, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    width: 150,
                    child: Image.asset(ImagePng.banner, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    width: 150,
                    child: Image.asset(ImagePng.banner, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _underLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
      ),
    );
  }

  Widget _listView(String text, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textSmail(text),
                      Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_right_sharp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _list() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(ImagePng.order, 'Order', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderApp()),
            );
          }),
          _divider(),
          _icon(ImagePng.pass, 'Pass', () {}),
          _divider(),
          _icon(ImagePng.event, 'Events', () {}),
          _divider(),
          _icon(ImagePng.settings, 'Settings', () {}),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 30.h, width: 1, color: Colors.grey.shade400);
  }

  Widget _icon(String image, String text, VoidCallback route) {
    return GestureDetector(
      onTap: route,
      child: Column(
        children: [
          Image.asset(image),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _editProfile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfile()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10),
          child: _textSmail('Edit Profile'),
        ),
      ),
    );
  }

  Text _textSmail(String text) => Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
  );

  SizedBox _nameOwner() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _text(owner.firstName),
          SizedBox(width: 5),
          _text(owner.lastName),
        ],
      ),
    );
  }

  Text _text(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
    );
  }

  Align _profile() {
    return Align(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: owner.image.isNotEmpty
            ? Image.asset(owner.image, fit: BoxFit.cover)
            : Icon(Icons.camera_alt_sharp, color: Colors.white, size: 50),
      ),
    );
  }
}
