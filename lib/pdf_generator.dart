import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<Uint8List> generatePdf(Map<String, dynamic> documentData) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.notoSansKRRegular();
    final boldFont = await PdfGoogleFonts.notoSansKRBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 상단 로고 및 제목 섹션
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('몬스타일', style: pw.TextStyle(font: boldFont, fontSize: 24)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('청구서', style: pw.TextStyle(font: boldFont, fontSize: 18)),
                      pw.Text('사업자번호: 377-48-00799', style: pw.TextStyle(font: font, fontSize: 12)),
                      pw.Text('상호명: 몬스타일', style: pw.TextStyle(font: font, fontSize: 12)),
                      pw.Text('대표자: 유은규', style: pw.TextStyle(font: font, fontSize: 12)),
                      pw.Text('담당실장: ${documentData['contactPerson'] ?? "N/A"}',
                          style: pw.TextStyle(font: font, fontSize: 12)),
                      pw.Text('연락처: ${documentData['contactPhone'] ?? "N/A"}',
                          style: pw.TextStyle(font: font, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              // 수신자 정보
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('수신: ${documentData['customerName'] ?? "N/A"}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('전화번호: ${documentData['customerContact'] ?? "N/A"}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('사업자번호: ${documentData['customerBusinessNumber'] ?? "N/A"}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('청구서 #: ${documentData['documentNumber']}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('청구일자: ${documentData['selectedDate'] ?? "N/A"}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('납부기한: ${documentData['dueDate'] ?? "N/A"}',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // 품목 테이블
              pw.Table.fromTextArray(
                border: null,
                cellAlignment: pw.Alignment.centerLeft,
                headerStyle: pw.TextStyle(font: boldFont, fontSize: 12),
                cellStyle: pw.TextStyle(font: font, fontSize: 10),
                headers: ['품명', '규격', '단위', '수량', '재료비', '노무비', '금액', '비고'],
                data: documentData['details']
                    ?.map<List<dynamic>>((item) => [
                  item['name'] ?? "",
                  item['specification'] ?? "",
                  item['unit'] ?? "",
                  item['quantity'] ?? "",
                  item['materialCost'] ?? "",
                  item['laborCost'] ?? "",
                  item['finalAmount'] ?? "",
                  item['remark'] ?? "",
                ])
                    .toList() ??
                    [],
              ),
              pw.SizedBox(height: 20),
              // 합계 및 메모
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('합계', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  pw.Text('₩${documentData['totalAmount'] ?? 0}',
                      style: pw.TextStyle(font: boldFont, fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('메모: ${documentData['memo'] ?? "없음"}', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.SizedBox(height: 20),
              // 고객확인사항
              pw.Text(
                '고객확인사항:',
                style: pw.TextStyle(font: boldFont, fontSize: 14),
              ),
              pw.Bullet(
                  text: '견적서 외 공사는 별도입니다.', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Bullet(
                  text: '위 견적서는 15일간 유효합니다.', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Bullet(
                  text: '공사완료 후 1년간 무상 A/S가 가능합니다.', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Bullet(
                  text: '본사 소속 시공자가 직접 시공합니다.', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Bullet(
                  text: '지불방식: 공사계약금은 60%입니다.', style: pw.TextStyle(font: font, fontSize: 12)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
