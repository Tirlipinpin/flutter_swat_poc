import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class HttpCalendarRepository extends CalendarRepository {
  final Dio http;

  HttpCalendarRepository({required this.http});

  @override
  Future<Calendar> fetchCalendar(DateTime date) async {
    final response =
        await http.get('http://127.0.0.1:5050/calendar?date=$date');

    developer.log('fetchCalendar > HTTP > ${response.data}');
    return Calendar.fromJson(response.data);
  }

  @override
  Future<int> assign(Calendar calendar, String projectName, int hours) async {
    final response = await http.post('http://127.0.0.1:5050/calendar', data: {
      'calendar': calendar.id,
      'project': projectName,
      'date': calendar.date!.toUtc(),
      'hours': hours,
    });
    developer.log('assign > HTTP > ${response.data}');
    return response.statusCode!;
  }
}
