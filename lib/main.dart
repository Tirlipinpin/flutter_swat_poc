import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:swat_poc/Repositories/calendars/http.dart';
import 'package:swat_poc/Repositories/calendars/inMemory.dart';
import 'package:swat_poc/Repositories/login/inMemory.dart';
// import 'package:swat_poc/Repositories/calendars/inMemory.dart';

import 'package:swat_poc/Screens/login.dart';
import 'package:swat_poc/Screens/time_sheet.dart';

final loginRepositoryProvider = Provider((_) => InMemoryLoginRepository());
final calendarRepositoryProvider =
    Provider((_) => InMemoryCalendarRepository());
final storageProvider = Provider((_) => const FlutterSecureStorage());

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SWAT POC',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/timesheet': (context) => const TimeSheet(),
          '/login': (context) => Login(),
        });
  }
}
