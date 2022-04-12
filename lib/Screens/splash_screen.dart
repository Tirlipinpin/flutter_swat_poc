import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Screens/login.dart';
import 'package:swat_poc/Screens/time_sheet_new.dart';
import 'package:swat_poc/main.dart';
import 'dart:developer' as developer;

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateStreamProvider).when(
        data: (data) {
          developer.log('SplashScreen > isLoading: ${data.isLoading}');
          developer.log('SplashScreen > hasToken: ${data.hasToken}');
          if (data.isLoading) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade400,
                    ],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (data.hasToken) {
            ref.read(calendarStateProvider.notifier).load(DateTime.now());
            return const TimeSheet();
          } else {
            return Login();
          }
        },
        error: (error, stacktrace) => Center(
              child: Text("$error: $stacktrace"),
            ),
        loading: () => const Text('loading'));
  }
}
