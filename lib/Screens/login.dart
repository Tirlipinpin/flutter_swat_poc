import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swat_poc/Widgets/button.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'package:swat_poc/Widgets/text_form_field_widget.dart';

class Login extends StatefulWidget {
  final FlutterSecureStorage storage;
  const Login({Key? key, required this.storage}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
    checkToken();
  }

  _setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  checkToken() async {
    _setIsLoading(true);
    String? token = await widget.storage.read(key: 'token');

    if (token == null) {
      developer.log('checkToken > no token');
      _setIsLoading(false);
      return;
    }

    developer.log('checkToken > $token');
    Navigator.pushNamed(context, '/');
  }

  signIn() {
    developer.log('signIn');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_formKey.currentState!.validate()) {
      _setIsLoading(true);
      Dio().post(
        'http://127.0.0.1:5050/login',
        data: {
          'email': _email.text,
          'password': _password.text,
        },
      ).then((response) {
        final token = response.data['token'];
        final statusCode = response.statusCode;

        if (statusCode != null && (statusCode >= 200 && statusCode <= 300)) {
          developer.log('Signed in with token: $token');
          widget.storage.write(key: 'token', value: token);
          Navigator.pushNamed(context, '/');
        }
      }).catchError((error) {
        developer.log('signIn > error: ${error.message}');
        _setIsLoading(false);

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

      _setIsLoading(false);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                height: animation.value,
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
                                      controller: _email,
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
                                      controller: _password,
                                    ),
                                    ButtonWidget(
                                      onPressed: signIn,
                                      disabled: _isLoading,
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
