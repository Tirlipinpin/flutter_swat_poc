import 'package:dio/dio.dart';
import 'package:swat_poc/Repositories/login/repository.dart';

class HttpLoginRepository extends LoginRepository {
  final String url;

  HttpLoginRepository({required this.url});

  @override
  Future<String> signIn(String email, String password) async {
    final response = await Dio().post(
      '$url/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 401) {
      throw Exception();
    }
    return response.data['token'];
  }
}
