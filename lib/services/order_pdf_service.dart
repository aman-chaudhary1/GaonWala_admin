import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';

class OrderPdfService {
  static Future<void> generateBulkOrderPdf({
    required List<Order> orders,
    required String adminName,
  }) async {
    final pdf = pw.Document();

    // Load logo
    final ByteData logoData = await rootBundle.load('assets/images/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // Create chunks of orders for summary and layout
    final totalRevenue = orders.fold<double>(0, (sum, item) => sum + (item.orderTotal?.total ?? 0));
    final generatedDate = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    // Page Settings
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(logoImage, adminName, generatedDate, orders.length),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 20),
          ...orders.map((order) => _buildOrderCard(order)).toList(),
          _buildRevenueSummary(totalRevenue, orders.length),
        ],
      ),
    );

    // Output PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Gravito_Delivery_Sheet_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  static pw.Widget _buildHeader(pw.MemoryImage logo, String adminName, String date, int count) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Image(logo, width: 60, height: 60),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('GRAVITO', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.orange)),
                    pw.Text('Multi-Vendor Grocery App', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Delivery Sheet', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Generated: $date', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Admin: $adminName', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Total Orders: $count', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.orange),
      ],
    );
  }

  static pw.Widget _buildOrderCard(Order order) {
    final shortId = order.sId?.substring((order.sId?.length ?? 0) - 6).toUpperCase() ?? 'N/A';
    final orderDate = order.orderDate != null 
        ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(order.orderDate!).toLocal()) 
        : 'N/A';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('ORDER #$shortId', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.Text('ID: ${order.sId}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('Date: $orderDate', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.BarcodeWidget(
                data: order.sId ?? '',
                barcode: pw.Barcode.qrCode(),
                width: 50,
                height: 50,
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('CUSTOMER DETAILS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900)),
                    pw.SizedBox(height: 4),
                    pw.Text(order.userID?.name ?? 'Unknown Customer', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Phone: ${order.shippingAddress?.phone ?? 'N/A'}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text('Address:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      '${order.shippingAddress?.village ?? ''}, ${order.shippingAddress?.panchayat ?? ''}, ${order.shippingAddress?.block ?? ''}',
                      style: pw.TextStyle(fontSize: 11, color: PdfColors.grey900),
                    ),
                    if (order.shippingAddress?.landmark != null)
                      pw.Text('Landmark: ${order.shippingAddress!.landmark}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ORDER SUMMARY', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900)),
                    pw.SizedBox(height: 4),
                    pw.Text('Payment: ${order.paymentMethod?.toUpperCase() ?? 'N/A'}', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Status: ${order.orderStatus?.toUpperCase() ?? 'PENDING'}', style: pw.TextStyle(fontSize: 11, color: PdfColors.blue700)),
                    pw.SizedBox(height: 8),
                    pw.Text('TOTAL AMOUNT:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs ${order.orderTotal?.total ?? 0}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('ORDERED ITEMS:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
          pw.SizedBox(height: 4),
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            cellStyle: const pw.TextStyle(fontSize: 9),
            context: null,
            data: <List<String>>[
              <String>['Product', 'Qty', 'Unit', 'Price', 'Subtotal'],
              ...order.items?.map((item) => [
                item.productName ?? 'N/A',
                item.quantity.toString(),
                item.unit ?? '',
                'Rs ${item.price ?? 0}',
                'Rs ${(item.price ?? 0) * (item.quantity ?? 1)}',
              ]).toList() ?? [],
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 150,
                height: 40,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
                child: pw.Center(child: pw.Text('Delivery Signature', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500))),
              ),
              pw.Row(
                children: [
                  pw.Container(width: 15, height: 15, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey600))),
                  pw.SizedBox(width: 5),
                  pw.Text('Delivered', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRevenueSummary(double total, int count) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(
        color: PdfColors.orange50,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('GRAND TOTAL SUMMARY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Total Orders Selected: $count', style: const pw.TextStyle(fontSize: 12)),
              pw.Text('Total Revenue: Rs $total', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 1, color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Gravito Admin - Professional Delivery Management', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }
}
