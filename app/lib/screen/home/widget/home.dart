import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/data/logo.dart';
import 'package:app/data/product.dart';
import 'package:app/screen/home/widget/payment/all_invoice.dart';
import 'package:app/screen/home/widget/product/product_detail.dart';
import 'package:app/screen/home/widget/widget/bar.dart';
import 'package:app/util/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: dataLogo.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SafeArea(
            child: Column(
              children: [
                _bar(),
                SizedBox(height: 50),
                _search(),
                SizedBox(height: 30),
                _list(),
                SizedBox(height: 30),
                _text(),
                SizedBox(height: 20),
                _listProduct(),
                SizedBox(height: 20),
                _textNew(),
                SizedBox(height: 20),
                _listNewProduct(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listNewProduct() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final data = dataProduct[index];
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: 'BEST SELLER',
                      font: FontWeight.w400,
                      size: 13.sp,
                      color: AppColor.blue,
                    ),
                    SizedBox(height: 5),
                    AppText(
                      text: data.name,
                      font: FontWeight.w500,
                      size: 16.sp,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 12),
                    AppText(
                      text: '\$${data.price}',
                      font: FontWeight.w500,
                      size: 16.sp,
                      color: Colors.black87,
                    ),
                  ],
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Image.asset(data.image[0], height: 53.w),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _listProduct() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.w,
        childAspectRatio: 2 / 2.7,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        final data = dataProduct[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext contex) =>
                    ProductDetail(product: dataProduct[index]),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Image.asset(data.image[0], height: 53.w),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: SizedBox(
                            width: 110.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'BEST SELLER',
                                  font: FontWeight.w400,
                                  size: 13.sp,
                                  color: AppColor.blue,
                                ),
                                SizedBox(height: 5),
                                AppText(
                                  text: data.name,
                                  font: FontWeight.w500,
                                  size: 16.sp,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 12),
                                AppText(
                                  text: '\$${data.price}',
                                  font: FontWeight.w500,
                                  size: 16.sp,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: AppColor.blue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textNew() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: 'New Arrivals',
          font: FontWeight.w500,
          size: 16.sp,
          color: Colors.black,
        ),
        AppText(
          text: 'See all',
          font: FontWeight.w400,
          size: 14.sp,
          color: AppColor.blue,
        ),
      ],
    );
  }

  Widget _text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: 'Popular Shoes',
          font: FontWeight.w500,
          size: 16.sp,
          color: Colors.black,
        ),
        AppText(
          text: 'See all',
          font: FontWeight.w400,
          size: 14.sp,
          color: AppColor.blue,
        ),
      ],
    );
  }

  Widget _list() {
    return TabBar(
      controller: _tabController,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      dividerColor: Colors.transparent,
      isScrollable: true,
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.only(right: 16),
      tabs: List.generate(dataLogo.length, (index) {
        final logo = dataLogo[index];
        return _tabController.index != index
            ? Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(logo.image),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: AppColor.blue,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Image.asset(logo.image, fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: AppText(
                          text: logo.title,
                          font: FontWeight.w500,
                          size: 14.sp,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget _search() {
    return TextField(
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'Looking for shoes',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        fillColor: AppColor.white,
        filled: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Image.asset(ImagePng.search),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _bar() {
    return Bar(
      icon: ImagePng.bar,
      icon2: ImagePng.shop,
      name: Column(
        children: [
          AppText(
            text: 'Store location',
            font: FontWeight.w400,
            size: 14.sp,
            color: Colors.grey.shade500,
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColor.orange),
              AppText(
                text: 'Mondolibug, Sylhet',
                font: FontWeight.w400,
                size: 14.sp,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
      top: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllInvoicesPage()),
        );
      },
    );
  }
}
