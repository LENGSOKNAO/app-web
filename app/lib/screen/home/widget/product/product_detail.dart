import 'package:app/core/assets/png.dart';
import 'package:app/core/config/color.dart';
import 'package:app/data/product.dart';
import 'package:app/model/product.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetail extends StatefulWidget {
  final ModelProduct product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late final screenWidth = MediaQuery.of(context).size.width;
  int sized = 0;
  int _imageChange = 0;
  double ia = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _changeImage() {
    setState(() {
      _imageChange = (_imageChange + 1) % widget.product.image.length;
      print(
        'Current image index: $_imageChange, Path: ${widget.product.image[_imageChange]}',
      );
    });
  }

  void _i(DragUpdateDetails detail) {
    setState(() {
      ia += detail.delta.dx * 0.01;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 15.w,
              right: 15.w,
              top: 50.h,
              bottom: 30.h,
            ),
            child: _bar(),
          ),
          _image(),
          CustomPaint(
            painter: EllipsePainter(),
            child: SizedBox(
              width: 400,
              height: 50.47,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.translate(
                    offset: Offset(0, 20.h),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.blue,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swap_horizontal_circle_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100.h),
          _more(context),
        ],
      ),
    );
  }

  Widget _more(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'BEST SELLER',
                    font: FontWeight.w400,
                    size: 16.sp,
                    color: AppColor.blue,
                  ),
                  SizedBox(height: 7.h),
                  AppText(
                    text: widget.product.name,
                    font: FontWeight.w500,
                    size: 22.sp,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 7.h),
                  AppText(
                    text: '\$${widget.product.price}',
                    font: FontWeight.w500,
                    size: 22.sp,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    widget.product.descrition,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  AppText(
                    text: 'Gallery',
                    font: FontWeight.w400,
                    size: 22.sp,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 7.h),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2 / 2,
                    ),
                    itemCount: 6,
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
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Transform.rotate(
                                angle: -0.3,
                                child: Padding(
                                  padding: EdgeInsets.all(5.w),
                                  child: Image.asset((data.image[0])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 7.h),
                  AppText(
                    text: 'Size',
                    font: FontWeight.w400,
                    size: 22.sp,
                    color: Colors.black87,
                  ),
                  GridView.count(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    crossAxisCount: 6,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(widget.product.sizes.length, (
                      index,
                    ) {
                      final size = widget.product.sizes[index];
                      final bg = sized != index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            sized = index;
                          });
                        },
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 60) / 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bg ? Colors.grey.shade200 : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Align(
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: bg ? Color(0xff707B81) : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Price',
                            font: FontWeight.w400,
                            size: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(height: 5),
                          AppText(
                            text: '\$${widget.product.price}',
                            font: FontWeight.w500,
                            size: 18.sp,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.blue,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15.h,
                            horizontal: 30.w,
                          ),
                          child: Align(
                            child: GestureDetector(
                              onTap: () {
                                final selectedSize =
                                    widget.product.sizes[sized];
                                AppService.addCart(
                                  widget.product,
                                  selectedSize,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${widget.product.name} added to cart!",
                                    ),
                                  ),
                                );
                              },
                              child: AppText(
                                text: 'Add To Cart',
                                font: FontWeight.w500,
                                size: 18.sp,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _image() {
    String currentImage = widget.product.image.isNotEmpty
        ? widget.product.image[_imageChange]
        : '';
    return GestureDetector(
      onTap: _changeImage,
      onPanUpdate: _i,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(ia),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -0.3,
            child: Align(child: Image.asset(currentImage, width: 300.w)),
          ),
        ),
      ),
    );
  }

  Widget _bar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(homeRoute, (route) => false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),

            child: Padding(
              padding: EdgeInsets.all(15.h),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(cartRoute, (route) => false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(15.h),
              child: Image.asset(ImagePng.shop, width: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class EllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );

    canvas.clipRect(
      Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
    );
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
