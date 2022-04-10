import 'package:swat_poc/Data/assignment.dart';
import 'dart:developer' as developer;
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';
import 'package:swat_poc/Services/http_service.dart';

class HttpCalendarRepository extends CalendarRepository {
  // final FlutterSecureStorage storage;

  HttpCalendarRepository();

  @override
  Future<Calendar> fetchCalendar() async {
    final http = await HttpService().getHttpService();
    final response = await http.get('http://127.0.0.1:5050/calendar');

    developer.log('fetchCalendar > HTTP > ${response.data}');
    return Calendar.fromJson(response.data);
  }

  @override
  Future<Assignment> assign(
      Calendar calendar, Project project, int dayOfWeek, int hours) async {
    final http = await HttpService().getHttpService();
    final response = await http.post('http://127.0.0.1:5050/calendar', data: {
      'calendar': calendar.id,
      'project': project.id,
      'day_of_week': dayOfWeek,
      'hours': hours,
    });
    developer.log('assign > HTTP > ${response.data}');
    return Assignment.fromJson(response.data);
  }
}
