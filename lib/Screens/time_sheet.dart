import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Widgets/cell.dart';
import 'package:swat_poc/main.dart';
import 'package:swat_poc/state/calendar.dart';

class TimeSheet extends HookConsumerWidget {
  const TimeSheet({Key? key}) : super(key: key);

  logout(BuildContext context, WidgetRef ref) {
    ref.read(authStateProvider.notifier).logOut();

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Calendar> fetchCalendar(BuildContext context, WidgetRef ref) async {
    try {
      developer.log('fetchCalendar...');

      return await ref.read(calendarRepositoryProvider).fetchCalendar();
    } catch (error) {
      developer.log('fetchCalendar > error: $error');
      return const Calendar.empty();
    }
  }

  String getValueForCell(CalendarState calendar, Project project, int day) {
    final list = calendar.assignments
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
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarStateProvider);

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => logout(context, ref),
        ),
      ]),
      body: calendarState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Semaine ${calendarState.weekOfYear}')),
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
                  ...calendarState.projects.map((project) {
                    return TableRow(
                      children: <Widget>[
                        Cell(value: project.name, ellipsis: true),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.monday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.tuesday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.wednesday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.thursday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.friday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.saturday)),
                        Cell(
                            value: getValueForCell(
                                calendarState, project, DateTime.sunday)),
                      ],
                    );
                  }).toList(),
                ],
              )
            ]),
    );
  }
}
