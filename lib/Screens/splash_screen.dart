import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/main.dart';
import 'package:swat_poc/state/auth.dart';
import 'dart:developer' as developer;

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (_, AuthState nextValue) {
      developer.log('SplashScreen > listen: ${nextValue.hasToken}');
      if (nextValue.hasToken) {
        Navigator.popAndPushNamed(context, '/timesheet');
      } else {
        Navigator.popAndPushNamed(context, '/login');
      }
    });

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
}
