import 'package:dio/dio.dart';
import 'package:swat_poc/Repositories/login/repository.dart';

class HttpLoginRepository extends LoginRepository {
  @override
  Future<String> signIn(String email, String password) async {
    final response = await Dio().post(
      'http://127.0.0.1:5050/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data['token'];
  }
}
