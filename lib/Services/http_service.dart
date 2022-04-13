import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

class HttpService {
  final storage = const FlutterSecureStorage();

  HttpService();

  Future<Dio> getHttpService() async {
    final token = await storage.read(key: 'token');

    developer.log('getHttpService > $token');
    Dio dio = Dio(BaseOptions(
        baseUrl: 'https://flutter-swat-poc.herokuapp.com',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));

    return dio;
  }
}
