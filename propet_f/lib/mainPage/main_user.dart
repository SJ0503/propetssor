import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/model/Pet.dart';
import 'package:propetsor/mypage/mypetpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainUser(),
    );
  }
}

class MainUser extends StatefulWidget {
  const MainUser();

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  List<Map<String, String>> pets = []; // 등록된 펫 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    // 페이지가 로드되기 전에 정보를 가져오는 작업
    _loadPets();
  }

  // JSON 문자열을 List<Map<String, String>>로 변환하는 함수
  List<Map<String, String>> petModelFromJson(String str) {
    final jsonData = json.decode(str) as List;
    return jsonData.map((e) => Pet.fromJson(e).toMap()).toList();
  }

  void _loadPets() async {
    final dio = Dio();

    String? uidx = await storage.read(key: 'uidx');

    Response res = await dio.post(
      "${Config.baseUrl}/boot/selectAllPet",
      data: {"uidx": uidx},
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    List<Map<String, String>> loadedPets = petModelFromJson(res.data.toString());

    // 각 펫의 이미지를 로드하여 pets 리스트를 업데이트
    for (var pet in loadedPets) {
      String petImagePath = pet['pimage'] ?? '';
      String petImageUrl = await _loadImage(petImagePath);
      pet['pimage'] = petImageUrl;
    }

    setState(() {
      pets = loadedPets;
    });

    String petsJson = jsonEncode(pets); // List<Map<String, String>>를 JSON 문자열로 변환
    await storage.write(key: "pets", value: petsJson); // 변환된 JSON 문자열을 storage에 저장
  }

  Future<String> _loadImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL("gs://image-f513d.appspot.com/$path");
      final url = await ref.getDownloadURL();
      print('Image URL: $url');
      return url;
    } catch (e) {
      print('Error loading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return pets.isEmpty
              ? _buildNoPetsPage(context, constraints)
              : PageView(
            children: [
              ...pets.map((pet) {
                String petName = pet['pname'] as String;
                String petBreed = pet['pkind'] as String;
                int petAge = int.tryParse(pet['page'].toString()) ?? 0;
                String petGender = pet['pgender'] as String;
                String petWeight = pet['pkg'] as String;
                String petImage = pet['pimage'] as String;
                return _buildPage(
                    context, petName, petBreed, petAge, petGender, petWeight, petImage, constraints);
              }).toList(),
              if (pets.length < 3) _buildAddPetPage(context, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoPetsPage(BuildContext context, BoxConstraints constraints) {
    final double containerHeight = constraints.maxHeight * 0.8; // 부모 높이의 80%
    final double containerWidth = constraints.maxWidth * 0.8; // 부모 너비의 80%

    final double iconSize = containerWidth * 0.4; // 컨테이너 너비의 40%
    final double textFontSize1 = containerWidth * 0.07; // 컨테이너 너비의 7%
    final double textFontSize2 = containerWidth * 0.06; // 컨테이너 너비의 6%

    return Center(
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPetPage()),
                );
              },
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pets,
                  size: iconSize * 0.6, // 아이콘 컨테이너 크기의 60%
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            SizedBox(height: containerHeight * 0.05), // 컨테이너 높이의 5%
            Text(
              '등록된 펫이 없습니다.',
              style: TextStyle(
                fontSize: textFontSize1,
                fontFamily: 'Geekble',
                color: Colors.grey.withOpacity(1.0),
              ),
            ),
            SizedBox(height: containerHeight * 0.05), // 컨테이너 높이의 5%
            Text(
              '지금 바로 사랑스러운 펫을 등록해 보세요!',
              style: TextStyle(
                fontSize: textFontSize2,
                fontFamily: 'Omyu',
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: containerHeight * 0.1), // 컨테이너 높이의 10%
            _buildRegisterButton(context, '마이 펫 등록'),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String petName, String petBreed,
      int petAge, String petGender, String petWeight, String petImage, BoxConstraints constraints) {
    final double containerHeight = constraints.maxHeight * 0.8; // 부모 높이의 80%
    final double containerWidth = constraints.maxWidth * 0.8; // 부모 너비의 80%

    return Center(
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCustomWidget(context),
                SizedBox(width: containerWidth * 0.03), // 컨테이너 너비의 3%
              ],
            ),
            SizedBox(height: containerHeight * 0.03), // 컨테이너 높이의 1%
            _buildCircleButton(context, containerWidth * 0.52, petImage),
            SizedBox(height: containerHeight * 0.04), // 컨테이너 높이의 1%
            _buildPetInfo(petName, petBreed, petAge, petGender, petWeight, containerWidth * 0.06),
            SizedBox(height: containerHeight * 0.06), // 컨테이너 높이의 4%
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, double size, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyPage()),
        // );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: size * 0.75,
            height: size * 0.75,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfo(String petName, String petBreed, int petAge,
      String petGender, String petWeight, double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildPetDetailBox(Icons.drive_file_rename_outline, '이름', petName, Colors.deepPurpleAccent.shade100, fontSize, 'Omyu')),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(Icons.pets, '품종', petBreed, Colors.brown.shade200, fontSize, 'Omyu')),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildPetDetailBox(Icons.cake, '나이', '$petAge살', Colors.orangeAccent.shade100, fontSize, 'Omyu')),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(
                petGender == '수컷' ? Icons.male : Icons.female,
                '성별',
                petGender,
                petGender == '수컷' ? Colors.blueAccent.shade100 : Colors.pinkAccent.shade100,
                fontSize, 'Omyu',
              )),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(Icons.monitor_weight, '몸무게', '$petWeight kg', Colors.green.shade200, fontSize, 'Omyu')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetDetailBox(IconData icon, String title, String value, Color iconColor, double fontSize, String fontFamily) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: iconColor),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily, // 폰트 변경
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetPage(BuildContext context, BoxConstraints constraints) {
    final double containerHeight = constraints.maxHeight * 0.8; // 부모 높이의 80%
    final double containerWidth = constraints.maxWidth * 0.8; // 부모 너비의 80%

    final double iconSize = containerWidth * 0.4; // 컨테이너 너비의 40%
    final double textFontSize1 = containerWidth * 0.07; // 컨테이너 너비의 7%
    final double textFontSize2 = containerWidth * 0.06; // 컨테이너 너비의 6%

    return Center(
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPetPage()),
                );
              },
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: iconSize * 0.6, // 아이콘 컨테이너 크기의 60%
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            SizedBox(height: containerHeight * 0.05), // 컨테이너 높이의 5%
            Text(
              '마이 펫 추가 등록하기',
              style: TextStyle(
                fontSize: textFontSize1,
                fontFamily: 'Geekble', // 폰트 변경
                color: Colors.grey.withOpacity(1.0),
              ),
            ),
            SizedBox(height: containerHeight * 0.05), // 컨테이너 높이의 5%
            Text(
              '최대 3마리까지 등록 가능합니다!',
              style: TextStyle(
                fontSize: textFontSize2,
                fontFamily: 'Omyu', // 폰트 변경
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: containerHeight * 0.1), // 컨테이너 높이의 10%
            _buildRegisterButton(context, '마이펫 등록'),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPetPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24), // 패딩을 추가하여 버튼을 더 크고 터치하기 쉽게 만듭니다.
        minimumSize: Size(200, 50), // 버튼의 최소 크기를 설정합니다.
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 텍스트 길이에 따라 버튼 크기가 결정되도록 합니다.
        children: [
          Icon(Icons.pets, size: 24), // 아이콘을 추가하여 버튼의 직관성을 높입니다.
          SizedBox(width: 8), // 아이콘과 텍스트 사이에 여백을 추가합니다.
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Geekble', // 폰트 변경
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.pets, size: 24), // 아이콘을 추가하여 버튼의 직관성을 높입니다.
        ],
      ),
    );
  }

  Widget _buildCustomWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPetPage()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.8)),
        ),
        child: Icon(
          Icons.edit,
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
    );
  }
}
