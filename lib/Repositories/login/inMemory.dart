import 'package:swat_poc/Repositories/login/repository.dart';

class InMemoryLoginRepository extends LoginRepository {
  @override
  Future<String> signIn(String email, String password) async {
    if (email == 'admin@o2t.swat' && password.isNotEmpty) {
      return Future.delayed(const Duration(milliseconds: 500), () => 'token');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
