import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mypage/mypage_update.dart';

class MyPage_1 extends StatelessWidget {
  const MyPage_1({Key? key}) : super(key: key);

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
                  Text(
                    "로그인 후 이용해 주세요.",
                    style: TextStyle(
                      fontSize: 25, // 폰트 크기 변경
                      fontFamily: 'Geekble', // 폰트 변경
                      color: Colors.black.withOpacity(0.7),

                    ),
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
                                Icons.edit_location_alt_outlined, () {}),
                          ),
                          Container(
                            width: 1.0,
                            height: 90.0,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: _buildButton(context, "마이 채팅 관리",
                                Icons.message_rounded, () {}),
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
                                Icons.favorite_border, () {}),
                          ),
                          Container(
                            width: 1.0,
                            height: 90.0,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: _buildButton(context, "로그인",
                                Icons.login, () {}),
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
            width: 150,
            height: 150,
            child: _buildCircleButton(context),
          ),
        )
      ],
    );
  }

  Widget _buildCircleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/logo2.png'),
          ),
          border: Border.all(color: Colors.grey), // 보더 추가
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 50, // 추가 원의 크기 조절
                height: 50, // 추가 원의 크기 조절
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // 추가 원의 색상 설정
                  border: Border.all(color: Colors.grey), // 추가 원의 테두리 색상 설정
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
  Color iconColor = Colors.deepPurpleAccent; // 아이콘 색상 변경

  if (text == "마이 펫 관리") {
    iconColor = Color(0xFFB0E2FF); // 마이 펫 관리 아이콘 색상
  } else if (text == "마이 채팅 관리") {
    iconColor = Color(0xFFB0E2FF); // 마이 채팅 관리 아이콘 색상
  } else if (text == "찜 목록") {
    iconColor = Color(0xFFDDA0DD); // 찜 목록 아이콘 색상
  } else if (text == "로그인") {
    iconColor = Color(0xFFB0C4DE); // 로그인 아이콘 색상
  }

  return Column(
    children: [
      IconButton(
        onPressed: () {
          if (text == "로그인") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (text == "마이 펫 관리" || text == "마이 채팅 관리" || text == "찜 목록") {
            CherryToast.error(
              title: Text(
                "로그인 후 이용해 주세요!",
                style: TextStyle(
                  fontFamily: 'Geekble',
                ),
              ),
            ).show(context);

          }
        },
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

