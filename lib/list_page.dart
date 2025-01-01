import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'document_creation_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String selectedCategory = "견적서";
  List<String> categories = ["견적서", "청구서"];
  String selectedSort = "날짜순";
  List<String> sortOptions = ["날짜순", "금액순"];
  List<Map<String, dynamic>> displayedDocuments = [];
  late Box estimateBox;
  late Box invoiceBox;

  @override
  void initState() {
    super.initState();
    initializeBoxes();
  }

  Future<void> initializeBoxes() async {
    try {
      estimateBox = await Hive.openBox('estimateDocuments');
      invoiceBox = await Hive.openBox('invoiceDocuments');
      print('Estimate Box Initialized: ${estimateBox.values.toList()}');
      print('Invoice Box Initialized: ${invoiceBox.values.toList()}');
      loadDocuments();
    } catch (e) {
      print("Box 초기화 오류: $e");
    }
  }

  void loadDocuments() {
    setState(() {
      displayedDocuments = selectedCategory == "견적서"
          ? List<Map<String, dynamic>>.from(estimateBox.values.cast<Map>())
          : List<Map<String, dynamic>>.from(invoiceBox.values.cast<Map>());
      sortDocuments();
    });
  }

  void filterDocuments(String keyword) {
    setState(() {
      List<Map<String, dynamic>> currentDocuments =
      selectedCategory == "견적서"
          ? List<Map<String, dynamic>>.from(estimateBox.values.cast<Map>())
          : List<Map<String, dynamic>>.from(invoiceBox.values.cast<Map>());
      displayedDocuments = currentDocuments.where((doc) {
        return (doc['customerName'] ?? '').toString().contains(keyword) ||
            (doc['documentNumber'] ?? '').toString().contains(keyword) ||
            (doc['totalAmount'] ?? '').toString().contains(keyword);
      }).toList();
      sortDocuments();
      print("Filtered documents: $displayedDocuments");
    });
  }

  void sortDocuments() {
    setState(() {
      displayedDocuments.sort((a, b) {
        if (selectedSort == "날짜순") {
          return (a['selectedDate'] ?? "").compareTo(b['selectedDate'] ?? "");
        } else {
          return (a['totalAmount'] ?? 0).compareTo(b['totalAmount'] ?? 0);
        }
      });
      print("Sorted documents: $displayedDocuments");
    });
  }

  String formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  void addOrUpdateDocument(Map<String, dynamic> updatedDocument, int? index) {
    setState(() {
      if (index == null) {
        if (selectedCategory == "견적서") {
          estimateBox.add(updatedDocument);
          print("Added to Estimate Box: ${estimateBox.values.toList()}");
        } else {
          invoiceBox.add(updatedDocument);
          print("Added to Invoice Box: ${invoiceBox.values.toList()}");
        }
      } else {
        if (selectedCategory == "견적서") {
          estimateBox.putAt(index, updatedDocument);
        } else {
          invoiceBox.putAt(index, updatedDocument);
        }
      }
      loadDocuments();
    });
  }

  void deleteDocument(int index) {
    setState(() {
      if (selectedCategory == "견적서") {
        estimateBox.deleteAt(index);
      } else {
        invoiceBox.deleteAt(index);
      }
      loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  loadDocuments();
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "검색",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  filterDocuments(value);
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: selectedSort,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                      sortDocuments();
                    });
                  },
                  items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedDocuments.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "리스트가 비어있어요 :(",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "+를 눌러 새로운 리스트를 작성하세요",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: displayedDocuments.length,
              itemBuilder: (context, index) {
                final doc = displayedDocuments[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentCreationPage(
                          category: selectedCategory,
                          onSave: (updatedDocument) {
                            addOrUpdateDocument(updatedDocument, index);
                          },
                          initialData: doc,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("삭제 확인"),
                        content: Text("이 항목을 삭제하시겠습니까?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("취소"),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteDocument(index);
                              Navigator.pop(context);
                            },
                            child: Text("삭제"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${doc['documentNumber']} ${doc['selectedDate']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatCurrency(doc['totalAmount'] ?? 0) + "원",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          doc['location'] ?? "위치 없음",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Text(doc['customerName'] ?? "고객 이름 없음"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentCreationPage(
                category: selectedCategory,
                onSave: (newDocument) {
                  addOrUpdateDocument(newDocument, null);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
