import 'package:flutter/material.dart';
import 'package:mons2/sections/item_page.dart'; // 경로 확인 필수

class DetailSection extends StatefulWidget {
  final List<Map<String, dynamic>> initialData;

  const DetailSection({Key? key, required this.initialData}) : super(key: key);

  @override
  _DetailSectionState createState() => _DetailSectionState();
}

class _DetailSectionState extends State<DetailSection> {
  late List<Map<String, dynamic>> items;
  static List<Map<String, dynamic>> recentItems = []; // '최근' 탭 데이터는 static으로 유지

  @override
  void initState() {
    super.initState();
    items = List.from(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('품목 추가'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, items);
          },
        ),
      ),
      body: Column(
        children: [
          _buildAddButton(),
          Expanded(child: _buildTabSection()),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemPage(), // ItemPage 호출
            ),
          );
          if (newItem != null) {
            setState(() {
              items.add(newItem);
              if (!recentItems.contains(newItem)) {
                recentItems.add(newItem);
              }
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text(
          '새로운 품목 추가',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      ),
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: '추가 품목 리스트'),
              Tab(text: '최근'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildItemList(items, isRecent: false),
                _buildItemList(recentItems, isRecent: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> itemList, {required bool isRecent}) {
    if (itemList.isEmpty) {
      return const Center(child: Text('현재 추가된 품목이 없습니다.'));
    }

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          itemList.removeAt(index);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['name']}이 삭제되었습니다.')),
                        );
                      },
                      child: const Text('삭제'),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            title: Text(item['name']),
            subtitle: Text('₩${item['finalAmount']}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () async {
                final updatedItem = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemPage(initialData: item),
                  ),
                );
                if (updatedItem != null) {
                  setState(() {
                    itemList[index] = updatedItem;
                    if (isRecent && !items.contains(updatedItem)) {
                      items.add(updatedItem);
                    }
                  });
                }
              },
            ),
            onTap: isRecent
                ? () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('추가하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (!items.contains(item)) {
                              items.add(item);
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('추가'),
                      ),
                    ],
                  );
                },
              );
            }
                : null,
          ),
        );
      },
    );
  }
}
