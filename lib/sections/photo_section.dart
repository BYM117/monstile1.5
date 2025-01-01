import 'package:flutter/material.dart';

class PhotoSection extends StatefulWidget {
  final List<String> initialPhotos;

  const PhotoSection({Key? key, required this.initialPhotos}) : super(key: key);

  @override
  _PhotoSectionState createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<PhotoSection> {
  late List<String> photos;

  @override
  void initState() {
    super.initState();
    photos = List.from(widget.initialPhotos);
  }

  void _addPhoto() async {
    // 사진 추가 기능 (예: 갤러리에서 선택)
    // 지금은 간단히 URL을 입력받는 다이얼로그로 구현
    final newPhoto = await showDialog<String>(
      context: context,
      builder: (context) {
        String photoUrl = "";
        return AlertDialog(
          title: const Text("사진 추가"),
          content: TextField(
            onChanged: (value) => photoUrl = value,
            decoration: const InputDecoration(hintText: "사진 URL 입력"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, photoUrl),
              child: const Text("추가"),
            ),
          ],
        );
      },
    );

    if (newPhoto != null && newPhoto.isNotEmpty) {
      setState(() {
        photos.add(newPhoto);
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사진 추가"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, photos);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: photos.isEmpty
                ? const Center(child: Text("추가된 사진이 없습니다."))
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.network(
                      photos[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          color: Colors.red.withOpacity(0.7),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _addPhoto,
              icon: const Icon(Icons.add),
              label: const Text("사진 추가"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
