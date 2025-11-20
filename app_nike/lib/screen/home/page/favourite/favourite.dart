import 'package:app_nike/model/product.dart';
import 'package:app_nike/screen/home/page/shop/product_detial.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
              child: Text(
                'Favourites',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<ModelProduct>>(
                valueListenable: AppService.favourite,
                builder: (context, fav, _) {
                  return fav.isEmpty ? _emptyState() : _listFavorite(fav);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView _listFavorite(List<ModelProduct> fav) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (110 / 185),
        mainAxisSpacing: 5.w,
        crossAxisSpacing: 5.w,
      ),
      itemCount: fav.length,
      itemBuilder: (context, index) {
        final data = fav[index];
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
              _image(data),
              SizedBox(height: 10.h),
              _data(data),
            ],
          ),
        );
      },
    );
  }

  Widget _data(ModelProduct data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
          SizedBox(height: 5),
          Text(
            'US\$${data.price.toInt()}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            data.category.join(' '),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "${(data.colors)} colors",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "\$${data.price.toInt()} ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(ModelProduct data) {
    return Expanded(
      child: Container(
        width: 600,
        height: 600,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data.image),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              AppService.cartFavourite(data);
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10.w),
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
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Your favourite is empty. \nWhen you add products, \nthey’ll appear here.',
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
