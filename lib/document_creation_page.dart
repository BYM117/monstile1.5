import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // 웹 환경 감지
import 'package:printing/printing.dart'; // PDF 공유 및 출력
import 'sections/document_info_section.dart';
import 'sections/contact_section.dart';
import 'sections/detail_section.dart';
import 'sections/receiver_section.dart';
import 'sections/memo_section.dart';
import 'sections/photo_section.dart';
import 'pdf_generator.dart';

class DocumentCreationPage extends StatefulWidget {
  final String category;
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialData;

  const DocumentCreationPage({Key? key, required this.category, required this.onSave, this.initialData}) : super(key: key);

  @override
  _DocumentCreationPageState createState() => _DocumentCreationPageState();
}

class _DocumentCreationPageState extends State<DocumentCreationPage> {
  late bool includeTax;
  late String documentNumber;
  late String? selectedDate;
  late String? location;
  late String? contactPerson;
  late String? contactPhone;
  late String? customerBusinessNumber;
  late String? customerContact;
  late String? customerName;
  late List<Map<String, dynamic>> details;
  late String? memo;
  late List<String> photos;

  @override
  void initState() {
    super.initState();
    final initialData = widget.initialData ?? {};
    includeTax = initialData['includeTax'] ?? false;
    documentNumber = initialData['documentNumber'] ?? "#001";
    selectedDate = initialData['selectedDate'];
    location = initialData['location'];
    contactPerson = initialData['contactPerson'];
    contactPhone = initialData['contactPhone'];
    customerBusinessNumber = initialData['customerBusinessNumber'];
    customerContact = initialData['customerContact'];
    customerName = initialData['customerName'];
    details = List<Map<String, dynamic>>.from(initialData['details'] ?? []);
    memo = initialData['memo'];
    photos = List<String>.from(initialData['photos'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoSection(),
          const SizedBox(height: 8),
          _buildContactSection(),
          const SizedBox(height: 8),
          _buildReceiverSection(),
          const SizedBox(height: 8),
          _buildDetailSection(),
          const SizedBox(height: 8),
          _buildTotalSection(),
          const SizedBox(height: 8),
          _buildMemoSection(),
          const SizedBox(height: 8),
          _buildPhotoSection(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  void _saveDocument() {
    final documentData = {
      'category': widget.category,
      'documentNumber': documentNumber,
      'selectedDate': selectedDate ?? "날짜 없음",
      'location': location ?? "위치 없음",
      'contactPerson': contactPerson ?? "담당자 없음",
      'contactPhone': contactPhone ?? "연락처 없음",
      'customerBusinessNumber': customerBusinessNumber ?? "사업자번호 없음",
      'customerContact': customerContact ?? "고객 연락처 없음",
      'customerName': customerName ?? "고객 이름 없음",
      'details': details.isNotEmpty ? details : [],
      'memo': memo ?? "메모 없음",
      'photos': photos.isNotEmpty ? photos : [],
      'totalAmount': details.fold<int>(0, (sum, item) => sum + ((item['finalAmount'] ?? 0) as int)),
      'includeTax': includeTax,
    };

    widget.onSave(documentData);
    Navigator.pop(context);
  }

  void _previewPdf() async {
    final documentData = {
      'category': widget.category,
      'documentNumber': documentNumber,
      'selectedDate': selectedDate ?? "날짜 없음",
      'location': location ?? "위치 없음",
      'contactPerson': contactPerson ?? "담당자 없음",
      'contactPhone': contactPhone ?? "연락처 없음",
      'customerBusinessNumber': customerBusinessNumber ?? "사업자번호 없음",
      'customerContact': customerContact ?? "고객 연락처 없음",
      'customerName': customerName ?? "고객 이름 없음",
      'details': details,
      'memo': memo,
      'totalAmount': details.fold<int>(0, (sum, item) => sum + ((item['finalAmount'] ?? 0) as int)),
    };

    final pdfData = await PdfGenerator.generatePdf(documentData);

    if (kIsWeb) {
      // 웹 환경: 다운로드 링크 제공
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
      );
    } else {
      // 네이티브 환경: PDF 미리보기 또는 공유
      await Printing.sharePdf(bytes: pdfData, filename: 'invoice.pdf');
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _previewPdf,
          icon: const Icon(Icons.visibility),
          label: const Text('미리보기'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        ElevatedButton.icon(
          onPressed: () {
            print('공유하기 실행');
          },
          icon: const Icon(Icons.share),
          label: const Text('공유하기'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        ElevatedButton.icon(
          onPressed: () {
            print('삭제 실행');
          },
          icon: const Icon(Icons.delete),
          label: const Text('삭제하기'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

Widget _buildInfoSection() {
    return _buildSectionContainer(
      title: "문서 정보",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentInfoSection(
              initialDocumentNumber: documentNumber,
              initialSelectedDate: selectedDate,
              initialLocation: location,
              initialDueDate: null,
              initialInstallationDate: null,
            ),
          ),
        );
        if (result != null && result is Map<String, String?>) {
          setState(() {
            documentNumber = result['documentNumber'] ?? documentNumber;
            selectedDate = result['selectedDate'];
            location = result['location'];
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("청구서 번호: $documentNumber"),
          Text("청구일자: ${selectedDate ?? "선택되지 않음"}"),
          Text("시공위치: ${location ?? "입력되지 않음"}"),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return _buildSectionContainer(
      title: "담당자 정보",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactSection(
              initialContactPerson: contactPerson,
              initialContactPhone: contactPhone,
            ),
          ),
        );
        if (result != null && result is Map<String, String?>) {
          setState(() {
            contactPerson = result['contactPerson'];
            contactPhone = result['contactPhone'];
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("담당자 이름: ${contactPerson ?? "선택되지 않음"}"),
          Text("담당자 연락처: ${contactPhone ?? "입력되지 않음"}"),
        ],
      ),
    );
  }

  Widget _buildReceiverSection() {
    return _buildSectionContainer(
      title: "수신자 정보",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiverSection(
              initialCustomerBusinessNumber: customerBusinessNumber,
              initialCustomerContact: customerContact,
              initialCustomerName: customerName,
            ),
          ),
        );
        if (result != null && result is Map<String, String?>) {
          setState(() {
            customerBusinessNumber = result['customerBusinessNumber'];
            customerContact = result['customerContact'];
            customerName = result['customerName'];
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("고객 이름: ${customerName ?? "입력되지 않음"}"),
          Text("고객 연락처: ${customerContact ?? "입력되지 않음"}"),
          Text("고객 사업자 번호: ${customerBusinessNumber ?? "입력되지 않음"}"),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return _buildSectionContainer(
      title: "Detail",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSection(
              initialData: details,
            ),
          ),
        );
        if (result != null && result is List<Map<String, dynamic>>) {
          setState(() {
            details = result;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...details.map((item) => Text("${item['name']}: ${item['finalAmount']} 원")),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    int total = details.fold(0, (sum, item) => sum + ((item['finalAmount'] ?? 0) as num).toInt());

    return _buildSectionContainer(
      title: "합계",
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('소계', style: TextStyle(fontSize: 16)),
              Text('₩$total', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('TAX (10%)', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: includeTax,
                    onChanged: (value) {
                      setState(() {
                        includeTax = value;
                      });
                    },
                  ),
                ],
              ),
              Text('₩${(includeTax ? total * 0.1 : 0).toInt()}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 견적금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₩${includeTax ? (total * 1.1).toInt() : total}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemoSection() {
    return _buildSectionContainer(
      title: "메모",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemoSection(initialMemo: memo),
          ),
        );
        if (result != null && result is String) {
          setState(() {
            memo = result;
          });
        }
      },
      child: Text(memo != null && memo!.isNotEmpty
          ? memo!.substring(0, memo!.length > 50 ? 50 : memo!.length) +
          (memo!.length > 50 ? '...' : '')
          : "메모가 입력되지 않았습니다."),
    );
  }

  Widget _buildPhotoSection() {
    return _buildSectionContainer(
      title: "사진 추가",
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoSection(initialPhotos: photos),
          ),
        );
        if (result != null && result is List<String>) {
          setState(() {
            photos = result;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          photos.isNotEmpty
              ? Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: photos
                .map((photo) => Image.network(
              photo,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ))
                .toList(),
          )
              : const Text("사진이 추가되지 않았습니다."),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
