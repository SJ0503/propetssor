import 'package:flutter/material.dart';
import 'package:propetsor/calendar/calendar_2.dart';

import 'package:propetsor/chatbot/api_service.dart';
import 'package:propetsor/chatbot/chatbot.dart';
import 'package:propetsor/mainPage/main_user.dart';
import 'package:propetsor/mypage/mypage_2.dart';
import 'package:propetsor/shop/shop_main.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage_2 extends StatefulWidget {
  final int initialIndex;

  const MainPage_2({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainPage_2> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<MainPage_2> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    MainUser(),
    ChatScreen(apiService: APIService()),
    MainShopPage(),
    CalendarUser(), // CalendarUser를 사용
    MyPage_2(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage_2()),
                );
              },
              child: Container(
                height: 30,
                width: 120,
                child: Image.asset(
                  'assets/images/logo3.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            centerTitle: true,
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
                        '0',
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
        items: _navBarItems,
      ),
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
