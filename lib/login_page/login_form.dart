import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/chat_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
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
                      try {
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
                            final jsonResponse = jsonDecode(response.body)
                                as Map<String, dynamic>;
                            _setAuthToken(jsonResponse['token']!);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Authorized succesfully')));
                            Navigator.pushReplacementNamed(context, '/chats');
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error')));
                      }
                    },
                    child: const Text('Войти'))),
          ],
        ));
  }
}
