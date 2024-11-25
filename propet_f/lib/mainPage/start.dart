// start.dart

import 'package:flutter/material.dart';
import 'package:propetsor/mainPage/main_1.dart';
import 'dart:async';

import 'package:propetsor/mainPage/main_non.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 메인 페이지로 이동
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage_1()), // 메인 페이지로 이동
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo1.png'), // 여기에 이미지 파일의 경로를 입력하세요
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Text('This is the main page'),
      ),
    );
  }
}
