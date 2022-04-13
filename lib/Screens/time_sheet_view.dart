import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/assignment.dart';
import 'package:swat_poc/Data/calendar_day.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Screens/day_detail.dart';
import 'package:swat_poc/Screens/time_sheet_day.dart';
import 'package:swat_poc/Widgets/button.dart';
import 'package:swat_poc/Widgets/cell.dart';
import 'package:swat_poc/main.dart';
import 'package:swat_poc/state/calendar_new.dart';
import 'package:collection/collection.dart';
import 'package:week_of_year/week_of_year.dart';
import 'dart:developer' as developer;

class TimeSheetView extends HookConsumerWidget {
  const TimeSheetView({Key? key}) : super(key: key);

  String getValueForCell(List<Assignment> assignments, String projectId) {
    final assignment = assignments
        .firstWhereOrNull((assignment) => assignment.projectId == projectId);

    if (assignment == null) {
      return '';
    }

    return '${assignment.hours}';
  }

  void onCellEdit(WidgetRef ref, Project project, DateTime date, int hours) {
    developer.log(
        '[Cell Edit] project id: ${project.id}, date: $date, hours: $hours');
    ref.read(calendarServiceProvider).setAssignment(date, project, hours);
  }

  void handleCellTap(BuildContext context, CalendarDay calendarDay) {
    developer.log('[Cell Tap] date: ${calendarDay.date}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CalendarDayView(calendarDay: calendarDay)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarStreamState = ref.watch(calendarStateStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Time Sheet'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.read(dioProvider).post('/test-401', data: {}),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: ref.read(authServiceProvider).logout,
        ),
      ]),
      body: calendarStreamState.when(
        data: (CalendarState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isEmpty) {
            return const Center(child: Text("No data"));
          }
          return RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            color: Colors.blue,
            backgroundColor: Colors.white,
            onRefresh: () =>
                ref.read(calendarServiceProvider).load(DateTime.now()),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Semaine ${state.firstDay!.weekOfYear}'),
                ),
                Table(
                  defaultColumnWidth: const FlexColumnWidth(1.0),
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        const Cell(value: ''),
                        Cell(
                            value: 'Lundi',
                            onTap: () =>
                                handleCellTap(context, state.days![0])),
                        Cell(
                            value: 'Mardi',
                            onTap: () =>
                                handleCellTap(context, state.days![1])),
                        Cell(
                            value: 'Mercredi',
                            onTap: () =>
                                handleCellTap(context, state.days![2])),
                        Cell(
                            value: 'Jeudi',
                            onTap: () =>
                                handleCellTap(context, state.days![3])),
                        Cell(
                            value: 'Vendredi',
                            onTap: () =>
                                handleCellTap(context, state.days![4])),
                        Cell(
                            value: 'Samedi',
                            onTap: () =>
                                handleCellTap(context, state.days![5])),
                        Cell(
                            value: 'Dimanche',
                            onTap: () =>
                                handleCellTap(context, state.days![6])),
                      ],
                    ),
                    ...state.projects!.map((project) {
                      return TableRow(
                        children: <Widget>[
                          Cell(value: project.name, ellipsis: true),
                          ...(state.days!.map((day) {
                            return Cell(
                              enabled: true,
                              value:
                                  getValueForCell(day.assignments!, project.id),
                              onEdit: (hours) =>
                                  onCellEdit(ref, project, day.date, hours),
                            );
                          }).toList()),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ]),
            ),
          );
        },
        error: (Object error, StackTrace? stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $error")),
          );
          return ButtonWidget(
            text: 'Refresh',
            onPressed: () =>
                ref.read(calendarServiceProvider).load(DateTime.now()),
          );
        },
        loading: () {
          return const Text("loading");
        },
      ),
    );
  }
}
