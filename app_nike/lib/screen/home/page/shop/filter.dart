import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterProduct extends StatefulWidget {
  const FilterProduct({super.key});

  @override
  State<FilterProduct> createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  // Filter state variables
  String? sortBy;
  String? selectedGender;
  String? selectedPrice;
  List<String> selectedColors = [];
  List<String> selectedBrands = [];

  final List<String> sortOptions = [
    'Featured',
    'Newest',
    'Price: Low-High',
    'Price: High-Low',
  ];
  final List<String> genders = ['Men', 'Women', 'Unisex'];
  final List<Map<String, dynamic>> colors = [
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'Brown', 'color': Colors.brown},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Pink', 'color': Colors.pink},
  ];
  final List<String> brands = ['Nike Sportswear', 'Nike Pro', 'Jordan'];
  final List<Map<String, dynamic>> priceOptions = [
    {'label': 'Under \$50', 'min': 0.0, 'max': 50.0},
    {'label': '\$50-\$100', 'min': 50.0, 'max': 100.0},
    {'label': '\$100-\$200', 'min': 100.0, 'max': 200.0},
    {'label': '\$200+', 'min': 200.0, 'max': double.infinity},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Filter',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSortByFilter(),
            SizedBox(height: 20.h),
            Container(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 20.h),
            _buildGenderFilter(),
            SizedBox(height: 20.h),
            Container(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 20.h),
            _buildPriceFilter(),
            SizedBox(height: 20.h),
            Container(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 20.h),
            _buildColorFilter(),
            SizedBox(height: 20.h),
            Container(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 20.h),
            _buildBrandFilter(),
            SizedBox(height: 20.h),
            Container(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 20.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSortByFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sortOptions.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.4,
                  child: Radio<String>(
                    value: option,
                    groupValue: sortBy, // Fixed to use sortBy
                    onChanged: (String? value) {
                      setState(() {
                        sortBy = value;
                      });
                    },
                    activeColor: Colors.black,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sortBy = option;
                    });
                  },
                  child: Text(option, style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenderFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: genders.map((option) {
            bool isChecked = selectedGender == option;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          selectedGender = newValue == true ? option : null;
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      side: BorderSide(width: 1, color: Colors.grey.shade500),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = selectedGender == option ? null : option;
                    });
                  },
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shop by Price',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: priceOptions.map((priceOption) {
            final label = priceOption['label'] as String;
            final bool isChecked = selectedPrice == label;
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          selectedPrice = newValue == true ? label : null;
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      side: BorderSide(width: 1, color: Colors.grey.shade500),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPrice = selectedPrice == label ? null : label;
                    });
                  },
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorFilter() {
    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Color',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 50.w,
            runSpacing: 50.w,
            runAlignment: WrapAlignment.center,
            children: colors.map((colorData) {
              final colorName = colorData['name'] as String;
              final colorValue = colorData['color'] as Color;
              final isSelected = selectedColors.contains(colorName);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedColors.remove(colorName);
                    } else {
                      selectedColors.add(colorName);
                    }
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: colorValue,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check, color: Colors.white, size: 16.sp),
                      ],
                    ),
                    SizedBox(height: 4.h), // Space between circle and text
                    Text(
                      colorName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Adjust color as needed
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand', // Fixed title from 'Gender' to 'Brand'
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: brands.map((option) {
            bool isChecked = selectedBrands.contains(option);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue == true) {
                            selectedBrands.add(option);
                          } else {
                            selectedBrands.remove(option);
                          }
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      side: BorderSide(width: 1, color: Colors.grey.shade500),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedBrands.contains(option)) {
                        selectedBrands.remove(option);
                      } else {
                        selectedBrands.add(option);
                      }
                    });
                  },
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              sortBy = null;
              selectedGender = null;
              selectedPrice = null;
              selectedColors.clear();
              selectedBrands.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.9),
            foregroundColor: Colors.black,
            minimumSize: Size(150.w, 48.h),
          ),
          child: Text('Reset', style: TextStyle(fontSize: 16.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            double? priceMin;
            double? priceMax;
            if (selectedPrice != null) {
              final priceOption = priceOptions.firstWhere(
                (option) => option['label'] == selectedPrice,
                orElse: () => {'min': 0.0, 'max': double.infinity},
              );
              priceMin = priceOption['min'] as double;
              priceMax = priceOption['max'] as double;
            }

            final filterParams = {
              'sortBy': sortBy,
              'gender': selectedGender,
              'priceMin': priceMin,
              'priceMax': priceMax,
              'colors': selectedColors,
              'brands': selectedBrands,
            };
            Navigator.pop(context, filterParams);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: Size(150.w, 48.h),
          ),
          child: Text('Apply', style: TextStyle(fontSize: 16.sp)),
        ),
      ],
    );
  }
}
