import 'package:flutter/material.dart';
import 'package:propetsor/chatbot/chatbot.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mypage/mypage_2.dart';
import 'package:propetsor/mypage/prechat.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final List<Map<String, String>> chats = [
    {
      'title': '기존 대화',
      'date': '2024-05-20',
      'content': '이것은 정상적인 답변입니다.',
      'q_tf' : 'Y'
    },
    {
      'title': '기존 대화',
      'date': '2024-05-21',
      'content': '챗봇이 아직 답변할 수 없습니다.',
      'q_tf': 'N'
    },
  ];

  void _addChat(Map<String, String> chat) {
    setState(() {
      chats.add(chat);
    });
  }

  void _editChat(int index, Map<String, String> chat) {
    setState(() {
      chats[index] = chat;
    });
  }

  void _deleteChat(int index) {
    setState(() {
      chats.removeAt(index);
    });
  }

  void _navigateToChatBotPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage_2(initialIndex: 1),
      ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: _getUsername(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    snapshot.hasData ? "${snapshot.data}님의 마이 채팅!" : '사용자 이름을 불러올 수 없습니다.',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Geekble', // Geekble 폰트로 변경
                      color: Colors.black.withOpacity(0.7),
                    ),
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
            _ChatRegistrationCard(onTap: () {
              _navigateToChatBotPage(context);
            }),
            const SizedBox(height: 16),
            chats.isNotEmpty
                ? Container(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              color: Colors.grey,
              margin: const EdgeInsets.only(bottom: 16),
            )
                : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return _ChatInfoCard(
                    chat: chat,
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreChat(
                            chatData: chat,
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      _deleteChat(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRegistrationCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ChatRegistrationCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // 박스 내부 색깔을 하얀색으로 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // 높이 증가
          child: Row(
            children: [
              Container(
                width: 48, // 아이콘이 들어가는 원의 크기
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey), // 회색 테두리 추가
                  color: Colors.white, // 배경을 흰색으로 설정
                ),
                child: Icon(Icons.add, color: Colors.black), // 아이콘 색깔을 퍼플로 설정
              ),
              const Spacer(),
              Text(
                '새 대화 시작하기',
                style: TextStyle(fontSize: 20, fontFamily: 'Omyu'), // Omyu 폰트로 변경
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInfoCard extends StatelessWidget {
  final Map<String, String> chat;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _ChatInfoCard({
    Key? key,
    required this.chat,
    required this.onView,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBotNoAnswerMessage = chat['content'] == '챗봇이 아직 답변할 수 없습니다.';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // 높이 증가
        child: Row(
          children: [
            Container(
              width: 48, // 아이콘이 들어가는 원의 크기
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey), // 회색 테두리 추가
                color: Colors.white, // 배경을 흰색으로 설정
              ),
              child: Icon(
                isBotNoAnswerMessage ? Icons.error : Icons.chat,
                color: isBotNoAnswerMessage ? Color(0xFFEF6F6C) : Color(0xFF6D6875),
              ), // 아이콘 색깔 설정
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
                            '대화 제목',
                            style: TextStyle(fontSize: 20, fontFamily: 'Omyu'), // Omyu 폰트로 변경
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '날짜',
                            style: TextStyle(fontSize: 20, fontFamily: 'Omyu'), // Omyu 폰트로 변경
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
                            chat['title'] ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.grey[800], fontFamily: 'Omyu'), // 강조된 스타일 및 Omyu 폰트로 변경
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            chat['date'] ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.grey[800], fontFamily: 'Omyu'), // Omyu 폰트로 변경
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: onView,
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
