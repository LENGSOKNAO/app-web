import 'package:app_nike/model/invoice.dart';
import 'package:app_nike/model/product.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';

class AppService {
  Future<void> splash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(chooseRoute, (route) => false);
  }

  Future<void> loading(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushNamed(onboardRoute);
    }
  }

  Future<void> loadingHome(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushNamed(homeRoute);
    }
  }

  Future<void> onboard(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushNamed(accountRoute);
    }
  }

  static final ValueNotifier<List<CartItem>> product = ValueNotifier([]);

  static void cartBag(ModelProduct p, String size) {
    final addp = product.value;
    final add = addp.indexWhere((i) => i.product == p && i.size == size);
    if (add >= 0) {
      addp[add].qty++;
    } else {
      addp.add(CartItem(product: p, size: size));
    }
    product.value = List.from(addp);
  }

  static void deleteCart() {
    product.value = <CartItem>[];
  }

  static double get shopping => 10;

  static double get total {
    return product.value.fold(0, (sum, item) {
      return sum + (item.product.price * item.qty);
    });
  }

  static double get dataShopping {
    return total + shopping;
  }

  static final ValueNotifier<List<ModelProduct>> favourite = ValueNotifier([]);

  static void cartFavourite(ModelProduct p) {
    final fav = favourite.value;
    final add = fav.indexWhere((i) => i == p);
    if (add >= 0) {
      fav.removeAt(add);
    } else {
      fav.add(p);
    }
    favourite.value = List.from(fav);
  }

  static bool isFavourite(ModelProduct p) {
    return favourite.value.any((i) => i == p);
  }

  static final List<ModelInvoice> _invoice = [];

  static void addInvoice(ModelInvoice invoice) {
    _invoice.add(invoice);
  }

  static void createInvoiceFromCart({
    required String id,
    required String firstName,
    required String lastName,
    required String address,
    required String adddress2,
    required String postCode,
    required String city,
    required String country,
    required String phoneNumber,
    required String payment,
    required String delivery,
    required List<CartItem> size,
  }) {
    final invoice = ModelInvoice(
      id: id,
      firstName: firstName,
      lastName: lastName,
      address: address,
      adddress2: adddress2,
      postCode: postCode,
      city: city,
      country: country,
      phoneNumber: phoneNumber,
      total: dataShopping,
      payment: payment,
      delivery: delivery,
      size: size,
      data: product.value.map((item) => item.product).toList(),
    );
    addInvoice(invoice);
    deleteCart();
  }

  static List<ModelInvoice> get invoice => _invoice;
}

class CartItem {
  final ModelProduct product;
  final String size;
  int qty;
  CartItem({required this.product, required this.size, this.qty = 1});
}
