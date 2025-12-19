import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  // Generate PDF bytes
  static Future<Uint8List> generatePdf({
    required String userName,
    required String userEmail,
    required double totalIncome,
    required double totalExpenses,
    required double balance,
    required List<Map<String, dynamic>> transactions,
    required List<Map<String, dynamic>> categorySpending,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Budget Buddy - Financial Report',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated for: $userName',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Email: $userEmail',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Financial Summary
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Financial Summary',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    _buildSummaryRow('Total Income', '₹${totalIncome.toStringAsFixed(2)}', PdfColors.green),
                    _buildSummaryRow('Total Expenses', '₹${totalExpenses.toStringAsFixed(2)}', PdfColors.red),
                    _buildSummaryRow('Balance', '₹${balance.toStringAsFixed(2)}',
                        balance >= 0 ? PdfColors.blue : PdfColors.red),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Category Spending (Added this section)
              if (categorySpending.isNotEmpty) ...[
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  padding: const pw.EdgeInsets.all(16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Category Spending',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      ...categorySpending.map((category) {
                        // Convert amount to double safely
                        final amount = _parseAmount(category['amount']);
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                category['name']?.toString() ?? 'Unknown',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                '₹${amount.toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.red,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // Recent Transactions
              if (transactions.isNotEmpty) ...[
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  padding: const pw.EdgeInsets.all(16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Recent Transactions',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      ...transactions.map((transaction) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                DateFormat('dd MMM').format(transaction['date'] as DateTime),
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                transaction['category']?.toString() ?? 'Unknown',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                '₹${(transaction['amount'] as double).toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: (transaction['isIncome'] as bool) ? PdfColors.green : PdfColors.red,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated by Budget Buddy App',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                '${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSummaryRow(String label, String value, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to safely parse amount to double
  static double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    if (amount is String) {
      return double.tryParse(amount) ?? 0.0;
    }
    return 0.0;
  }

  // Preview PDF
  static Future<void> previewPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}