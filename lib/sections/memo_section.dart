import 'package:flutter/material.dart';

class MemoSection extends StatefulWidget {
  final String? initialMemo;

  const MemoSection({Key? key, this.initialMemo}) : super(key: key);

  @override
  _MemoSectionState createState() => _MemoSectionState();
}

class _MemoSectionState extends State<MemoSection> {
  late TextEditingController memoController;

  @override
  void initState() {
    super.initState();
    memoController = TextEditingController(text: widget.initialMemo);
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Memo"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, memoController.text);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: memoController,
                  maxLength: 10000,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: "Enter your memo here...",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
