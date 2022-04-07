import 'package:flutter/material.dart';
import 'package:swat_poc/Widgets/button.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dio/dio.dart';

import 'package:swat_poc/Widgets/text_form_field_widget.dart';

class Login extends HookWidget {
  final FlutterSecureStorage storage;

  Login({Key? key, required this.storage}) : super(key: key);

  _checkToken(BuildContext context, ValueNotifier isLoading) async {
    isLoading.value = true;
    String? token = await storage.read(key: 'token');

    if (token == null) {
      developer.log('checkToken > no token');
      isLoading.value = false;
      return;
    }

    developer.log('checkToken > $token');
    Navigator.popAndPushNamed(context, '/timesheet');
  }

  _signIn(BuildContext context, ValueNotifier isLoading, String email,
      String password) {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;
      Dio().post(
        'http://127.0.0.1:5050/login',
        data: {
          'email': email,
          'password': password,
        },
      ).then((response) {
        final token = response.data['token'];
        final statusCode = response.statusCode;

        if (statusCode != null && (statusCode >= 200 && statusCode <= 300)) {
          developer.log('Signed in with token: $token');
          storage.write(key: 'token', value: token);
          Navigator.popAndPushNamed(context, '/timesheet');
        }
      }).catchError((error) {
        developer.log('signIn > error: ${error.message}');
        isLoading.value = false;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(error.message),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });

      isLoading.value = false;
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 250));
    final animation = useAnimation(
        Tween<double>(begin: 0, end: 300).animate(animationController));
    final isLoading = useState<bool>(false);
    final email = useTextEditingController(text: '');
    final password = useTextEditingController(text: '');

    useEffect(() {
      developer.log('use effect');
      _checkToken(context, isLoading);
    }, []);

    if (animationController.status != AnimationStatus.completed) {
      animationController.forward();
    }

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: NetworkImage(
                'https://voyage-onirique.com/wp-content/uploads/2020/01/656579-1120x630.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: animation,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextFormFieldWidget(
                                      hintText: 'Email',
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        } else if (!value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      controller: email,
                                    ),
                                    TextFormFieldWidget(
                                      hintText: 'Password',
                                      obscureText: true,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                      controller: password,
                                    ),
                                    ButtonWidget(
                                      onPressed: () => _signIn(context,
                                          isLoading, email.text, password.text),
                                      disabled: isLoading.value,
                                      text: 'Sign in',
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
