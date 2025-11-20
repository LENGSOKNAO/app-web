import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({super.key});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    final cart = AppService.product;

    return Scaffold(
      body: cart.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not product available',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil(homeRoute, (route) => false);
                      },
                      child: AppBtn(text: 'Back'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          AppBar(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  homeRoute,
                                  (route) => false,
                                );
                              },
                              child: AppBanBack(icon: Icons.arrow_back_ios_new),
                            ),
                            title: AppText(
                              text: 'My Cart',
                              font: FontWeight.w500,
                              size: 18.sp,
                              color: Colors.black87,
                            ),
                            centerTitle: true,
                          ),
                          SizedBox(
                            height: 500,
                            child: ListView.builder(
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                final data = cart[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Transform.rotate(
                                            angle: -0.3,
                                            child: Image.asset(
                                              data.product.image[0],
                                              width: 75,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: data.product.name,
                                            font: FontWeight.w500,
                                            size: 16.sp,
                                            color: Colors.black87,
                                          ),
                                          AppText(
                                            text:
                                                '${data.product.price * data.qty} ',
                                            font: FontWeight.w500,
                                            size: 14.sp,
                                            color: Colors.black87,
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (data.qty > 0)
                                                      data.qty--;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              AppText(
                                                text: '${data.qty}',
                                                font: FontWeight.w500,
                                                size: 14.sp,
                                                color: Colors.black87,
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    data.qty++;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColor.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        height: 60.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                              text: data.size,
                                              font: FontWeight.w500,
                                              size: 14.sp,
                                              color: Colors.black54,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  AppService.removeCart(
                                                    data.product,
                                                    data.size,
                                                  );
                                                });
                                              },
                                              child: Image.asset(
                                                ImagePng.delete,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: 'Subtotal',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.grey.shade500,
                              ),
                              AppText(
                                text: '\$${AppService.subtotal}',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: 'Shopping',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.grey.shade500,
                              ),
                              AppText(
                                text: '\$${AppService.shopping}',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          DottedLine(
                            dashColor: Colors.grey.shade500,
                            dashLength: 5,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: 'Total Cost',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.black87,
                              ),
                              AppText(
                                text: '\$${AppService.totaPrice}',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                checkoutRoute,
                                (route) => false,
                              );
                            },
                            child: AppBtn(text: 'Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
