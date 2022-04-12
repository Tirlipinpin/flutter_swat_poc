import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Repositories/calendars/http.dart';
import 'package:swat_poc/Repositories/login/http.dart';

import 'package:swat_poc/Screens/splash_screen.dart';
import 'package:swat_poc/state/auth.dart';
import 'package:swat_poc/state/auth_new.dart';
import 'package:swat_poc/state/calendar.dart';

final urlProvider = Provider<String>((ref) => "http://10.8.0.22:5050");

final authStateProvider = Provider(
  (ref) {
    return AuthService(
      flutterSecureStorage: const FlutterSecureStorage(),
      loginRepository: HttpLoginRepository(url: ref.watch(urlProvider)),
    )..checkToken();
  },
);

final authStateStreamProvider = StreamProvider(
  (ref) => ref.watch(authStateProvider).stream,
);

final dioProvider = Provider<Dio>((ref) {
  return ref.watch(authStateStreamProvider).when(
        data: (AuthState authState) {
          if (!authState.hasToken) {
            return Dio();
          }
          final dio = Dio(BaseOptions(
            baseUrl: ref.watch(urlProvider),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${authState.token}'
            },
          ));
          dio.interceptors
              .add(InterceptorsWrapper(onError: (DioError e, handler) {
            if (e.response?.statusCode == 401) {
              ref.read(authStateProvider).logout();
            }
            return handler.next(e);
          }));

          return dio;
        },
        error: (error, stacktrace) => Dio(),
        loading: () => Dio(),
      );
});

final calendarRepositoryProvider =
    Provider((ref) => HttpCalendarRepository(http: ref.watch(dioProvider)));

// final calendarRepositoryProvider =
//     Provider((ref) => InMemoryCalendarRepository());

final calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, AsyncValue<CalendarState>>(
        (ref) {
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
      initialRoute: '/splash',
      routes: {
        // '/timesheet': (context) {
        //   // ref.read(calendarStateProvider.notifier).load(DateTime.now());
        //   return const TimeSheet();
        // },
        // '/login': (context) => Login(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
