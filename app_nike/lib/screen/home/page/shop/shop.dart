import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/data/product.dart';
import 'package:app_nike/util/common/buttom/search.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  final List<String> category = ['Men', 'Women', 'Kids'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Search(),
            _text(),
            _tabar(),
            _listBar(),
          ],
        ),
      ),
    );
  }

  Widget _listBar() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _listProduct(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(newRoute);
                  },
                  child: _page(),
                ),
                SizedBox(height: 5),
                _page1(),
                _listProduct(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _listProduct(),
                _page(),
                SizedBox(height: 5),
                _listProduct(),
                _page1(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _listProduct(),
                _page1(),
                SizedBox(height: 5),
                _page(),
                _listProduct(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabar() {
    return TabBar(
      controller: _tabController,
      // dividerHeight: 0,
      labelPadding: EdgeInsets.zero,
      unselectedLabelColor: Colors.grey.shade500,
      labelColor: Colors.black,
      indicatorColor: Colors.black,
      dividerColor: Colors.grey.shade400,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: Colors.black),
        insets: EdgeInsets.zero,
      ),
      tabs: category.map((p) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          child: Text(
            p.isNotEmpty ? p[0].toUpperCase() + p.substring(1) : p,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
        );
      }).toList(),
    );
  }

  Widget _page1() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePng.banner3),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'New & Featured',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _page() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePng.banner),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'New & Featured',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _listProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGrey(
            text: 'Must-Haves, Best Sellers & More',
            color: Colors.black,
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _text() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Shop",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25.sp),
        ),
      ),
    );
  }
}
