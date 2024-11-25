import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/login/join.dart';
import 'package:propetsor/mainPage/main_1.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mainPage/start.dart';
import 'package:propetsor/model/Users.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // 화면의 다른 부분을 누를 때 키보드 닫기
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: BoxConstraints(maxWidth: 800),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _Logo(),
                  const SizedBox(height: 20), // 로고와 입력 창 사이 간격 추가
                  const _FormContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo1.png',
          width: 300,
          height: 300,
        ),
      ],
    );
  }
}

Widget _buildSocialLoginButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: _buildSocialLoginButton(
          text: 'N', // 네이버 아이콘 텍스트
          color: const Color(0xFF03C75A), // 네이버 메인 색상
          onTap: () {
            // 네이버 로그인 로직
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildSocialLoginButton(
          text: 'K', // 카카오 아이콘 텍스트
          color: const Color(0xFFFFE812), // 카카오 메인 색상
          onTap: () {
            // 카카오 로그인 로직
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildSocialLoginButton(
          text: 'G', // 구글 아이콘 텍스트
          color: const Color(0xFF4285F4), // 구글 메인 색상
          onTap: () {
            // 구글 로그인 로직
          },
        ),
      ),
    ],
  );
}

Widget _buildSocialLoginButton({
  required String text,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // 텍스트 색상
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idCon = TextEditingController();
  TextEditingController pwCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center( // Center로 감싸서 중앙 정렬
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // 추가된 부분: 가로 정렬 중앙
            children: [
              TextFormField(
                controller: idCon,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(fontFamily: 'Omyu', fontSize: 16),
                  hintText: 'Enter your ID',
                  hintStyle: TextStyle(fontFamily: 'Omyu', fontSize: 16),
                  prefixIcon: Icon(Icons.perm_identity),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              _gap(),
              TextFormField(
                controller: pwCon,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 0) {
                    return 'Password must be at least 0 characters';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(fontFamily: 'Omyu', fontSize: 16),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(fontFamily: 'Omyu', fontSize: 16),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              _gap(),
              _buildSocialLoginButtons(), // SNS 로그인 버튼 추가
              _gap(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent), // 배경색
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // 텍스트 색상
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '로그인',
                      style: TextStyle(fontSize: 16, fontFamily: 'Geekble'),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // 로그인 로직 처리
                      Users m = Users.login(id: idCon.text, pw: pwCon.text);
                      loginMember(m, context);
                    }
                  },
                ),
              ),
              const SizedBox(height: 5), // 로그인 버튼과 회원가입 버튼 사이 간격 추가
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // 배경색
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // 추가적인 로직 처리
                    Navigator.push(context, MaterialPageRoute(builder: (context) => JoinPage()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 16, fontFamily: 'Geekble', color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

void loginMember(Users member, BuildContext context) async {
  final dio = Dio();
  final storage = FlutterSecureStorage();

  try {
    Response res = await dio.post(
      '${Config.baseUrl}/boot/login',
      data: {
        'loginMember': member.toJson(),
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 응답이 성공적으로 받아졌을 때의 처리
    if (res.statusCode == 200 && res.data != null && res.data.toString().isNotEmpty) {
      // JSON 응답을 Users 객체로 변환
      final responseData = res.data;
      if (responseData is String) {
        // 서버 응답이 문자열인 경우, 이를 Map으로 파싱
        final Map<String, dynamic> userData = jsonDecode(responseData);
        Users loggedInUser = Users.fromJson(userData);

        // 스토리지에 로그인 한 회원의 uidx 저장하기
        await storage.write(key: 'uidx', value: loggedInUser.uidx.toString());
        await storage.write(key: 'uname', value: loggedInUser.uname.toString());
        await storage.write(key: 'member', value: res.data.toString());
        // 로그인 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 성공했습니다.', style: TextStyle(fontFamily: 'Omyu')),
            backgroundColor: Colors.green,
          ),
        );

        // 메인 화면으로 이동 (이전 모든 화면 삭제)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainPage_2()),
              (route) => false,
        );
      } else {
        // 서버 응답이 이미 Map인 경우
        Users loggedInUser = Users.fromJson(responseData);

        // 스토리지에 로그인 한 회원의 uidx 저장하기
        await storage.write(key: 'uidx', value: loggedInUser.uidx.toString());
        await storage.write(key: 'uname', value: loggedInUser.uname.toString());
        await storage.write(key: 'member', value: res.data.toString());

        // 로그인 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 성공했습니다.', style: TextStyle(fontFamily: 'Omyu')),
            backgroundColor: Colors.green,
          ),
        );

        // 메인 화면으로 이동 (이전 모든 화면 삭제)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainPage_2()),
              (route) => false,
        );
      }
    } else {
      // 로그인 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다.', style: TextStyle(fontFamily: 'Omyu')),
          backgroundColor: Colors.red,
        ),
      );
    }
  } on DioError catch (e) {
    // Dio 요청 중 예외 발생 시 오류 메시지 출력
    print('DioError: $e');

    // 예외에 따른 오류 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('서버에 연결할 수 없습니다: ${e.message}', style: TextStyle(fontFamily: 'Omyu')),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    // 기타 예외 발생 시 오류 메시지 출력
    print('Error: $e');

    // 예외에 따른 오류 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('알 수 없는 오류가 발생했습니다: $e', style: TextStyle(fontFamily: 'Omyu')),
        backgroundColor: Colors.red,
      ),
    );
  }
}
