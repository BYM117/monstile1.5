import 'package:flutter/material.dart';

class DocumentInfoSection extends StatefulWidget {
  final String initialDocumentNumber;
  final String? initialSelectedDate;
  final String? initialDueDate;
  final String? initialLocation;
  final String? initialInstallationDate;

  const DocumentInfoSection({
    required this.initialDocumentNumber,
    this.initialSelectedDate,
    this.initialDueDate,
    this.initialLocation,
    this.initialInstallationDate,
  });

  @override
  _DocumentInfoSectionState createState() => _DocumentInfoSectionState();
}

class _DocumentInfoSectionState extends State<DocumentInfoSection> {
  late String documentNumber;
  String? selectedDate;
  String? dueDate;
  String? location;
  String? installationDate;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    documentNumber = widget.initialDocumentNumber;
    selectedDate = widget.initialSelectedDate;
    dueDate = widget.initialDueDate;
    location = widget.initialLocation;
    installationDate = widget.initialInstallationDate;

    // 텍스트 컨트롤러 초기화
    locationController = TextEditingController(text: location);
  }

  @override
  void dispose() {
    // 메모리 누수를 방지하기 위해 컨트롤러 해제
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("세부항목"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, {
              'documentNumber': documentNumber,
              'selectedDate': selectedDate,
              'dueDate': dueDate,
              'location': locationController.text,
              'installationDate': installationDate,
            });
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField("청구서 번호", documentNumber, readOnly: true),
          _buildDateField("청구일자", selectedDate),
          _buildDateField("납부기한", dueDate),
          _buildLocationField("시공위치", locationController),
          _buildDateField("시공일자", installationDate),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? "선택하세요",
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        final formattedDate =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        if (label == "청구일자") {
                          selectedDate = formattedDate;
                        } else if (label == "납부기한") {
                          dueDate = formattedDate;
                        } else if (label == "시공일자") {
                          installationDate = formattedDate;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              onChanged: (newValue) {
                setState(() {
                  location = newValue;
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "입력하세요",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String? value, {bool readOnly = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              readOnly: readOnly,
              controller: TextEditingController(text: value),
              onChanged: (newValue) {
                setState(() {
                  if (label == "청구서 번호") {
                    documentNumber = newValue;
                  }
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "입력하세요",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
