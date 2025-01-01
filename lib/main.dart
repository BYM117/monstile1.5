import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // Box 열기
  await Hive.openBox('estimateDocuments');
  await Hive.openBox('invoiceDocuments');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.wait([
          Hive.openBox('estimateDocuments'),
          Hive.openBox('invoiceDocuments'),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SplashScreen(); // SplashScreen을 먼저 호출
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Hive 초기화 중 오류가 발생했습니다.'),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
