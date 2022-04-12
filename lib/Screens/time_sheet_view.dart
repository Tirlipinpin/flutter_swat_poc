import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/assignment.dart';
import 'package:swat_poc/Data/project.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarStreamState = ref.watch(calendarStateStreamProvider);

    return Scaffold(
      appBar: AppBar(actions: [
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
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Semaine ${state.firstDay!.weekOfYear}'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
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
            )
          ]);
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
