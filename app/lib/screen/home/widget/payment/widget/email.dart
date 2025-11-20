import 'package:app/util/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Email extends StatefulWidget {
  final TextEditingController email;
  final String text;
  final IconData icon;
  const Email({
    super.key,
    required this.email,
    required this.text,
    required this.icon,
  });

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.icon, size: 20),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? SizedBox(
                    width: 200.w,
                    child: TextField(
                      controller: widget.email,
                      style: TextStyle(fontSize: 16.sp),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    child: SizedBox(
                      width: 200.w,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: AppText(
                          text: widget.email.text,
                          font: FontWeight.w400,
                          size: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
            AppText(
              text: widget.text,
              font: FontWeight.w400,
              size: 12.sp,
              color: Colors.grey.shade500,
            ),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
          child: Icon(
            isEditing ? Icons.done : Icons.mode_edit_outline_outlined,
            size: 30,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
