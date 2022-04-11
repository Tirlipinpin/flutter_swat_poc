import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Repositories/login/repository.dart';

class AuthStateNotifier extends StateNotifier<String> {
  final FlutterSecureStorage flutterSecureStorage;
  final LoginRepository loginRepository;

  AuthStateNotifier(
      {required this.flutterSecureStorage, required this.loginRepository})
      : super('');

  void signIn(String email, String password) async {
    final token = await loginRepository.signIn(email, password);
    await flutterSecureStorage.write(key: 'token', value: token);
    state = token;
  }

  void logOut() async {
    await flutterSecureStorage.delete(key: 'token');
    state = '';
  }

  void checkToken() async {
    final token = await flutterSecureStorage.read(key: 'token');
    if (token != null) {
      state = token;
    }
  }

  bool get hasToken => state.isNotEmpty;

  String get token => state;
}
