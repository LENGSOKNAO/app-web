import 'package:app_nike/data/product.dart';
import 'package:app_nike/screen/home/page/shop/list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchShop extends StatefulWidget {
  const SearchShop({super.key});

  @override
  State<SearchShop> createState() => _SearchShopState();
}

class _SearchShopState extends State<SearchShop> {
  final TextEditingController _controller = TextEditingController();

  List<String> _list = [];
  String resultType = '';

  void _search(String query) {
    final lower = query.toLowerCase();
    setState(() {
      _list.clear();
      resultType = '';

      if (query.isEmpty) return;

      final names = dataProduct
          .where((p) => p.name.toLowerCase().contains(lower))
          .map((m) => m.name)
          .toList();

      if (names.isNotEmpty) {
        _list = names;
        resultType = 'name';
        return;
      }
      final size = dataProduct
          .expand((c) => c.sizes)
          .where((p) => p.toLowerCase().contains(lower))
          .toList();

      if (size.isNotEmpty) {
        _list = size.toSet().toList();
        resultType = 'size';
        return;
      }
      final category = dataProduct
          .expand((c) => c.category)
          .where((p) => p.toLowerCase().contains(lower))
          .toList();

      if (category.isNotEmpty) {
        _list = category.toSet().toList();
        resultType = 'category';
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: _list.isEmpty
                  ? Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _list.length > 10 ? 10 : _list.length,
                      itemBuilder: (context, index) {
                        final dataSearch = _list[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListProduct(
                                  query: dataSearch,
                                  resultType: resultType,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10,
                            ),
                            child: Text(
                              dataSearch,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
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
}
