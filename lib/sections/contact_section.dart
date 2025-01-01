import 'package:flutter/material.dart';

class ContactSection extends StatefulWidget {
  final String? initialContactPerson;
  final String? initialContactPhone;

  const ContactSection({
    required this.initialContactPerson,
    required this.initialContactPhone,
  });

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late TextEditingController contactPersonController;
  late TextEditingController contactPhoneController;

  @override
  void initState() {
    super.initState();
    contactPersonController = TextEditingController(text: widget.initialContactPerson);
    contactPhoneController = TextEditingController(text: widget.initialContactPhone);
  }

  @override
  void dispose() {
    contactPersonController.dispose();
    contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("담당자 정보"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, {
              'contactPerson': contactPersonController.text,
              'contactPhone': contactPhoneController.text,
            });
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInputField("담당자 이름", contactPersonController),
          _buildInputField("담당자 전화번호", contactPhoneController),
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
