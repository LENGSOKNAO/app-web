import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/data/user.dart';
import 'package:app_nike/model/banner.dart';
import 'package:app_nike/util/common/buttom/arrow_black.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BannerDetail extends StatefulWidget {
  final ModeBanner data;
  const BannerDetail({super.key, required this.data});

  @override
  State<BannerDetail> createState() => _BannerDetailState();
}

class _BannerDetailState extends State<BannerDetail> {
  final TextEditingController _textComment = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];

  void _addComment() {
    if (_textComment.text.trim().isNotEmpty) {
      final owner = userOwner.first;
      setState(() {
        _comments.add({
          'text': _textComment.text.trim(),
          'username': '${owner.firstName} ${owner.lastName}',
          'userImage': owner.image,
          'time': DateTime.now(),
        });
        _textComment.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArrowBlack(),
                  SizedBox(height: 20),
                  _image(),
                  SizedBox(height: 70),
                  _text(),
                  SizedBox(height: 30),
                  _comment(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade500)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Comments (${_comments.length})',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 30),
            _inputComment(),
            SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final data = _comments[index];
                final time = DateFormat(
                  'MMM , d yyyy, h:mm a',
                ).format(data['time']);
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        ClipOval(
                          child: Image.asset(
                            data['userImage'],
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['username'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                data['text'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputComment() {
    return TextField(
      onSubmitted: (value) => _addComment(),
      controller: _textComment,
      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
      decoration: InputDecoration(
        hintText: 'Add a comment ...',
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
      ),
    );
  }

  Widget _text() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textName(),
          SizedBox(height: 20),
          _description(),
          SizedBox(height: 30),
          Row(
            children: [
              Image.asset(ImagePng.export),
              SizedBox(width: 30),
              Image.asset(ImagePng.share),
            ],
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.data.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _description() {
    return Text(widget.data.description, style: TextStyle(fontSize: 14.sp));
  }

  Widget _textName() {
    return SizedBox(
      width: 200.w,
      child: Text(
        widget.data.name,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
      ),
    );
  }
}
