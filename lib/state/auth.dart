import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Repositories/login/repository.dart';
import 'dart:developer' as developer;

class AuthState {
  final String? token;
  final bool isLoading;

  AuthState({required this.token, required this.isLoading});

  AuthState.loading() : this(isLoading: true, token: null);

  AuthState.loggedIn({required String token})
      : this(isLoading: false, token: token);

  AuthState.loggedOut() : this(isLoading: false, token: null);

  bool get hasToken => token != null;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage flutterSecureStorage;
  final LoginRepository loginRepository;

  AuthStateNotifier(
      {required this.flutterSecureStorage, required this.loginRepository})
      : super(AuthState(token: null, isLoading: false));

  void signIn(String email, String password) async {
    state = AuthState(token: state.token, isLoading: true);
    final token = await loginRepository.signIn(email, password);
    await flutterSecureStorage.write(key: 'token', value: token);
    state = AuthState(token: token, isLoading: false);
    print('signIn, $token');
  }

  void logout() async {
    developer.log('AuthState > logout in progress');
    state = AuthState(token: state.token, isLoading: true);
    await flutterSecureStorage.delete(key: 'token');
    state = AuthState(token: null, isLoading: false);
    developer.log('AuthState > logout done');
  }

  void checkToken() async {
    state = AuthState(token: state.token, isLoading: true);
    final token = await flutterSecureStorage.read(key: 'token');
    print('checkToken, $token');
    if (token != null) {
      print('checkToken > not null');
      state = AuthState(token: token, isLoading: false);
    } else {
      state = AuthState(token: state.token, isLoading: false);
    }
  }

  bool get hasToken => state.token != null;

  String? get token => state.token;
}
