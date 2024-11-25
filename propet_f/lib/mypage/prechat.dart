import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 시간 포맷을 위해 사용
import 'package:propetsor/config/config.dart';
import 'package:propetsor/mainPage/main_2.dart';
import '../main.dart'; // animated_text_kit 패키지 추가

class PreChat extends StatelessWidget {
  final Map<String, String> chatData;

  const PreChat({Key? key, required this.chatData}) : super(key: key);

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
    bool isBotNoAnswerMessage = message['message'] == '챗봇이 아직 답변할 수 없습니다.';
    String formattedMessage = _formatMessage(message['message']!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  message['name']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Geekble', // 이름 글꼴 변경
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUserMessage ? Colors.deepPurple[300] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        formattedMessage,
                        style: TextStyle(
                          fontFamily: 'Omyu', // 메시지 내용 글꼴 변경
                          color: isUserMessage ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (isBotNoAnswerMessage)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  message['timestamp']!,
                  style: TextStyle(
                    fontFamily: 'Omyu', // 타임스탬프 글꼴 변경
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
    );
  }

  Future<List<Map<String, String>>> fetchAndAddQuestions() async {
    final dio = Dio();
    String? uidx = await storage.read(key: 'uidx');
    Response res = await dio.post(
        '${Config.baseUrl}/boot/getQuestionList',
        data: {"uidx": uidx, "qtf": chatData['q_tf']}
    );

    List<Map<String, dynamic>> receivedData = List<Map<String, dynamic>>.from(json.decode(res.data));
    List<Map<String, String>> messages = [
      {
        'role': 'bot',
        'message': '챗봇이 이전 대화입니다.',
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
        'name': '프로펫서'
      },
    ];

    receivedData.forEach((data) {
      messages.add({
        'role': 'user', // 챗봇의 역할
        'message': data['qcontent'], // 질문 내용
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()), // 현재 시간
        'name': 'User' // 챗봇의 이름
      });
      messages.add({
        'role': 'bot', // 챗봇의 역할
        'message': data['qanswer'], // 질문 내용
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()), // 현재 시간
        'name': '프로펫서' // 챗봇의 이름
      });
    });

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    bool isNoAnswer = chatData['q_tf'] == 'N';

    return FutureBuilder<List<Map<String, String>>>(
      future: fetchAndAddQuestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PreChat'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PreChat'),
            ),
            body: Center(child: Text('오류가 발생했습니다.')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PreChat'),
            ),
            body: Center(child: Text('데이터가 없습니다.')),
          );
        } else {
          List<Map<String, String>> messages = snapshot.data!;

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
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10), // 첫 멘트 위에 여백 추가
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: _buildMessage(messages[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isNoAnswer
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: 250, // 너비 줄이기
              height: 50, // 높이 키우기
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage_2(initialIndex: 1),
                    ),
                  );
                },
                icon: Icon(Icons.chat, color: Colors.deepPurpleAccent),
                label: Text('다시 물어보러 가기!', style: TextStyle(fontFamily: 'Geekble', color: Colors.black, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            )
                : null,
          );
        }
      },
    );
  }
}
