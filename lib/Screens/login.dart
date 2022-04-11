import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Widgets/button.dart';
import 'dart:developer' as developer;
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:swat_poc/Widgets/text_form_field_widget.dart';
import 'package:swat_poc/main.dart';

class Login extends HookConsumerWidget {
  Login({Key? key}) : super(key: key);

  _signIn(BuildContext context, WidgetRef ref, String email,
      String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        ref.read(authStateProvider.notifier).signIn(email, password);
      } on Exception catch (error) {
        developer.log('signIn > error: $error');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$error'),
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
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 250));
    final animation = useAnimation(
        Tween<double>(begin: 0, end: 300).animate(animationController));
    final email = useTextEditingController(text: '');
    final password = useTextEditingController(text: '');
    final authState = ref.watch(authStateProvider);

    if (animationController.status != AnimationStatus.completed) {
      animationController.forward();
    }

    return Scaffold(
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
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
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                          controller: password,
                                        ),
                                        ButtonWidget(
                                          onPressed: () => _signIn(
                                            context,
                                            ref,
                                            email.text.trim(),
                                            password.text,
                                          ),
                                          disabled: authState.isLoading,
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
