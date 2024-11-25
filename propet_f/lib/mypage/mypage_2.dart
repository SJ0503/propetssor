import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/mainPage/main_1.dart';
import 'package:propetsor/mypage/mychatpage.dart';
import 'package:propetsor/mypage/mypage_update.dart';
import 'package:propetsor/mypage/mypetpage.dart';

final storage = FlutterSecureStorage();

class MyPage_2 extends StatelessWidget {
  const MyPage_2({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'member');

    CherryToast.success(
      title: Text('로그아웃 성공했습니다'),
    ).show(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage_1()),
    );
  }

  Future<String?> _getUsername() async {
    String? username = await storage.read(key: 'uname');
    print('Username from storage: $username'); // 값 출력
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  FutureBuilder<String?>(
                    future: _getUsername(),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text(
                          snapshot.hasData ? "${snapshot.data}님 안녕하세요!" : '사용자 이름을 불러올 수 없습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontFamily: 'Geekble', fontSize: 25 ,color: Colors.black.withOpacity(0.7),), // 'Geekble'로 변경
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16.0), // Increased spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildButton(context, "마이 펫 관리",
                                Icons.edit_location_alt_outlined, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyPetPage()),
                                  );
                                }),
                          ),
                          Container(
                            width: 1.0,
                            height: 90.0,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: _buildButton(context, "마이 채팅 관리",
                                Icons.message_rounded, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyChatPage()),
                                  );
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0), // Increased spacing
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16.0), // Increased spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildButton(context, "찜 목록",
                                Icons.favorite_border, () {
                                  CherryToast.info(
                                    title: Text(
                                      "구현 예정입니다!",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Geekble',
                                      ),
                                    ),
                                  ).show(context);
                                }),
                          ),
                          Container(
                            width: 1.0,
                            height: 90.0,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: _buildButton(context, "로그아웃",
                                Icons.login_outlined, () {
                                  logout(context);
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0), // Increased spacing
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/back.jpg'), // 이미지 파일 경로로 변경
              fit: BoxFit.cover, // 이미지가 컨테이너를 채우도록 설정
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/pic.png'),
                    ),
                    border: Border.all(color: Colors.grey), // 보더 추가
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileUpdate()),
                      );
                    },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 1), // Border added
                          color: Colors.white, // Background color changed
                        ),
                        child: const Icon(Icons.edit, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
  Color iconColor = Color(0xFFDDA0DD); // 기본 아이콘 색상

  if (text == "마이 펫 관리") {
    iconColor = Color(0xFFB0E2FF); // 마이 펫 관리 아이콘 색상
  } else if (text == "마이 채팅 관리") {
    iconColor = Color(0xFFB0E2FF); // 마이 채팅 관리 아이콘 색상
  } else if (text == "찜 목록") {
    iconColor = Color(0xFFDDA0DD); // 찜 목록 아이콘 색상
  } else if (text == "로그아웃") {
    iconColor = Color(0xFFB0C4DE); // 로그아웃 아이콘 색상
  }

  return Column(
    children: [
      IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor), // 아이콘 색상 설정
        iconSize: 40, // Icon size increased
      ),
      const SizedBox(height: 8), // Added spacing
      Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Omyu', // 'Omyu'로 변경
        ),
      ),
    ],
  );
}
