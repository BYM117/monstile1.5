import 'package:flutter/material.dart';
import 'list_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 상단 로고
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset(
                'assets/splash_logo.png',
                width: 225,
                height: 225,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 하단 이미지
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/splash_down.png',
              width: MediaQuery.of(context).size.width, // 화면의 너비를 꽉 채움
              height: MediaQuery.of(context).size.height * 0.5, // 최대 50% 차지
              fit: BoxFit.cover, // 여백 없이 꽉 채우기
            ),
          ),
        ],
      ),
    );
  }
}
