import 'dart:async';
import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/data/country.dart';
import 'package:app_nike/data/dataLocation.dart';
import 'package:app_nike/data/product.dart';
import 'package:app_nike/model/invoice.dart';
import 'package:app_nike/screen/home/page/bag/InvoicePage.dart';
import 'package:app_nike/screen/home/page/bag/loading.dart';
import 'package:app_nike/screen/home/page/bag/widget/form_checkout.dart';
import 'package:app_nike/screen/home/page/bag/widget/image.dart';
import 'package:app_nike/screen/home/page/bag/widget/name_product.dart';
import 'package:app_nike/screen/home/page/bag/widget/text_delivery.dart';
import 'package:app_nike/screen/home/page/shop/product_detial.dart';
import 'package:app_nike/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bag extends StatefulWidget {
  const Bag({super.key});

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  final TextEditingController _firetName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _counrty = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _delivery = TextEditingController();
  final TextEditingController _fullNameConutry = TextEditingController();
  final TextEditingController _chooseDelivery = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKeyDelivery = GlobalKey<FormState>();
  String? selectedItem;
  String _namePayment = '';
  bool _isFormValid = false;
  bool deliverSelect = false;

  List<String> _listLocation = [];
  String result = '';
  Timer? _debounce;
  bool formsubmit = false;
  bool _isPaymentDone = false;

  @override
  void initState() {
    super.initState();
    _searchLocation("");
    _location.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 100), () {
        _searchLocation(_location.text);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _location.dispose();
    _debounce?.cancel();
  }

  void _searchLocation(String query) {
    final lowerLocation = query.toLowerCase().trim();
    setState(() {
      _listLocation.clear();
      result = '';
      if (query.isEmpty) {
        _listLocation = dataLocation
            .expand((e) => e['stores'] as List<dynamic>)
            .map((e) => e['name'].toString())
            .toList();
        return;
      }

      final country = dataLocation.where(
        (country) =>
            country['country'].toString().toLowerCase().contains(lowerLocation),
      );

      if (country.isNotEmpty) {
        _listLocation = country
            .expand((c) => c['stores'] as List<dynamic>)
            .map((store) => store['name'].toString())
            .toList();
        result = 'country';
        return;
      }

      final name = dataLocation
          .expand((e) => e['stores'] as List<dynamic>)
          .where(
            (n) => n['name'].toString().toLowerCase().contains(lowerLocation),
          )
          .map((m) => m['name'].toString())
          .toList();

      if (name.isNotEmpty) {
        _listLocation = name;
        result = 'name';
      }
    });
  }

  String _formatDate(DateTime date) {
    return "${_getWeekday(date.weekday)}, ${date.day} ${_getMonth(date.month)}";
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(),
            Expanded(
              child: ValueListenableBuilder<List<CartItem>>(
                valueListenable: AppService.product,
                builder: (context, p, _) {
                  return p.isEmpty ? _emptyState() : _bagList(p);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bag',
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 40.w),
        ],
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
              Icons.shopping_bag,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Your bag is empty. \nWhen you add products, \nthey’ll appear here.',
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _inputComboBox(
    String hint,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return '$hint is required';
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ),
        hintText: hint,
        helperStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _bagList(List<CartItem> p) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: p.length,
            separatorBuilder: (__, _) => SizedBox(height: 20.h),
            itemBuilder: (context, index) {
              final item = p[index];
              final data = dataProduct[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetial(product: item.product),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageBage(
                          image: data.image,
                          route: () {
                            setState(() {
                              p.removeAt(index);
                            });
                          },
                        ),
                        SizedBox(width: 15.w),
                        NameProduct(
                          name: data.name,
                          category: data.category
                              .map(
                                (p) => p.isNotEmpty
                                    ? p[0].toUpperCase() + p.substring(1)
                                    : p,
                              )
                              .join(', '),
                          size: 'Size (${item.size})',
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _selectQty(context, item),
                        Text(
                          "US\$${item.product.price * item.qty}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        _total(),
      ],
    );
  }

  Widget _total() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ),
              Text(
                'US\$${AppService.shopping.toInt()}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ),
              Text(
                'Free',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Total',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
              ),
              Text(
                'US\$${AppService.dataShopping.toInt()} + Tax',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 30),
          _btnCheckout(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _btnCheckout() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Form(
                key: _formKeyDelivery,
                onChanged: () {
                  _isFormValid = _formKey.currentState?.validate() ?? false;
                },
                child: StatefulBuilder(
                  builder: (context, setStateTest) {
                    bool isSelect = true;
                    bool isSelectP = false;
                    bool showError = false;
                    return Column(
                      children: [
                        FormCheckout(
                          text: 'Delivery',
                          select: _isFormValid ? "Delivery" : 'Select Delivery',
                          route: () {
                            setStateTest(() {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  final now = DateTime.now();
                                  final dayStart = now.add(
                                    const Duration(days: 0),
                                  );
                                  final dayEnd = now.add(
                                    const Duration(days: 4),
                                  );
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            TextDelivery(text: 'Delivery'),
                                            _checkDelivery(
                                              isSelect,
                                              (bool? newValue) {
                                                setModalState(() {
                                                  isSelect = newValue ?? false;
                                                  if (isSelect) {
                                                    isSelectP = false;
                                                    _chooseDelivery.text =
                                                        !deliverSelect
                                                        ? "Free Delivery"
                                                        : '';
                                                  } else {
                                                    _chooseDelivery.text = '';
                                                  }
                                                });
                                              },
                                              setModalState,
                                              'Free Delivery',
                                              _delivery.text.isEmpty
                                                  ? '(Arrives ${_formatDate(dayStart)} to ${_formatDate(dayEnd)})'
                                                  : _delivery.text,
                                              GestureDetector(
                                                onTap: () async {
                                                  final now = DateTime.now();
                                                  final dayStart = now.add(
                                                    const Duration(days: 0),
                                                  );
                                                  final range =
                                                      await showDateRangePicker(
                                                        context: context,
                                                        firstDate: dayStart,
                                                        lastDate: now.add(
                                                          const Duration(
                                                            days: 30,
                                                          ),
                                                        ),
                                                      );

                                                  if (range != null) {
                                                    setModalState(() {
                                                      _delivery.text =
                                                          "Arrives ${_formatDate(range.start)} to ${_formatDate(range.end)}";
                                                    });
                                                  }
                                                },
                                                child: Text('More Options'),
                                              ),
                                            ),

                                            _checkDelivery(
                                              isSelectP,
                                              (bool? newValue) {
                                                setModalState(() {
                                                  isSelectP = newValue ?? false;
                                                  if (isSelectP) {
                                                    isSelect = false;
                                                    _chooseDelivery.text =
                                                        !deliverSelect
                                                        ? _location.text
                                                        : '';
                                                  } else {
                                                    _chooseDelivery.text = '';
                                                  }
                                                });
                                              },
                                              setModalState,
                                              'Pick-Up',
                                              _location.text.isEmpty
                                                  ? 'Find a Location'
                                                  : _location.text,
                                              GestureDetector(
                                                onTap: () {
                                                  _chooseLocation(
                                                    context,
                                                    setModalState,
                                                  );
                                                },
                                                child: Text('More Options'),
                                              ),
                                            ),

                                            _isFormValid
                                                ? _formShowData()
                                                : _deliverDetail(),
                                            if (showError && !_isFormValid)
                                              _errorAddress(),
                                            Spacer(),
                                            _btnChange(
                                              () {
                                                if ((isSelectP || isSelect) &&
                                                    _formKeyDelivery
                                                        .currentState!
                                                        .validate() &&
                                                    _isFormValid) {
                                                  _formKeyDelivery.currentState!
                                                      .save();

                                                  Navigator.of(context).pop();
                                                } else {
                                                  setModalState(() {
                                                    showError = true;
                                                  });
                                                }
                                              },
                                              'Continue',
                                              true,
                                            ),
                                            _btnChange(
                                              () {
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.8,
                                                      child: _form(
                                                        setModalState,
                                                        setStateTest,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              'Address',
                                              false,
                                            ),

                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            });
                          },
                          color: _isFormValid ? false : true,
                        ),
                        FormCheckout(
                          text: 'Payment',
                          select: _isPaymentDone ? 'Payment' : 'Select Payment',
                          route: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setModeTest) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.55,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextDelivery(
                                            text: 'Add New Payment Option',
                                          ),
                                          SizedBox(height: 15.h),
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    width: double.infinity,
                                                    child: StatefulBuilder(
                                                      builder: (context, setModalState) {
                                                        return Column(
                                                          children: [
                                                            TextDelivery(
                                                              text:
                                                                  'Add Credit Card',
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        25.w,
                                                                    vertical:
                                                                        25,
                                                                  ),
                                                              child: Column(
                                                                children: [
                                                                  _inputCredit(
                                                                    'Enter Credit Card Number',
                                                                    Icons
                                                                        .camera_alt_outlined,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: _inputCredit(
                                                                          'MM/YY',
                                                                          Icons
                                                                              .date_range_outlined,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: _inputCredit(
                                                                          'CVV',
                                                                          Icons
                                                                              .password,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    vertical:
                                                                        20.h,
                                                                  ),
                                                              child: _btnChange(
                                                                () {
                                                                  showModalBottomSheet(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    context:
                                                                        context,
                                                                    isScrollControlled:
                                                                        true,
                                                                    builder: (context) {
                                                                      return SizedBox(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            MediaQuery.of(
                                                                              context,
                                                                            ).size.height *
                                                                            0.7,
                                                                        child: _form(
                                                                          setModalState,
                                                                          setStateTest,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                'Continue',
                                                                true,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: _btnPayway('Pick-Up'),
                                          ),
                                          SizedBox(height: 15.h),
                                          GestureDetector(
                                            onTap: () {
                                              setModeTest(() {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      _namePayment = 'PayPal';
                                                      return PaypalCheckoutView(
                                                        sandboxMode: true,
                                                        clientId:
                                                            "ATP7ssexb2P8hV3ZJADitKWo0r9IGrB_9vAqu1sF6R9gcEgGO3xXZCVsDCmIRD1pGnL8RrckmN6ZB_kP",
                                                        secretKey:
                                                            "EL-C8f1e46A6zrPgUSC77i9E6nbFu02-hR60aS6rJ3gsZcdIKMz-WC-JraFltE5-3LQyi8uuf97O6TBn",
                                                        transactions: [
                                                          {
                                                            "amount": {
                                                              "total": AppService
                                                                  .dataShopping,
                                                              "currency": "USD",
                                                            },
                                                            "description":
                                                                "Payment from My Store",
                                                          },
                                                        ],
                                                        note:
                                                            "Thank you for your purchase!",
                                                        onSuccess: (Map params) async {
                                                          final invoice = ModelInvoice(
                                                            adddress2:
                                                                _address2.text,
                                                            address:
                                                                _address.text,
                                                            city: _city.text,
                                                            country:
                                                                _counrty.text,
                                                            firstName:
                                                                _firetName.text,
                                                            id: DateTime.now()
                                                                .millisecondsSinceEpoch
                                                                .toString(),
                                                            lastName:
                                                                _lastName.text,
                                                            phoneNumber:
                                                                _phone.text,
                                                            postCode:
                                                                _postCode.text,
                                                            total: AppService
                                                                .dataShopping,
                                                            data: AppService
                                                                .product
                                                                .value
                                                                .map(
                                                                  (c) =>
                                                                      c.product,
                                                                )
                                                                .toList(),
                                                            size: AppService
                                                                .product
                                                                .value,
                                                            delivery:
                                                                _chooseDelivery
                                                                    .text,
                                                            payment:
                                                                _namePayment,
                                                          );
                                                          AppService.addInvoice(
                                                            invoice,
                                                          );
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                          setStateTest(() {
                                                            _isPaymentDone =
                                                                true;
                                                          });
                                                        },
                                                        onError: (error) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Payment failed: $error",
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        onCancel: () {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                "Payment was cancelled",
                                                              ),
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                );
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100.r,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 20,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 5,
                                                            ),
                                                        child: Align(
                                                          child: Image.asset(
                                                            ImagePng.paypal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.h),
                                          _btnPayway('Add Promo Code'),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          color: _isPaymentDone ? false : true,
                        ),
                        FormCheckout(
                          text: 'Purchase Summary',
                          select: 'US\$${AppService.dataShopping}',
                          route: () {},
                          color: false,
                        ),
                        SizedBox(height: 10.h),
                        _textSubmit(),
                        _btnChange(
                          () async {
                            if (_isPaymentDone && _isFormValid) {
                              if (_formKeyDelivery.currentState!.validate()) {
                                _formKeyDelivery.currentState!.save();

                                final invoice = ModelInvoice(
                                  adddress2: _address2.text,
                                  address: _address.text,
                                  city: _city.text,
                                  country: _counrty.text,
                                  firstName: _firetName.text,
                                  id: DateTime.now().microsecondsSinceEpoch
                                      .toString(),
                                  lastName: _lastName.text,
                                  phoneNumber: _phone.text,
                                  postCode: _postCode.text,
                                  total: AppService.dataShopping,
                                  data: AppService.product.value
                                      .map((c) => c.product)
                                      .toList(),
                                  payment: _namePayment,
                                  delivery: _chooseDelivery.text,
                                  size: AppService.product.value,
                                );

                                AppService.addInvoice(invoice);
                                AppService.deleteCart();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Loading(),
                                  ),
                                );
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InvoicePage(invoice: invoice),
                                  ),
                                );
                              }
                            } else {
                              return;
                            }
                          },
                          'Submit Payment',
                          _isPaymentDone && _isFormValid ? true : false,
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Align(
          child: Text(
            'Checkout',
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _form(StateSetter setModalState, StateSetter setStateTest) {
    return StatefulBuilder(
      builder: (context, setMode) {
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: () {
              setMode(() {
                _isFormValid = _formKey.currentState?.validate() ?? false;
              });
              setModalState(() {});
              setStateTest(() {});
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Delivery Addres',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setMode(() {
                              _formKey.currentState?.reset();
                              _isFormValid = false;
                              Navigator.of(context).pop();
                            });
                          },

                          child: Icon(Icons.remove_outlined, size: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 25.w,
                      ),
                      child: Column(
                        children: [
                          _inputFirstName(),
                          SizedBox(height: 14.h),
                          _inputLastName(),
                          SizedBox(height: 14.h),
                          _inputAddress(),
                          SizedBox(height: 14.h),
                          _inputAddress2(),
                          SizedBox(height: 14.h),
                          _inputPostCode(),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(flex: 6, child: _inputCity()),
                              SizedBox(width: 14.h),
                              Expanded(
                                flex: 4,
                                child: _inputComboBox(
                                  'Country',
                                  countryCodes,
                                  selectedItem,
                                  (value) {
                                    setState(() {
                                      selectedItem = value;
                                      _counrty.text = value ?? '';
                                      _fullNameConutry.text =
                                          countryNames[value] ?? '';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          _inputPhone(),
                          SizedBox(height: 14.h),
                          _showInputCountry(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: _btnChange(
                    () {
                      setMode(() {
                        formsubmit = true;
                        _isFormValid =
                            _formKey.currentState?.validate() ?? false;
                        if (_isFormValid) {
                          Navigator.of(context).pop();
                        } else {
                          _formKey.currentState?.reset();
                        }
                      });
                    },
                    'Add Delivery Address',
                    _isFormValid ? true : false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showInputCountry() {
    return TextFormField(
      readOnly: true,
      enableInteractiveSelection: false,
      controller: _fullNameConutry,

      decoration: InputDecoration(
        hintText: 'Country',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputPhone() {
    return TextFormField(
      controller: _phone,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Phone Number is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'Phone Number',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputCity() {
    return TextFormField(
      controller: _city,
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'City is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'City',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputPostCode() {
    return TextFormField(
      controller: _postCode,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Postal code is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'Postal code',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputAddress2() {
    return TextFormField(
      controller: _address2,
      decoration: InputDecoration(
        hintText: 'Address Line 2 (Optional)',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputAddress() {
    return TextFormField(
      controller: _address,
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Address Line is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'Address Line',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputLastName() {
    return TextFormField(
      controller: _lastName,
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Last Name is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'Last Name',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _inputFirstName() {
    return TextFormField(
      controller: _firetName,
      validator: (value) {
        if (!formsubmit) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'First Name is required';
        }
        return null;
      },
      onChanged: (value) {
        if (formsubmit) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'First Name',
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ), // keep height fixed
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }

  Widget _errorAddress() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.red, size: 20),
          SizedBox(width: 10),
          Text(
            "Enter Delivery Address",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _chooseLocation(
    BuildContext context,
    StateSetter setModalState,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  TextDelivery(text: 'Find a Location'),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 25,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _location,
                          onChanged: (value) {
                            _searchLocation(value);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Location',
                            errorStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              height: 1.2,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade500,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: _listLocation.isEmpty
                              ? const Center(child: Text('No locations found'))
                              : ListView.builder(
                                  itemCount: _listLocation.length,
                                  itemBuilder: (context, index) {
                                    final data = _listLocation[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _location.text = data;
                                        });
                                        setModalState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 40),
                                            GestureDetector(
                                              onTap: () {
                                                _location.clear();
                                                _searchLocation('');
                                                setState(() {});
                                                setModalState(() {});
                                              },
                                              child: Icon(
                                                Icons.wrong_location_sharp,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _formShowData() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CheckboxTheme(
            data: CheckboxThemeData(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            ),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: true,
                onChanged: (bool? val) {},
                activeColor: Colors.black,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                side: BorderSide(width: 1, color: Colors.grey.shade500),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 90,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _textShowForm(_firetName.text, Colors.black),
                        SizedBox(width: 5),
                        _textShowForm('${_lastName.text},', Colors.black),
                        SizedBox(width: 10),
                        _textShowForm(_phone.text, Colors.black),
                      ],
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        _textShowForm(_address.text, Colors.grey.shade500),
                        _textShowForm(_address2.text, Colors.grey.shade500),
                      ],
                    ),
                    _textShowForm(_counrty.text, Colors.grey.shade500),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _textShowForm(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
        color: color,
      ),
    );
  }

  Widget _inputCredit(String text, IconData icon) {
    return TextField(
      controller: _firetName,
      keyboardType: TextInputType.phone,
      obscureText: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: text,
        helperStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      ),
    );
  }

  Widget _btnPayway(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Align(
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliverDetail() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Details',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkDelivery(
    bool isSelect,
    Function(bool?) onChanged,
    StateSetter setModalState,
    String text,
    String d,
    Widget link,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade500)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Row(
          children: [
            CheckboxTheme(
              data: CheckboxThemeData(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              ),
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: isSelect,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  side: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    d,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            link,
          ],
        ),
      ),
    );
  }

  Widget _textSubmit() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Text(
        'By tapping ‘Submit Payment’ , I agree to the Terms of Sale.',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _btnChange(VoidCallback route, String text, bool color) {
    return GestureDetector(
      onTap: route,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: color ? Colors.black : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                color: color ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectQty(BuildContext context, CartItem item) {
    return GestureDetector(
      onTap: () async {
        final selected = await showModalBottomSheet<int>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Quantity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        final number = index + 1;
                        return ListTile(
                          title: Center(
                            child: Text(
                              '$number',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          onTap: () => Navigator.pop(context, number),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );

        if (selected != null) {
          setState(() {
            item.qty = selected;
          });
        }
      },
      child: Row(
        children: [
          Text(
            'Qty',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
          ),
          SizedBox(width: 5),
          Text(
            '${item.qty}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp),
          ),
          SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_down_sharp, size: 40),
        ],
      ),
    );
  }
}
