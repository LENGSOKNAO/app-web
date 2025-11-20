import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/data/product.dart';
import 'package:app_nike/model/product.dart';
import 'package:app_nike/screen/home/page/shop/filter.dart';
import 'package:app_nike/screen/home/page/shop/product_detial.dart';
import 'package:app_nike/util/common/buttom/arrow_black.dart';
import 'package:app_nike/util/common/buttom/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListProduct extends StatelessWidget {
  final String query;
  final String resultType;
  final Map<String, dynamic>? filterParams;

  const ListProduct({
    super.key,
    required this.query,
    required this.resultType,
    this.filterParams,
  });

  @override
  Widget build(BuildContext context) {
    // Apply filtering based on search and filter parameters
    var filteredProducts = dataProduct.where((product) {
      final lowerQuery = query.toLowerCase();
      bool matchesQuery = false;

      // Search bar filtering
      if (resultType == 'name') {
        matchesQuery = product.name.toLowerCase().contains(lowerQuery);
      } else if (resultType == 'category') {
        matchesQuery = product.category.any(
          (cat) => cat.toLowerCase().contains(lowerQuery),
        );
      } else if (resultType == 'size') {
        matchesQuery = product.sizes.any(
          (size) => size.toLowerCase().contains(lowerQuery),
        );
      }

      // Apply filter parameters if provided
      if (filterParams != null) {
        // Gender filter
        if (filterParams!['gender'] != null &&
            !product.category
                .map((cat) => cat.toLowerCase())
                .any(
                  (cat) => cat.contains(
                    filterParams!['gender'].toString().toLowerCase(),
                  ),
                )) {
          return false;
        }

        // Price filter
        if (filterParams!['priceMin'] != null ||
            filterParams!['priceMax'] != null) {
          final priceMin = filterParams!['priceMin'] as double? ?? 0.0;
          final priceMax =
              filterParams!['priceMax'] as double? ?? double.infinity;
          if (product.price < priceMin || product.price > priceMax) {
            return false;
          }
        }

        // Color filter
        if (filterParams!['colors'].isNotEmpty) {
          final lowerProductColors = product.colors
              .toLowerCase(); // Single string
          final selectedColors = (filterParams!['colors'] as List<String>)
              .map((color) => color.toLowerCase())
              .toList();
          matchesQuery =
              matchesQuery &&
              selectedColors.any(
                (color) =>
                    lowerProductColors.contains(
                      color,
                    ) || // Check for exact color
                    (color.contains('/') &&
                        lowerProductColors.contains(
                          color.split('/').first,
                        )) || // Check first part of hyphenated color
                    (color.contains('/') &&
                        lowerProductColors.contains(color.split('/').last)),
              ); // Check second part of hyphenated color
        }

        // Brand filter
        if (filterParams!['brand'] != null &&
            product.category != filterParams!['brand']) {
          return false;
        }
      }

      return matchesQuery;
    }).toList();

    // Apply sorting
    if (filterParams?['sortBy'] == 'Price: Low-High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (filterParams?['sortBy'] == 'Price: High-Low') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (filterParams?['sortBy'] == 'Featured') {
      // Custom logic if needed (e.g., sort by a featured flag)
    } else if (filterParams?['sortBy'] == 'Newest') {
      // Custom logic if needed (e.g., sort by date)
    }

    int getColorCount(String colors) {
      if (colors.trim().isEmpty) return 0;
      return colors
          .split(",")
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .length;
    }

    String _filterText(Map<String, dynamic> filters) {
      // Show only the first applicable filter
      if (filters['gender'] != null) {
        return filters['gender'].toString();
      } else if (filters['priceMin'] != null || filters['priceMax'] != null) {
        final priceMin = filters['priceMin'] as double? ?? 0.0;
        final priceMax = filters['priceMax'] as double? ?? double.infinity;
        return priceMax == double.infinity
            ? 'Under \$${priceMin.toInt() + 50}'
            : '\$${priceMin.toInt()}-\$${priceMax.toInt()}';
      } else if (filters['colors'] != null &&
          (filters['colors'] as List).isNotEmpty) {
        return (filters['colors'] as List<String>).first;
      } else if (filters['brand'] != null) {
        return filters['brand'].toString();
      } else if (filters['sortBy'] != null) {
        return filters['sortBy'].toString();
      }
      return '';
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowBlack(),
                Text(
                  filterParams != null && filterParams!.isNotEmpty
                      ? _filterText(filterParams!)
                      : query,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final filterParams = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FilterProduct(),
                          ),
                        );
                        if (filterParams != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListProduct(
                                query: query,
                                resultType: resultType,
                                filterParams: filterParams,
                              ),
                            ),
                          );
                        }
                      },
                      child: Image.asset(ImagePng.filter),
                    ),
                    Search(),
                  ],
                ),
              ],
            ),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Text(
                        "Product not found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (110 / 185),
                        mainAxisSpacing: 5.w,
                        crossAxisSpacing: 5.w,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final data = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetial(product: data),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _image(data),
                              SizedBox(height: 10.h),
                              _data(data, getColorCount),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _data(ModelProduct data, int Function(String colors) getColorCount) {
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
            "${getColorCount(data.colors)} colors",
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
              child: Icon(Icons.favorite_border_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
