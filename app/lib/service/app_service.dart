import 'package:app/model/invoice.dart';
import 'package:app/model/product.dart';
import 'package:app/util/constant/route.dart';
import 'package:flutter/cupertino.dart';

class CartItem {
  final ModelProduct product;
  final String size;
  int qty;

  CartItem({required this.product, required this.size, this.qty = 1});
}

class AppService {
  // duration for splassh
  Future<void> getSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
  }

  // product
  static final List<CartItem> _product = [];
  // insert product
  static void addCart(ModelProduct p, String size) {
    final existing = _product.indexWhere(
      (item) => item.product == p && item.size == size,
    );
    if (existing >= 0) {
      _product[existing].qty++;
    } else {
      _product.add(CartItem(product: p, size: size));
    }
  }

  // detete product
  static void removeCart(ModelProduct p, String size) {
    final existing = _product.indexWhere(
      (item) => item.product == p && item.size == size,
    );

    _product.removeAt(existing);
  }

  static void deleteCart() {
    _product.clear();
  }

  // get product for show
  static List<CartItem> get product => _product;
  // get price
  static double get shopping => 40.9;
  static double get subtotal =>
      _product.fold(0.0, (sum, item) => sum + item.product.price * item.qty);
  static double get totaPrice => subtotal + shopping;
  static double get subtotalAll => totaPrice - shopping;

  // invoice
  static final List<ModelInvoice> _invoice = [];
  // insert
  static void addInvoice(ModelInvoice invoice) {
    _invoice.add(invoice);
  }

  // Update invoice status
  static void updateInvoiceStatus(String invoiceId, InvoiceStatus newStatus) {
    final index = _invoice.indexWhere((invoice) => invoice.id == invoiceId);
    if (index >= 0) {
      _invoice[index] = ModelInvoice(
        id: _invoice[index].id,
        customerName: _invoice[index].customerName,
        email: _invoice[index].email,
        phone: _invoice[index].phone,
        paymentMethod: _invoice[index].paymentMethod,
        address: _invoice[index].address,
        dataProduct: _invoice[index].dataProduct,
        total: _invoice[index].total,
        status: newStatus,
      );
    }
  }

  // Create invoice from cart
  static void createInvoiceFromCart({
    required String id,
    required String customerName,
    required String email,
    required String phone,
    required String paymentMethod,
    required String address,
    InvoiceStatus status = InvoiceStatus.pending,
  }) {
    final invoice = ModelInvoice(
      id: id,
      customerName: customerName,
      email: email,
      phone: phone,
      paymentMethod: paymentMethod,
      address: address,
      dataProduct: _product.map((item) => item.product).toList(),
      total: totaPrice,
      status: status,
    );
    addInvoice(invoice);
    deleteCart();
  }

  // get
  static List<ModelInvoice> get invoice => _invoice;
}
