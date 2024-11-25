import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propetsor/config/config.dart';
import 'package:propetsor/main.dart';
import 'package:provider/provider.dart';

class APIService {
  Future<String> sendMessage(String choose, String message, String breed, String age) async {
    String? uidx = await storage.read(key: "uidx");
    String u_idx = uidx ?? "1";

    print("메서드 실행은 됨-------------------------------");

    print('$choose message $message breed $breed age $age');
    final response = await http.post(
      Uri.parse('${Config.chatUrl}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      },
      body: jsonEncode(<String, String>{
        'choose': choose,
        'query': message,
        'breed': breed,
        'age': age,
        'uidx': u_idx,
      }),
    );
    print("*-*----------------------");
    print(response.body);

    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse; // JSON 객체를 문자열로 변환하여 반환
      } catch (e) {
        print('Error parsing JSON: $e');
        throw Exception('Failed to parse JSON response');
      }
    } else {
      throw Exception('Failed to load response with status code: ${response.statusCode}');
    }
  }
}
