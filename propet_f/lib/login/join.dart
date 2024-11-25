import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/model/Users.dart';
import 'package:cherry_toast/cherry_toast.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

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

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idCon = TextEditingController();
  TextEditingController pwCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

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
                decoration: InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(fontFamily: 'Omyu'),
                  hintText: 'Enter your ID',
                  hintStyle: TextStyle(fontFamily: 'Omyu'),
                  prefixIcon: Icon(Icons.perm_identity),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              _gap(),
              TextFormField(
                controller: pwCon,
                decoration: InputDecoration(
                  labelText: 'PassWord',
                  labelStyle: TextStyle(fontFamily: 'Omyu'),
                  hintText: 'Enter your PassWord',
                  hintStyle: TextStyle(fontFamily: 'Omyu'),
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              _gap(),
              TextFormField(
                controller: nameCon,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontFamily: 'Omyu'),
                  hintText: 'Enter your Name',
                  hintStyle: TextStyle(fontFamily: 'Omyu'),
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              _gap(),
              TextFormField(
                controller: phoneCon,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontFamily: 'Omyu'),
                  hintText: 'Enter your Phone',
                  hintStyle: TextStyle(fontFamily: 'Omyu'),
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
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
                  onPressed: () {
                    Users m = Users.join(
                      id: idCon.text,
                      uname: nameCon.text,
                      uphone: phoneCon.text,
                      pw: pwCon.text,
                    );
                    joinMember(m, context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '회원가입 완료',
                      style: TextStyle(fontSize: 16, fontFamily: 'Geekble'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // 배경색
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // 텍스트 색상
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // 취소 버튼 눌렀을 때 이전 화면으로 돌아가기
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '취소',
                      style: TextStyle(fontSize: 16, fontFamily: 'Geekble'),
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

void joinMember(member, context) async {
  final dio = Dio();

  Response res = await dio.post(
    '${Config.baseUrl}/boot/join', // 요청. url(경로)
    data: {'joinMember': member}, // 요쳥할 때 같이 보낼 데이터(json-key:value)
  );

  if (int.parse(res.toString()) == 1) {
    // 회원가입 성공
    CherryToast.success(
      title: Text(
        '회원가입에 성공했습니다',
        style: TextStyle(fontFamily: 'Geekble'),
      ),
    ).show(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()), // YourMainPage 대신에 이동할 페이지를 지정하세요.
          (route) => false,
    );
  } else {
    //0 회원가입 실패
    CherryToast.info(
      title: Text(
        '회원가입에 실패했습니다',
        style: TextStyle(fontFamily: 'Geekble'),
      ),
    ).show(context);
  }
}
