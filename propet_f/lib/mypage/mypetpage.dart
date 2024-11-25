import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mypage/pet_edit.dart';
import 'package:propetsor/mypage/pet_enroll.dart';

import '../model/Pet.dart';

class MyPetPage extends StatefulWidget {
  const MyPetPage({Key? key}) : super(key: key);

  @override
  _MyPetPageState createState() => _MyPetPageState();
}

class _MyPetPageState extends State<MyPetPage> {
  List<Map<String, String>> pets = []; // 등록된 펫 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

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
    print(res);

    setState(() {
      pets = petModelFromJson(res.data.toString());
    });
  }

  void _addPet(Map<String, String> pet) {
    setState(() {
      pets.add(pet);
    });
  }

  void _editPet(int index, Map<String, String> pet) {
    setState(() {
      pets[index] = pet;
    });
  }

  void _deletePet(int index) async {
    final dio = Dio();
    print("--------------------");
    print(pets[index]["pidx"]);
    Response res = await dio.delete(
      "${Config.baseUrl}/boot/deletePet",
      data: jsonEncode({"pidx": pets[index]["pidx"]}),
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );

    if (res.statusCode == 200) {
      setState(() {
        pets.removeAt(index);
      });
    }
  }



  Future<String?> _getUsername() async {
    String? username = await storage.read(key: 'uname');
    print('Username from storage: $username');
    return username;
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
      body: Column(
        children: [
          _TopPortion(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  FutureBuilder<String?>(
                    future: _getUsername(),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, color: Colors.deepPurpleAccent,), // 추가할 아이콘
                            SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격을 조정하기 위한 SizedBox
                            Text(
                              snapshot.hasData ? "${snapshot.data}님의 마이펫" : '사용자 이름을 불러올 수 없습니다.',
                              style: TextStyle(
                                fontFamily: 'Geekble',
                                fontSize: 25,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격을 조정하기 위한 SizedBox
                            Icon(Icons.pets, color: Colors.deepPurpleAccent,), // 추가할 아이콘
                          ],
                        );

                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  _PetRegistrationCard(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetEnroll(onEnroll: _addPet)),
                    );
                  }),
                  const SizedBox(height: 16),
                  pets.isNotEmpty
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 16),
                  )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return _PetInfoCard(
                          pet: pet,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetEdit(
                                  petData: pet,
                                  onEdit: (editedPet) => _editPet(index, editedPet),
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _deletePet(index);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
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
    return Container(
      height: 280, // 변경된 높이
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/pic.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PetRegistrationCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PetRegistrationCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                ),
                child: Icon(Icons.add, color: Colors.black),
              ),
              const Spacer(),
              Text(
                '마이펫을 등록해 보세요!',
                style: TextStyle(
                  fontFamily: 'Omyu',
                  fontSize: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetInfoCard extends StatelessWidget {
  final Map<String, String> pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PetInfoCard({
    Key? key,
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: Icon(Icons.pets, color: Colors.deepPurpleAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '이름',
                            style: TextStyle(
                              fontFamily: 'Omyu',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '나이',
                            style: TextStyle(
                              fontFamily: 'Omyu',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            pet['pname'] != null && pet['pname']!.length > 6
                                ? pet['pname']!.substring(0, 6)
                                : pet['pname'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Omyu',
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            pet['page'] != null && pet['page']!.length > 2
                                ? pet['page']!.substring(0, 2)
                                : pet['page'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Omyu',
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
