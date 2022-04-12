import 'package:dio/dio.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Data/assignment.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class HttpCalendarRepository extends CalendarRepository {
  final Dio http;

  HttpCalendarRepository({required this.http});

  @override
  Future<Calendar> fetchCalendar(DateTime date) async {
    final response = await http.get('/calendar?date=$date');

    developer.log('fetchCalendarDay > HTTP > ${response.data}');
    return Calendar.fromJson(response.data);
  }

  @override
  Future<Calendar> assign(DateTime date, Project project, int hours) async {
    final formatter = DateFormat('yyyy-MM-dd');

    final response = await http.put('/calendar/assignment', data: {
      'date': formatter.format(date),
      'project_id': project.id,
      'hours': hours,
    });
    developer.log('assign > HTTP > ${response.data}');
    return Calendar.fromJson(response.data);
  }
}
