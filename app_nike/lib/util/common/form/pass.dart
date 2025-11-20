import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassForm extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  const PassForm({super.key, required this.controller, required this.text});

  @override
  State<PassForm> createState() => _PassFormState();
}

class _PassFormState extends State<PassForm> {
  bool pass = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: pass,
      obscuringCharacter: '●',
      decoration: InputDecoration(
        labelText: widget.text,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              pass = !pass;
            });
          },
          icon: Icon(
            pass
                ? Icons.remove_red_eye_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
        labelStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }
        return null;
      },
    );
  }
}
