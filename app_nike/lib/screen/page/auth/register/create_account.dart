import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/common/buttom/btn_black.dart';
import 'package:app_nike/util/common/buttom/btn_full.dart';
import 'package:app_nike/util/common/form/btn_resend.dart';
import 'package:app_nike/util/common/form/date.dart';
import 'package:app_nike/util/common/form/email.dart';
import 'package:app_nike/util/common/form/pass.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:app_nike/util/common/text/text_uderline.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              BtnBlack(),
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70.h),
                    Image.asset(
                      ImagePng.logo,
                      color: Colors.black87,
                      width: 50,
                    ),
                    SizedBox(height: 20.h),
                    TextNike(
                      text: 'Now let’s make you a Nike Member.',
                      color: Colors.black,
                    ),
                    SizedBox(height: 20.h),
                    TextGrey(text: 'We’ve sent a code to', color: Colors.black),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        TextGrey(
                          text: 'john@mail.com',
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
                          BtnResend(controller: _email, text: "Code"),
                          SizedBox(height: 30.h),
                          Row(
                            children: [
                              Expanded(
                                child: EmailForm(
                                  controller: _email,
                                  text: "First name",
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: EmailForm(
                                  controller: _email,
                                  text: "Surname",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          PassForm(controller: _email, text: "Password"),
                          SizedBox(height: 30.h),
                          DateForm(
                            controller: _email,
                            labelText: 'Date of Birth',
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Get a Nike Member Reward on your birthday.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  activeColor: Colors.black,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextGrey(
                                  text:
                                      'Sign up for emails to get updates from Nike on products, offers and your Member benifits.',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  activeColor: Colors.black,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              Expanded(
                                child: TextGrey(
                                  text:
                                      'I agree to Nike’s Privacy Policy andTerms of Use.',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50.h),
                          BtnFull(
                            text: 'Create Account',
                            route: () {
                              // if (_formkey.currentState!.validate()) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text("Valid Email")),
                              //   );
                              // }
                              Navigator.of(context).pushNamed(success);
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
      ),
    );
  }
}
