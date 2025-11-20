import 'package:app_nike/model/invoice.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoicePage extends StatelessWidget {
  final ModelInvoice invoice;

  const InvoicePage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _thanks(context),
              Container(color: Colors.grey.shade300, height: 10),
              _total(),
              Container(color: Colors.grey.shade300, height: 10),
              _product(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _product() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textHeader('Item'),
            SizedBox(height: 20),
            ...invoice.data.asMap().entries.map((e) {
              final data = e.value;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(data.image, width: 150.w),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _text(data.name),
                        _text(data.category.join(', ')),
                        _text('\$${data.price.toStringAsFixed(2)}'),
                        _text('Size ${invoice.size[e.key].size}'),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),

            SizedBox(height: 50),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Align(
                  child: Text(
                    'View or Manage Order',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _total() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textHeader('Delivery'),
                Expanded(
                  child: SizedBox(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _text(invoice.firstName),
                            SizedBox(width: 10),
                            _text(invoice.lastName),
                          ],
                        ),

                        _text(invoice.address),
                        SizedBox(width: 10),
                        invoice.adddress2.isEmpty
                            ? SizedBox()
                            : _text(invoice.adddress2),

                        SizedBox(width: 10),
                        _text('soknao2003@gmail.com'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Container(color: Colors.grey.shade300, height: 2),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _textHeader('Purchase Number')),
                _text(invoice.id),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Container(color: Colors.grey.shade300, height: 2),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _textHeader('Payment')),
                _text(invoice.payment),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Container(color: Colors.grey.shade300, height: 2),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _text('Subtotal')),
                _text('US\$${10.00.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _text('Delivery')),
                _text('US\$${0.00.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _text('Tax')),
                _text('US\$${0.00.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _textHeader('Total')),
                _textHeader('US\$${invoice.total.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text _textHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
    );
  }

  Padding _thanks(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Thank You\n For Your Order ',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(homeRoute);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
            _text(
              'We’ve emailed you a confirmation to john@mail.com and we’ll notify you when your order has been dispatched.',
            ),
          ],
        ),
      ),
    );
  }

  Text _text(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
    );
  }
}
