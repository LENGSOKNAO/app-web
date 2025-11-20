import 'package:app/model/invoice.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/app_btn.dart';
import 'package:app/util/common/tbn_back.dart';
import 'package:app/util/common/text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoicePage extends StatefulWidget {
  final ModelInvoice invoice;

  const InvoicePage({super.key, required this.invoice});

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late ModelInvoice invoice;

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
  }

  String _capitalizeStatus(String status) {
    return "${status[0].toUpperCase()}${status.substring(1)}";
  }

  void _updateStatus(InvoiceStatus newStatus) {
    setState(() {
      AppService.updateInvoiceStatus(invoice.id, newStatus);
      invoice = ModelInvoice(
        id: invoice.id,
        customerName: invoice.customerName,
        email: invoice.email,
        phone: invoice.phone,
        paymentMethod: invoice.paymentMethod,
        address: invoice.address,
        dataProduct: invoice.dataProduct,
        total: invoice.total,
        status: newStatus,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _bar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      _invoiceDetails(context),
                      _orderSummary(context),
                    ],
                  ),
                ),
              ),
            ),
            _actionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _bar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: AppBanBack(icon: Icons.arrow_back_ios_new),
      ),
      title: AppText(
        text: 'Invoice #${invoice.id}',
        font: FontWeight.w500,
        size: 18.sp,
        color: Colors.black87,
      ),
      centerTitle: true,
    );
  }

  Widget _invoiceDetails(BuildContext context) {
    String statusText;
    Color statusColor;
    switch (invoice.status) {
      case InvoiceStatus.pending:
        statusText = 'Pending';
        statusColor = Colors.orange.shade800;
        break;
      case InvoiceStatus.processing:
        statusText = 'Processing';
        statusColor = Colors.blue.shade800;
        break;
      case InvoiceStatus.cancelled:
        statusText = 'Cancelled';
        statusColor = Colors.red.shade800;
        break;
      case InvoiceStatus.shipped:
        statusText = 'Shipped';
        statusColor = Colors.purple.shade800;
        break;
      case InvoiceStatus.delivered:
        statusText = 'Delivered';
        statusColor = Colors.green.shade800;
        break;
      case InvoiceStatus.returned:
        statusText = 'Returned';
        statusColor = Colors.brown.shade800;
        break;
      case InvoiceStatus.failed:
        statusText = 'Failed';
        statusColor = Colors.redAccent.shade700;
        break;
      case InvoiceStatus.lost:
        statusText = 'Lost';
        statusColor = Colors.grey.shade800;
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Customer Information',
            font: FontWeight.w600,
            size: 16.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 10.h),
          _detailRow('Name', invoice.customerName),
          _detailRow('Email', invoice.email),
          _detailRow('Phone', invoice.phone),
          _detailRow('Address', invoice.address),
          _detailRow('Payment Method', invoice.paymentMethod),
          PopupMenuButton<InvoiceStatus>(
            onSelected: (newStatus) => _updateStatus(newStatus),
            itemBuilder: (context) => InvoiceStatus.values
                .map(
                  (status) => PopupMenuItem(
                    value: status,
                    child: AppText(
                      text: _capitalizeStatus(
                        status.toString().split('.').last,
                      ),
                      font: FontWeight.w400,
                      size: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                )
                .toList(),
            child: _detailRow('Status', statusText, valueColor: statusColor),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: label,
            font: FontWeight.w400,
            size: 14.sp,
            color: Colors.grey.shade500,
          ),
          AppText(
            text: value,
            font: FontWeight.w400,
            size: 14.sp,
            color: valueColor ?? Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _orderSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Order Summary',
            font: FontWeight.w600,
            size: 16.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 10.h),
          ...invoice.dataProduct.asMap().entries.map((entry) {
            final product = entry.value;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: product.name ?? 'Product ${entry.key + 1}',
                    font: FontWeight.w400,
                    size: 14.sp,
                    color: Colors.black87,
                  ),
                  AppText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    font: FontWeight.w400,
                    size: 14.sp,
                    color: Colors.black87,
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 10.h),
          DottedLine(dashColor: Colors.grey.shade500, dashLength: 5),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Subtotal',
                font: FontWeight.w500,
                size: 16.sp,
                color: Colors.grey.shade500,
              ),
              AppText(
                text: '\$${AppService.subtotalAll.abs().toStringAsFixed(2)}',
                font: FontWeight.w500,
                size: 16.sp,
                color: Colors.black87,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Shipping',
                font: FontWeight.w500,
                size: 16.sp,
                color: Colors.grey.shade500,
              ),
              AppText(
                text: '\$${AppService.shopping.toStringAsFixed(2)}',
                font: FontWeight.w500,
                size: 16.sp,
                color: Colors.black87,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Total Cost',
                font: FontWeight.w600,
                size: 18.sp,
                color: Colors.black87,
              ),
              AppText(
                text: '\$${invoice.total.toStringAsFixed(2)}',
                font: FontWeight.w600,
                size: 18.sp,
                color: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: AppBtn(text: 'Change Delivery Info'),
    );
  }
}
