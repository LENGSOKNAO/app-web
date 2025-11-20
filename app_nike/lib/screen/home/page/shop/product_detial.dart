import 'package:app_nike/data/product.dart';
import 'package:app_nike/model/product.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:app_nike/util/common/buttom/arrow_black.dart';
import 'package:app_nike/util/common/buttom/search.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<CartItem> bagProducts = [];
List<ModelProduct> favoriteProducts = [];

class ProductDetial extends StatefulWidget {
  final ModelProduct product;
  const ProductDetial({super.key, required this.product});

  @override
  State<ProductDetial> createState() => _ProductDetialState();
}

class _ProductDetialState extends State<ProductDetial> {
  late String _selectImage;
  int sized = 0;

  @override
  void initState() {
    super.initState();
    _selectImage = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _image(),
                    SizedBox(height: 10),
                    _listImage(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          _tran(),
                          SizedBox(height: 5),
                          _name(),
                          SizedBox(height: 10),
                          _price(),
                          SizedBox(height: 20),
                          _description(),
                          SizedBox(height: 50),
                          _btnSize(context),
                          SizedBox(height: 20),
                          _btnBag(context),
                          SizedBox(height: 20),
                          _btnFavourite(context),
                          SizedBox(height: 50),
                          _youMidht(),
                          SizedBox(height: 30),
                          _listProduct(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  Text _youMidht() {
    return Text(
      'You Might Also Like',
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
    );
  }

  Widget _btnBag(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: _btnBlack(context, () {
        setState(() {
          final size = widget.product.sizes[sized];
          AppService.cartBag(widget.product, size);

          showDialog(
            context: context,
            barrierDismissible: true,
            useSafeArea: false,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Stack(
                              children: [
                                Align(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                                SizedBox(
                                  height: 100.w,
                                  width: 100.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.w,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Added to Bag',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '(${widget.product.name})',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          Future.delayed(Duration(seconds: 5), () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pushNamed(homeRoute);
            }
          });
        });
      }, 'Add to Bag'),
    );
  }

  Container _btnSize(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: _btnWhite(
        context,
        () {
          _sizeShowMod(context);
        },
        'Select Size',
        Icons.keyboard_arrow_down_sharp,
      ),
    );
  }

  Widget _btnFavourite(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: _btnWhite(
        context,
        () {
          setState(() {
            AppService.cartFavourite(widget.product);
          });
        },
        'Favourite',
        Icons.favorite_border_rounded,
      ),
    );
  }

  Widget _btnBlack(BuildContext context, VoidCallback route, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: TextButton(
        onPressed: route,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _btnWhite(
    BuildContext context,
    VoidCallback route,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: TextButton(
        onPressed: route,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 20),
            Icon(icon, size: 30, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _sizeShowMod(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 700.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose size to view options',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20.sp, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, thickness: 1, color: Colors.grey[200]),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: (100 / 50),
                  ),
                  itemCount: widget.product.sizes.length,
                  itemBuilder: (context, index) {
                    final size = widget.product.sizes[index];
                    final isSelected = sized != index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          sized = index;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isSelected ? Colors.blue[100] : Colors.white,
                          border: Border.all(
                            color: !isSelected
                                ? Colors.blue[400]!
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Text _description() {
    return Text(
      widget.product.description,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
    );
  }

  Text _price() {
    return Text(
      'US\$${widget.product.price.toInt()}',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
    );
  }

  Text _name() {
    return Text(
      widget.product.name,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28.sp),
    );
  }

  Text _tran() {
    return Text(
      widget.product.name,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
    );
  }

  SizedBox _listImage() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        separatorBuilder: (__, _) => SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.sizeImage.length,
        itemBuilder: (context, index) {
          final data = widget.product.sizeImage[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectImage = data;
              });
            },
            child: Image.asset(data, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Container _image() {
    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_selectImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _bar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBlack(),
        Text(
          widget.product.name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Search(),
      ],
    );
  }
}
