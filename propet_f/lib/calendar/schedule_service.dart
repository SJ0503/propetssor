import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/model/Schedules.dart';

class ScheduleService {
  final dio = Dio();
  final storage = FlutterSecureStorage();

  Future<void> createSchedule(Schedules schedule) async {
    final uidx = await storage.read(key: 'uidx');
    schedule.uidx = int.parse(uidx!);
    await dio.post(
      '${Config.baseUrl}/boot/schedulesCreate',
      data: schedule.toJson(),
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );
  }

  Future<List<Schedules>> getAllSchedules() async {
    final response = await dio.get(
      '${Config.baseUrl}/boot/getAllSchedules',
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );
    return (response.data as List)
        .map((json) => Schedules.fromJson(json))
        .toList();
  }

  Future<List<Schedules>> getSchedulesByUserId(int uidx) async {
    final response = await dio.get(
      '${Config.baseUrl}/boot/getSchedules/user/$uidx',
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );
    return (response.data as List)
        .map((json) => Schedules.fromJson(json))
        .toList();
  }

  Future<List<Schedules>> getSchedulesByDateAndUser(int uidx, String ndate) async {
    final response = await dio.get(
      '${Config.baseUrl}/boot/getSchedulesByDateAndUser/$uidx',
      queryParameters: {'ndate': ndate},
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );
    return (response.data as List)
        .map((json) => Schedules.fromJson(json))
        .toList();
  }

  Future<void> deleteSchedule(int id) async {
    await dio.delete(
      '${Config.baseUrl}/boot/deleteSchedules/$id',
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );
  }
}

