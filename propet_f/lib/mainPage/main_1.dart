import 'package:flutter/material.dart';
import 'package:propetsor/calendar/calendar_1.dart';
import 'package:propetsor/chatbot/chatbot.dart';
import 'package:propetsor/mainPage/main_non.dart';
import 'package:propetsor/mypage/mypage_1.dart';
import 'package:propetsor/shop/shop_main.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../chatbot/api_service.dart';

class MainPage_1 extends StatefulWidget {
  final int initialIndex;

  const MainPage_1({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainPage_1> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<MainPage_1> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    MainNon(),
    ChatScreen(apiService: APIService()),
    MainShopPage(),
    CalendarNon(),
    MyPage_1(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 초기 인덱스를 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : PreferredSize(
        preferredSize: Size.fromHeight(56.0), // AppBar 높이 설정
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2), // 그림자의 위치 조정
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 동작
              },
            ),
            backgroundColor: Colors.white,
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage_1()),
                );
              },
              child: Container(
                height: 30, // 이미지 높이
                width: 120, // 이미지 너비, 가로 직사각형 형태로 길게
                child: Image.asset(
                  'assets/images/logo3.png', // 이미지 경로
                  fit: BoxFit.contain, // 이미지 크기 조절
                ),
              ),
            ),
            centerTitle: true, // 타이틀 중앙 정렬
            actions: [
              Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // 알림 아이콘 클릭 시 동작
                    },
                  ),
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '0', // 알림 갯수
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home" , style: TextStyle(fontFamily: 'Geekble'),),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.chat),
    title: const Text("ChatBot", style: TextStyle(fontFamily: 'Geekble')),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.shopping_bag),
    title: const Text("Shop", style: TextStyle(fontFamily: 'Geekble')),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.calendar_month),
    title: const Text("Calendar", style: TextStyle(fontFamily: 'Geekble')),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("MyPage", style: TextStyle(fontFamily: 'Geekble')),
  ),
];
