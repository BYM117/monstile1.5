import 'package:flutter/material.dart';

class ReceiverSection extends StatefulWidget {
  final String? initialCustomerName;
  final String? initialCustomerContact;
  final String? initialCustomerBusinessNumber;

  const ReceiverSection({
    required this.initialCustomerName,
    required this.initialCustomerContact,
    required this.initialCustomerBusinessNumber, String? initialReceiverPhone, String? initialReceiverName,
  });

  @override
  _ReceiverSectionState createState() => _ReceiverSectionState();
}

class _ReceiverSectionState extends State<ReceiverSection> {
  late TextEditingController customerNameController;
  late TextEditingController customerContactController;
  late TextEditingController customerBusinessNumberController;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController(text: widget.initialCustomerName);
    customerContactController = TextEditingController(text: widget.initialCustomerContact);
    customerBusinessNumberController = TextEditingController(text: widget.initialCustomerBusinessNumber);
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerContactController.dispose();
    customerBusinessNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("수신 정보"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, {
              'customerName': customerNameController.text,
              'customerContact': customerContactController.text,
              'customerBusinessNumber': customerBusinessNumberController.text,
            });
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInputField("고객 이름", customerNameController),
          _buildInputField("고객 연락처", customerContactController),
          _buildInputField("고객 사업자등록번호", customerBusinessNumberController),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
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
