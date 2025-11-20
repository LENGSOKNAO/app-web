import 'package:app/model/invoice.dart';
import 'package:app/screen/home/widget/payment/invoice.dart';
import 'package:app/screen/home/widget/payment/widget/email.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:app/util/constant/route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController(
    text: "Alisson Becker",
  );
  final TextEditingController _email = TextEditingController(
    text: "rumenhussen@gmail.com",
  );
  final TextEditingController _phone = TextEditingController(
    text: "+88-692 -764-269",
  );
  final TextEditingController _address = TextEditingController(
    text: "Newahall St 36, London, 12908 - UK",
  );
  String payment = "Cash on Delivery";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(children: [_bar(context)]),
                  ),
                ),
              ),
            ),
            _form(),
            Spacer(),
            _total(context),
          ],
        ),
      ),
    );
  }

  Widget _total(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Subtotal',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.grey.shade500,
                  ),
                  AppText(
                    text: '\$${AppService.subtotal}',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Shopping',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.grey.shade500,
                  ),
                  AppText(
                    text: '\$${AppService.shopping}',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                ],
              ),
              SizedBox(height: 24),
              DottedLine(dashColor: Colors.grey.shade500, dashLength: 5),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Total Cost',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                  AppText(
                    text: '\$${AppService.totaPrice}',
                    font: FontWeight.w500,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                ],
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final invoice = ModelInvoice(
                      paymentMethod: payment,
                      address: _address.text,
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      customerName: _name.text,
                      email: _email.text,
                      phone: _phone.text,
                      dataProduct: AppService.product
                          .map((cartItem) => cartItem.product)
                          .toList(),
                      total: AppService.totaPrice,
                    );

                    AppService.addInvoice(invoice);
                    AppService.deleteCart();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invoice #${invoice.id} created!"),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoicePage(invoice: invoice),
                      ),
                    );
                  }
                },
                child: GestureDetector(child: AppBtn(text: 'Payment')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(cartRoute, (route) => false);
        },
        child: AppBanBack(icon: Icons.arrow_back_ios_new),
      ),
      title: AppText(
        text: 'My Cart',
        font: FontWeight.w500,
        size: 18.sp,
        color: Colors.black87,
      ),
      centerTitle: true,
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Contact Information',
                  font: FontWeight.w500,
                  size: 16.sp,
                  color: Colors.black87,
                ),
                Email(
                  email: _name,
                  text: 'Your Name',
                  icon: Icons.mail_outline_outlined,
                ),
                Email(
                  email: _email,
                  text: 'Email',
                  icon: Icons.mail_outline_outlined,
                ),
                Email(
                  email: _address,
                  text: 'Addrees',
                  icon: Icons.mail_outline_outlined,
                ),
                Email(email: _phone, text: 'Phone', icon: Icons.phone),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: payment,
                  items: ["Cash on Delivery", "Credit Card", "Paypal"]
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => payment = value!),
                  decoration: InputDecoration(
                    labelText: "Payment Method",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
