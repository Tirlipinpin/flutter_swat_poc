import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class HttpCalendarRepository extends CalendarRepository {
  final FlutterSecureStorage storage;

  HttpCalendarRepository(this.storage);

  @override
  Future<Calendar> fetchCalendar(String token) async {
    final response = await Dio().get('http://127.0.0.1:5050/calendar',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));

    developer.log('fetchCalendar > ${response.data}');
    return Calendar.fromJson(response.data);
  }
}
