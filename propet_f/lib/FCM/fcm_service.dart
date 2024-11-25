import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:propetsor/config/config.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.data}');
  showNotification(message);
}

void showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // 알림 채널 ID
    'your_channel_name', // 알림 채널 이름
    importance: Importance.max, // 알림 중요도 설정
    priority: Priority.high, // 알림 우선도 설정
    ticker: 'ticker', // 티커 텍스트 설정
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  print("*--*-*-----------------");
  print(message.data);

  String? title = "미응답 답변이 등록되었습니다!!";
  String? body = "'닥스훈트 알려줘'에 대한 답변이 등록되었습니다!";

  print(title);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'mychatpage',
  );
}

Future<void> sendTokenToServer(String token, String uIdx) async {

  print("token : " + token);
  print("u_idx: " + uIdx);

  final url = Uri.parse('${Config.baseUrl}/boot/api/token');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'token': token,
      'uidx': int.parse(uIdx),
    }),
  );

  if (response.statusCode == 200) {
    print('Token sent to server successfully');
  } else {
    print('Failed to send token to server');
  }
}

