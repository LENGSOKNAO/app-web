import 'package:app_nike/data/product.dart';
import 'package:app_nike/util/common/buttom/arrow_black.dart';
import 'package:app_nike/util/common/buttom/search.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewArrival extends StatefulWidget {
  const NewArrival({super.key});

  @override
  State<NewArrival> createState() => _NewArrivalState();
}

class _NewArrivalState extends State<NewArrival> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  _bar(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 20.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextNike(text: 'New Arrivals', color: Colors.black),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _listProduct(''),
                  _listProduct('Shop by Collection'),
                  _listInterests(),
                  _listProduct('Recommended for You'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listProduct(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGrey(text: text, color: Colors.black),
          SizedBox(height: 20.h),
          SizedBox(
            height: 390.h,
            child: ListView.separated(
              itemCount: dataProduct.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (__, _) => SizedBox(width: 5),
              itemBuilder: (context, index) {
                final data = dataProduct[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 314.w,
                      width: 314.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(data.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'US\$${data.price.toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listInterests() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextGrey(text: 'Shop My Interests', color: Colors.black),
              Text(
                'Add Interest',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 390.h,
            child: ListView.separated(
              itemCount: dataProduct.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (__, _) => SizedBox(width: 5),
              itemBuilder: (context, index) {
                final data = dataProduct[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 314.w,
                      width: 314.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(data.image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBlack(),
        TextNike(text: 'Shop', color: Colors.black),
        Search(),
      ],
    );
  }
}
