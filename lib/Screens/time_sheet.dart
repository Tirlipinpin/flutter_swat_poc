import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';
import 'package:swat_poc/Widgets/cell.dart';

class TimeSheet extends HookWidget {
  final FlutterSecureStorage storage;
  final CalendarRepository calendarRepository;

  const TimeSheet(
      {Key? key, required this.storage, required this.calendarRepository})
      : super(key: key);

  logout(context) {
    storage.deleteAll();

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Calendar> fetchCalendar(context) async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      developer.log('fetchCalendar > no token');
      logout(context);
      return const Calendar.empty();
    }

    try {
      developer.log('fetchCalendar...');

      return await calendarRepository.fetchCalendar();
    } catch (error) {
      developer.log('fetchCalendar > error: $error');
      return const Calendar.empty();
    }
  }

  String getValueForCell(
      ValueNotifier<Calendar> calendar, Project project, int day) {
    final list = calendar.value.assignments
        .where((assignment) =>
            assignment.projectId == project.id &&
            assignment.date.weekday == day)
        .toList();

    if (list.isNotEmpty) {
      return '${list[0].hours}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final calendar = useState<Calendar>(const Calendar.empty());
    final int weekOfYear = 24;

    useEffect(() {
      fetchCalendar(context).then((value) {
        calendar.value = value;
        developer.log('fetchCalendar > calendar: ${value.projects}');
      });
    }, []);

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => logout(context),
        ),
      ]),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Semaine $weekOfYear')),
        Table(
          defaultColumnWidth: const FlexColumnWidth(1.0),
          children: <TableRow>[
            const TableRow(
              children: <Widget>[
                Cell(value: ''),
                Cell(value: 'Lundi'),
                Cell(value: 'Mardi'),
                Cell(value: 'Mercredi'),
                Cell(value: 'Jeudi'),
                Cell(value: 'Vendredi'),
                Cell(value: 'Samedi'),
                Cell(value: 'Dimanche'),
              ],
            ),
            ...calendar.value.projects.map((project) {
              return TableRow(
                children: <Widget>[
                  Cell(value: project.name, ellipsis: true),
                  Cell(
                      value:
                          getValueForCell(calendar, project, DateTime.monday)),
                  Cell(
                      value:
                          getValueForCell(calendar, project, DateTime.tuesday)),
                  Cell(
                      value: getValueForCell(
                          calendar, project, DateTime.wednesday)),
                  Cell(
                      value: getValueForCell(
                          calendar, project, DateTime.thursday)),
                  Cell(
                      value:
                          getValueForCell(calendar, project, DateTime.friday)),
                  Cell(
                      value: getValueForCell(
                          calendar, project, DateTime.saturday)),
                  Cell(
                      value:
                          getValueForCell(calendar, project, DateTime.sunday)),
                ],
              );
            }).toList(),
          ],
        )
      ]),
    );
  }
}
