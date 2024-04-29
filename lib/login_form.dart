import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:messanger/api/server_api.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.serverUrl});
  final Uri serverUrl;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String serverUrl;
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Login'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () async {
                      final response = await getAuthToken(
                          Uri.http(widget.serverUrl.authority, '/auth'),
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
                    },
                    child: const Text('Войти'))),
          ],
        ));
  }
}
