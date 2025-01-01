import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const ItemPage({Key? key, this.initialData}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late String itemName;
  late String specification;
  late String unit;
  late int quantity;
  late int materialCost;
  late int laborCost;
  late String remark;
  late int discount;

  @override
  void initState() {
    super.initState();
    itemName = widget.initialData?['name'] ?? '';
    specification = widget.initialData?['specification'] ?? '';
    unit = widget.initialData?['unit'] ?? '';
    quantity = widget.initialData?['quantity'] ?? 1;
    materialCost = widget.initialData?['materialCost'] ?? 0;
    laborCost = widget.initialData?['laborCost'] ?? 0;
    remark = widget.initialData?['remark'] ?? '';
    discount = widget.initialData?['discount'] ?? 0;
  }

  int get finalAmount => ((quantity * (materialCost + laborCost)) - discount).clamp(0, double.infinity).toInt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('품목 추가'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, {
                'name': itemName,
                'specification': specification,
                'unit': unit,
                'quantity': quantity,
                'materialCost': materialCost,
                'laborCost': laborCost,
                'remark': remark,
                'discount': discount,
                'finalAmount': finalAmount,
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField('품목 이름', (value) => itemName = value, itemName),
          _buildTextField('규격', (value) => specification = value, specification),
          _buildTextField('단위', (value) => unit = value, unit),
          _buildNumberField('수량', (value) => quantity = int.tryParse(value) ?? 1, quantity.toString()),
          _buildNumberField('재료비', (value) => materialCost = int.tryParse(value) ?? 0, materialCost.toString()),
          _buildNumberField('노무비', (value) => laborCost = int.tryParse(value) ?? 0, laborCost.toString()),
          _buildTextField('비고', (value) => remark = value, remark),
          _buildNumberField('할인금액', (value) => discount = int.tryParse(value) ?? 0, discount.toString()),
          const SizedBox(height: 16),
          Text(
            '최종 금액: ₩$finalAmount',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: onChanged,
        controller: TextEditingController(text: initialValue)..selection = TextSelection.collapsed(offset: initialValue.length),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: onChanged,
        controller: TextEditingController(text: initialValue)..selection = TextSelection.collapsed(offset: initialValue.length),
      ),
    );
  }
}
