import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:propetsor/main.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'api_service.dart'; // API 서비스 모듈

class ChatScreen extends StatefulWidget {
  final APIService apiService;

  ChatScreen({required this.apiService});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isWaitingForResponse = false;
  String _botResponse = '';
  String? _breed;
  String? _age;
  String? _query;
  String _currentStep = 'initial';
  bool _showInitialButtons = true; // 버튼을 표시할지 여부를 결정하는 플래그
  String? member;
  String? _choose;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'bot',
      'message': '안녕하세요! 프로펫서 입니다! 원하시는 서비스를 클릭해주세요!',
      'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
      'name': '프로펫서',
    });
  }

  void _handleButtonPress(String choice) {
    setState(() {
      _choose = choice;
      _showInitialButtons = false; // 버튼을 숨기도록 상태 업데이트
      _messages.add({
        'role': 'bot',
        'message': choice == "1" ? '강아지의 증상이나, 필요하신 영양제의 목표를 말씀해 주시면, 가장 적합한 제품을 추천해 드리겠습니다.' : '무엇이 궁금하실까요? 정확한 답변을 위해 반려동물의 품종과 함께 질문을 입력해주세요',
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
        'name': '프로펫서',
      });
      print('버튼이 클릭되었습니다: $_choose'); // 콘솔에 출력
    });
  }

  Future<void> loadPets() async {
    String? petsJson = await storage.read(key: "pets");
    member = await storage.read(key: "member");

    if (petsJson != null && member != null) {
      List<dynamic> decodedList = jsonDecode(petsJson); // JSON 문자열을 디코딩하여 리스트로 변환
      List<Map<String, String>> pets = List<Map<String, String>>.from(
          decodedList.map((item) => Map<String, String>.from(item)));
      _breed = pets[0]['pkind'];
      _age = pets[0]['page'];
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    await loadPets();

    if (message.isNotEmpty) {
      setState(() {
        _messages.add({
          'role': 'user',
          'message': message,
          'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
          'name': 'User',
        });
        _controller.clear();
        _focusNode.unfocus();
      });

      if (member == null) {
        switch (_currentStep) {
          case 'initial':
            setState(() {
              _query = message;
              _currentStep = 'awaiting_breed';
            });
            if (_breed == null) {
              _addBotMessage('견종을 입력해주세요.');
            }
            break;
          case 'awaiting_breed':
            setState(() {
              _breed = message;
              _currentStep = 'awaiting_age';
            });
            if (_age == null) {
              _addBotMessage('나이를 입력해주세요.');
            }
            break;
          case 'awaiting_age':
            setState(() {
              _age = message;
              _currentStep = 'awaiting_message';
            });
            _isWaitingForResponse = true;
            _botResponse = '';

            String response = await widget.apiService.sendMessage(
                _choose!, _query!, _breed!, _age!);
            print("================================api");
            print(response);
            setState(() {
              _botResponse = response;
              _isWaitingForResponse = false;
              _messages.add({
                'role': 'bot',
                'message': _botResponse,
                'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
                'name': '프로펫서',
              });
              _botResponse = '';
            });
            break;
        }
      } else {
        // member가 null이 아닌 경우, 견종과 나이를 묻는 단계를 건너뜁니다.
        if (_currentStep == 'initial') {
          setState(() {
            _query = message;
            _currentStep = 'awaiting_message';
          });
          _isWaitingForResponse = true;
          _botResponse = '';

          String response = await widget.apiService.sendMessage(
              _choose!, _query!, _breed!, _age!);
          print("================================api");
          print(response);
          setState(() {
            _botResponse = response;
            _isWaitingForResponse = false;
            _messages.add({
              'role': 'bot',
              'message': _botResponse,
              'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
              'name': '프로펫서',
            });
            _botResponse = '';
          });
        }
      }
    }
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        'role': 'bot',
        'message': message,
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
        'name': '프로펫서',
      });
    });
  }

  String _formatMessage(String message) {
    final int maxCharsPerLine = 38;
    final StringBuffer buffer = StringBuffer();
    final List<String> lines = message.split('\n');

    for (String line in lines) {
      for (int i = 0; i < line.length; i += maxCharsPerLine) {
        buffer.writeln(line.substring(
            i,
            i + maxCharsPerLine > line.length
                ? line.length
                : i + maxCharsPerLine));
      }
    }

    return buffer.toString().trim();
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUserMessage = message['role'] == 'user';
    bool isFirstMessage = message == _messages.first;
    String formattedMessage = _formatMessage(message['message']!);

    return Column(
      crossAxisAlignment:
      isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUserMessage)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  backgroundImage: AssetImage('assets/images/logo2.png'),
                  radius: 20,
                ),
              ),
            Flexible(
              child: Column(
                crossAxisAlignment: isUserMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      message['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Geekble',
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.deepPurple[300]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isFirstMessage || isUserMessage
                        ? Text(
                      formattedMessage,
                      style: TextStyle(
                        fontFamily: 'Omyu',
                        color:
                        isUserMessage ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    )
                        : AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          formattedMessage,
                          textStyle: TextStyle(
                            fontFamily: 'Omyu',
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          speed: Duration(milliseconds: 25),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      message['timestamp']!,
                      style: TextStyle(
                        fontFamily: 'Omyu',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isUserMessage)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  backgroundImage: AssetImage('assets/images/user_avatar.png'),
                  radius: 20,
                ),
              ),
          ],
        ),
        if (_showInitialButtons)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100, // 원하는 가로 크기 설정
                  child: ElevatedButton(
                    onPressed: () {
                      _handleButtonPress("2"); // 애견정보 버튼 클릭 시
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '애견정보',
                      style: TextStyle(
                        fontFamily: 'Omyu', // 폰트 패밀리 설정
                        fontSize: 16, // 폰트 크기 설정
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 100, // 원하는 가로 크기 설정
                  child: ElevatedButton(
                    onPressed: () {
                      _handleButtonPress("1"); // 상품추천 버튼 클릭 시
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '상품추천',
                      style: TextStyle(
                        fontFamily: 'Omyu', // 폰트 패밀리 설정
                        fontSize: 16, // 폰트 크기 설정
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _buildMessage(_messages[index]),
                  );
                },
              ),
            ),
            if (_isWaitingForResponse)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      '잠시만 기다려주세요..!!',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Omyu',
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: '프로펫서에게 지금 바로 질문해 보세요!',
                        hintStyle: TextStyle(
                          fontFamily: 'Omyu',
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(apiService: APIService()), // APIService를 인스턴스화하여 전달
  ));
}

