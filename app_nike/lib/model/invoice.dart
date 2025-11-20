import 'package:app_nike/model/product.dart';
import 'package:app_nike/service/app_service.dart';

class ModelInvoice {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String adddress2;
  final String postCode;
  final String city;
  final String country;
  final String phoneNumber;
  final double total;
  String delivery;
  final String payment;
  final List<CartItem> size;

  final List<ModelProduct> data;
  ModelInvoice({
    required this.adddress2,
    required this.address,
    required this.city,
    required this.country,
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.phoneNumber,
    required this.postCode,
    required this.total,
    required this.data,
    required this.payment,
    required this.delivery,
    required this.size,
  });
}
