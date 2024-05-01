import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messanger/api/server_api.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.serverUrl});
  final Uri serverUrl;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return 'Login is required.';
                }
                return null;
              },
              controller: loginController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Login'),
            ),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == '') {
                  return 'Password is required.';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return 'You must repeat password.';
                }
                if (value != passwordController.text) {
                  return 'Passwords doesnt match.';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Repeat Password'),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  //ОБРАБОТКА ЗАПРОСА
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await signUp(
                            Uri.http(widget.serverUrl.authority, 'signup'),
                            loginController.text,
                            passwordController.text);
                        if (context.mounted) {
                          if (response.statusCode == HttpStatus.badRequest) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.body)));
                          }
                          if (response.statusCode == HttpStatus.ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.body)));
                          }
                        }
                      } else {}
                    },
                    child: const Text('Зарегистрироваться'))),
          ],
        ));
    ;
  }
}
