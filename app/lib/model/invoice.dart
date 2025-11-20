import 'package:app/model/product.dart';

enum InvoiceStatus {
  pending,
  processing,
  cancelled,
  shipped,
  delivered,
  returned,
  failed,
  lost,
}

class ModelInvoice {
  final String id;
  final String customerName;
  final String email;
  final String phone;
  final List<ModelProduct> dataProduct;
  final double total;
  final String paymentMethod;
  final String address;
  final InvoiceStatus status;
  const ModelInvoice({
    required this.paymentMethod,
    required this.address,
    required this.id,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.dataProduct,
    required this.total,
    this.status = InvoiceStatus.pending,
  });
}
