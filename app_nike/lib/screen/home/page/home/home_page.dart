import 'package:app_nike/api/api.dart';
import 'package:app_nike/data/banner.dart';
import 'package:app_nike/data/product.dart';
import 'package:app_nike/model/product.dart';
import 'package:app_nike/screen/home/page/home/banner_detail.dart';
import 'package:app_nike/screen/home/page/shop/product_detial.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:app_nike/util/common/text/text.dart';
import 'package:app_nike/util/common/text/text_grey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_nike/model/model_product.dart';

List<ModelProduct> favoriteProducts = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final product = dataProduct[0];
  late final TabController _tabController = TabController(
    length: product.category.length + 1,
    vsync: this,
  );
  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                _bar(),
                SizedBox(height: 30.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _banner(0),
                        _listProduct(),
                        _banner(1),
                        SizedBox(height: 10.h),
                        _product(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _product() {
    final all = ["All"] + product.category;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerHeight: 0,
            labelPadding: EdgeInsets.zero,
            unselectedLabelColor: Colors.grey.shade500,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            dividerColor: Colors.transparent,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2, color: Colors.black),
              insets: EdgeInsets.zero,
            ),
            tabs: all.map((p) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
                child: Column(
                  children: [
                    Text(
                      p.isNotEmpty ? p[0].toUpperCase() + p.substring(1) : p,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              final p = all[_tabController.index];
              List<ModelProduct> filtered = p == 'All'
                  ? dataProduct
                  : dataProduct.where((e) => e.category.contains(p)).toList();
              final displayData = filtered.toList();
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (110 / 185),
                  mainAxisSpacing: 5.w,
                  crossAxisSpacing: 5.w,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayData.length,
                itemBuilder: (context, index) {
                  final data = displayData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetial(product: data),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(data.image),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  AppService.cartFavourite(data);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 40.w,
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      !AppService.isFavourite(data)
                                          ? Icons.favorite_border_rounded
                                          : Icons.favorite_rounded,
                                      color: !AppService.isFavourite(data)
                                          ? Colors.black
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
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
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _listProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGrey(text: 'What’s new', color: Colors.black),
          SizedBox(height: 10.h),
          TextNike(
            text: 'The latest arrivals from Nike',
            color: Colors.grey.shade500,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 390.h,
            child: FutureBuilder<List<Product>>(
              future: ApiService.getProducts(),
              builder: (context, snapshot) {
                final listProducts = snapshot.data!;

                return ListView.separated(
                  itemCount: listProducts.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (__, _) => SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    final data = listProducts[index];
                    final noImage =
                        data.varants.isNotEmpty &&
                        data.varants.first.images.isNotEmpty;

                    return GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 314.w,
                            width: 314.w,
                            child: noImage
                                ? Image.network(
                                    'http://10.0.2.2:8000/api/images/${data.varants.first.images.first.image}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
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
                            data.varants.isEmpty ||
                                    data.varants.first.price.isEmpty
                                ? "US00"
                                : 'US\$${double.parse(data.varants.first.price).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner(int n) {
    return SizedBox(
      height: 500.h,
      child: ListView.builder(
        itemCount: 1,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final data = dataBanner[n];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannerDetail(data: dataBanner[n]),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 500.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(data.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextNike(text: 'Discover', color: Colors.black),
          TextGrey(text: 'Tuesday, 3 May', color: Colors.grey.shade500),
        ],
      ),
    );
  }
}
