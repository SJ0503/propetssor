import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:propetsor/FCM/fcm_service.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/login/join.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mainPage/main_1.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mainPage/start.dart';
import 'package:propetsor/model/Users.dart';
import 'package:propetsor/mypage/mychatpage.dart';

final storage = FlutterSecureStorage();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  showNotification(message); // 백그라운드에서 메시지를 받았을 때 알림을 표시합니다.
}

Future<void> initializeFCM() async {

  FirebaseMessaging _messaging = FirebaseMessaging.instance;


  // 사용자 권한 요청
  await _messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // FCM 토큰 가져오기
  String? token = await _messaging.getToken();
  String? u_idx = await storage.read(key: 'uidx');
  if (token != null && u_idx != null) {
    print('FCM Token: $token');
    // 서버로 FCM 토큰과 u_idx 전송
    await sendTokenToServer(token, u_idx ); // u_idx 전달
  }

  // 포그라운드 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received in foreground: ${message.messageId}');
    showNotification(message); // 포그라운드에서 메시지를 받았을 때 알림을 표시합니다.
  });

  // 백그라운드 메시지 처리
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message opened from background: ${message.messageId}');
    showNotification(message); // 백그라운드에서 앱이 열렸을 때 알림을 표시합니다.
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchUrls();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  initializeFCM();
  // 앱이 실행 중일 때 알림을 클릭하여 앱을 열었을 때 호출되는 콜백
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// 알림을 클릭하여 앱을 열었을 때 MyChatPage로 이동
    runApp(MaterialApp(home: MyChatPage()));
  });
  runApp(MyApp());
}
Future<void> fetchUrls() async {
  final conn = await MySQLConnection.createConnection(
    host: 'project-db-cgi.smhrd.com',
    port: 3307,
    userName: 'vmfhvpttj',
    password: '20240621',
    databaseName: 'vmfhvpttj',
  );

  await conn.connect();

  var result = await conn.execute("SELECT * FROM links");

  for (var row in result.rows) {
    print('Row: $row');

    String? urlType;
    String? url;

    try {
      urlType = row.colAt(1)?.trim();
      url = row.colAt(2)?.trim();
    } catch (e) {
      print('Error accessing row columns: $e');
    }

    if (urlType == 'baseUrl') {
      Config.baseUrl = url ?? ''; // url이 null일 경우 빈 문자열로 대체
    } else if (urlType == 'chatUrl') {
      Config.chatUrl = url ?? '123'; // url이 null일 경우 123으로 대체
    } else if (urlType == 'picUrl') {
      Config.picUrl = url ?? '123'; // url이 null일 경우 123으로 대체
    }
  }
  await conn.close();
}

Future<void> clearSecureStorage() async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _checkLoginStatus() async {
    return await storage.read(key: 'member');
  }




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {

        if(snapshot.data!=null){ //로그인후
          Map<String,dynamic> jsonMember = jsonDecode(snapshot.data!);

          Users member = Users.fromJson(jsonMember);
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(

                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const MainPage_2(),
            debugShowCheckedModeBanner: false, // 배너 숨기기
          );
        }else{//로그인전
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(

                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: StartScreen(),
              debugShowCheckedModeBanner: false, // 배너 숨기기
          );
        }

      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//   로그인 상태 확인
  Future<String?> _checkLoginStatus() async{
//     storage 'member' 값이 저장 되어 있는지/안 되어 있는지
//   storage.read 값 가져오기
//   로그인 하지 않은 상태 => null 이라 ? 붙이기
    String? value = await storage.read(key: 'member');
    return value;
  }

  //로그아웃
  void logout(context) async{
    //스토리지에 저장된 정보('member') 삭제
    await storage.delete(key: 'member');
    await storage.delete(key: 'uidx');
    await storage.delete(key: 'uname');

    CherryToast.success(
      title: Text('로그아웃 성공했습니다'),
    ).show(context);

    //현재 페이지 pop 다시 push
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage_1()));

  }




}
