import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mainPage/main_2.dart'; // Replace with actual login page import
import 'dart:convert';
import 'dart:io';

final dio = Dio();
final storage = FlutterSecureStorage();

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 화면의 다른 부분을 터치하면 키보드가 내려감
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _Logo(),
                SizedBox(height: 16), // 로고와 입력 창 사이 간격 추가
                _FormContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateMember(Map<String, String> member, BuildContext context) async {
    try {
      Response res = await dio.patch(
        '${Config.baseUrl}/boot/update', // 요청 URL
        data: jsonEncode({'updateMember': member}), // 요청 데이터
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (res.data != null) {
        await storage.write(key: 'member', value: jsonEncode(res.data));
        CherryToast.success(
          title: const Text('회원정보 수정에 성공했습니다'),
        ).show(context);

        // 로그아웃 처리
        await storage.deleteAll();

        // 로그인 페이지로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
              (route) => false,
        );
      } else {
        CherryToast.info(
          title: const Text('회원정보 수정에 실패했습니다'),
        ).show(context);
      }
    } catch (e) {
      CherryToast.error(
        title: const Text('오류가 발생했습니다'),
        description: Text(e.toString()),
      ).show(context);
    }
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    String? memberJson = await storage.read(key: 'member');
    if (memberJson != null) {
      Map<String, dynamic> member = jsonDecode(memberJson);
      setState(() {
        pwController.text = member['pw'];
        nameController.text = member['uname'];
        phoneController.text = member['uphone'];
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String? memberJson = await storage.read(key: 'member');
      if (memberJson != null) {
        Map<String, dynamic> member = jsonDecode(memberJson);
        final updatedMemberData = {
          'uidx': member['uidx'].toString(),
          'pw': pwController.text,
          'uname': nameController.text,
          'uphone': phoneController.text,
        };

        ProfileUpdate().updateMember(updatedMemberData, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gap(),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: 'ID',
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(),
              ),
              initialValue: '변경할 수 없습니다', // 기본값을 설정합니다.
            ),
            _gap(),
            TextFormField(
              controller: pwController,
              decoration: const InputDecoration(
                labelText: 'PassWord',
                hintText: 'Enter your PassWord',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'PW를 입력하세요';
                }
                return null;
              },
            ),
            _gap(),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력하세요';
                }
                return null;
              },
            ),
            _gap(),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '전화번호를 입력하세요';
                }
                return null;
              },
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '업데이트',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '취소',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

class _Logo extends StatefulWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  State<_Logo> createState() => __LogoState();
}

class __LogoState extends State<_Logo> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: isSmallScreen ? 160 : 160,
          height: isSmallScreen ? 160 : 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1), // 회색 보더 추가
          ),
          child: CircleAvatar(
            radius: isSmallScreen ? 76 : 76, // 보더 두께에 맞춰서 반지름 조정
            backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/images/pic.png') as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkResponse(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: isSmallScreen ? 24 : 24,
              ),
            ),
            radius: 10,
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.grey.withOpacity(0.5),
            highlightShape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
