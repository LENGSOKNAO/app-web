import 'package:app/model/invoice.dart';
import 'package:app/screen/home/widget/payment/invoice.dart';
import 'package:app/service/app_service.dart';
import 'package:app/util/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllInvoicesPage extends StatefulWidget {
  const AllInvoicesPage({super.key});

  @override
  _AllInvoicesPageState createState() => _AllInvoicesPageState();
}

class _AllInvoicesPageState extends State<AllInvoicesPage> {
  String _capitalizeStatus(String status) {
    return "${status[0].toUpperCase()}${status.substring(1)}";
  }

  void _updateStatus(ModelInvoice invoice, InvoiceStatus newStatus) {
    setState(() {
      AppService.updateInvoiceStatus(invoice.id, newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoices = AppService.invoice;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'All Invoices',
          font: FontWeight.w500,
          size: 18.sp,
          color: Colors.black87,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: invoices.isEmpty
            ? Center(
                child: AppText(
                  text: 'No invoices found',
                  font: FontWeight.w400,
                  size: 16.sp,
                  color: Colors.grey,
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  final invoice = invoices[index];
                  return _invoiceCard(context, invoice);
                },
              ),
      ),
    );
  }

  Widget _invoiceCard(BuildContext context, ModelInvoice invoice) {
    String statusText;
    Color statusColor;
    Color statusBgColor;
    switch (invoice.status) {
      case InvoiceStatus.pending:
        statusText = 'Pending';
        statusColor = Colors.orange.shade800;
        statusBgColor = Colors.orange.shade100;
        break;
      case InvoiceStatus.processing:
        statusText = 'Processing';
        statusColor = Colors.blue.shade800;
        statusBgColor = Colors.blue.shade100;
        break;
      case InvoiceStatus.cancelled:
        statusText = 'Cancelled';
        statusColor = Colors.red.shade800;
        statusBgColor = Colors.red.shade100;
        break;
      case InvoiceStatus.shipped:
        statusText = 'Shipped';
        statusColor = Colors.purple.shade800;
        statusBgColor = Colors.purple.shade100;
        break;
      case InvoiceStatus.delivered:
        statusText = 'Delivered';
        statusColor = Colors.green.shade800;
        statusBgColor = Colors.green.shade100;
        break;
      case InvoiceStatus.returned:
        statusText = 'Returned';
        statusColor = Colors.brown.shade800;
        statusBgColor = Colors.brown.shade100;
        break;
      case InvoiceStatus.failed:
        statusText = 'Failed';
        statusColor = Colors.redAccent.shade700;
        statusBgColor = Colors.redAccent.shade100;
        break;
      case InvoiceStatus.lost:
        statusText = 'Lost';
        statusColor = Colors.grey.shade800;
        statusBgColor = Colors.grey.shade100;
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InvoicePage(invoice: invoice),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Invoice #${invoice.id}',
                  font: FontWeight.w600,
                  size: 16.sp,
                  color: Colors.black87,
                ),
                PopupMenuButton<InvoiceStatus>(
                  onSelected: (newStatus) => _updateStatus(invoice, newStatus),
                  itemBuilder: (context) => InvoiceStatus.values
                      .map(
                        (status) => PopupMenuItem(
                          value: status,
                          child: AppText(
                            text: _capitalizeStatus(
                              status.toString().split('.').last,
                            ),
                            font: FontWeight.w500,
                            size: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      )
                      .toList(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppText(
                      text: statusText,
                      font: FontWeight.w500,
                      size: 12.sp,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            AppText(
              text: 'Customer: ${invoice.customerName}',
              font: FontWeight.w400,
              size: 14.sp,
              color: Colors.grey.shade600,
            ),
            SizedBox(height: 5.h),
            AppText(
              text: 'Address: ${invoice.address}',
              font: FontWeight.w400,
              size: 14.sp,
              color: Colors.grey.shade600,
            ),
            SizedBox(height: 5.h),
            AppText(
              text: 'Total: \$${invoice.total.toStringAsFixed(2)}',
              font: FontWeight.w500,
              size: 14.sp,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
