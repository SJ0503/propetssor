import 'package:flutter/material.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mainPage/main_1.dart'; // main_1.dart 파일 import 추가

class MainNon extends StatelessWidget {
  const MainNon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double containerHeight = constraints.maxHeight * 0.8; // 부모 높이의 80%
          final double containerWidth = constraints.maxWidth * 0.8; // 부모 너비의 80%
          final double circleButtonSize = containerWidth * 0.5; // 원형 버튼의 크기

          return Center(
            child: Container(
              height: containerHeight, // 박스의 높이 조정
              width: containerWidth, // 박스의 너비 조정
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 4), // 그림자의 위치 조정
                  ),
                ],
                borderRadius: BorderRadius.circular(20), // 박스의 모서리를 둥글게 조정
                border: Border.all(color: Colors.grey.withOpacity(0.3)), // 테두리 색상 및 너비 조정
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    '환영합니다!',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Geekble',
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      '마이펫 등록을 위해 로그인 해주세요!',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Omyu',
                        color: Colors.black.withOpacity(0.6),
                        decoration: TextDecoration.underline, // 밑줄 추가
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildCircleButton(context, circleButtonSize),
                  SizedBox(height: 50),
                  _buildLoginButton(context, containerWidth),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, double size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        width: size, // 크기 조절 가능
        height: size, // 크기 조절 가능
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurpleAccent, // 버튼 색상 설정
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 4), // 그림자의 위치 조정
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                width: size * 0.3, // 추가 원의 크기 조절
                height: size * 0.3, // 추가 원의 크기 조절
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // 추가 원의 색상 설정
                  border: Border.all(color: Colors.grey), // 추가 원의 테두리 색상 설정
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: size * 0.2,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
            Icon(
              Icons.add,
              size: size * 0.4, // 아이콘 크기 조절 가능
              color: Colors.white, // 아이콘 색상 설정
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, double containerWidth) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage_1(initialIndex: 1), // 초기 인덱스를 1로 설정
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: containerWidth * 0.1), // 좌우 마진 추가
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 4), // 그림자를 하단에만 나타나도록 설정
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: Colors.white, // 아이콘 색상
              size: 25, // 아이콘 크기
            ),
            SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
            Text(
              '챗봇만 이용하러 가기',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Geekble',
                color: Colors.white, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }
}
