import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Repositories/calendars/http.dart';
import 'package:swat_poc/Repositories/calendars/inMemory.dart';
// import 'package:swat_poc/Repositories/calendars/http.dart';
import 'package:swat_poc/Repositories/login/inMemory.dart';
// import 'package:swat_poc/Repositories/calendars/inMemory.dart';

import 'package:swat_poc/Screens/login.dart';
import 'package:swat_poc/Screens/time_sheet.dart';
import 'package:swat_poc/state/auth.dart';
import 'package:swat_poc/state/calendar.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, String>(
  (ref) {
    final authState = AuthStateNotifier(
      flutterSecureStorage: const FlutterSecureStorage(),
      loginRepository: InMemoryLoginRepository(),
    );
    authState.checkToken();
    return authState;
  },
);

final dioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authStateProvider);
  if (token.isEmpty) {
    throw UnimplementedError();
  }

  return Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:5050',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  ));
});

// final calendarRepositoryProvider =
//     Provider((ref) => HttpCalendarRepository(http: ref.watch(dioProvider)));

final calendarRepositoryProvider =
    Provider((ref) => InMemoryCalendarRepository());

final calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, CalendarState>((ref) {
  return CalendarStateNotifier(
      calendarRepository: ref.read(calendarRepositoryProvider));
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        '/timesheet': (context) {
          ref.read(calendarStateProvider.notifier).load();
          return const TimeSheet();
        },
        '/login': (context) => Login(),
      },
    );
  }
}
