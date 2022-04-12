import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swat_poc/Repositories/login/repository.dart';
import 'package:swat_poc/state/auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FlutterSecureStorage flutterSecureStorage;
  final LoginRepository loginRepository;
  final StreamController<AuthState> _controller;

  AuthService(
      {required this.flutterSecureStorage, required this.loginRepository})
      : _controller = StreamController();

  Stream<AuthState> get stream => _controller.stream;

  Future<void> signIn(String email, String password) async {
    developer.log("AuthState > signing in");
    _controller.add(AuthState.loading());
    String token;
    try {
      token = await loginRepository.signIn(email, password);
      developer.log("AuthState > signed in");
    } on Exception {
      _controller.add(AuthState.loggedOut());
      return;
    }
    await flutterSecureStorage.write(key: 'token', value: token);
    _controller.add(AuthState.loggedIn(token: token));
  }

  Future<void> logout() async {
    developer.log('AuthState > logout in progress');
    _controller.add(AuthState.loading());
    await flutterSecureStorage.delete(key: 'token');
    await Future.delayed(const Duration(seconds: 1));
    _controller.add(AuthState.loggedOut());

    developer.log('AuthState > logout done');
  }

  Future<void> checkToken() async {
    _controller.add(AuthState.loading());
    final token = await flutterSecureStorage.read(key: 'token');
    await Future.delayed(const Duration(seconds: 1));
    if (token != null) {
      developer.log('AuthService > checkToken > $token');
      _controller.add(AuthState.loggedIn(token: token));
    } else {
      _controller.add(AuthState.loggedOut());
    }
  }
}
