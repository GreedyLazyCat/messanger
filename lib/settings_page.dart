import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:messanger/api/server_api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.serverUrl});
  final Uri serverUrl;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController controller;
  late String serverUrl;

  @override
  void initState() {
    controller = TextEditingController();
    controller.text = widget.serverUrl.authority;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Server URL'),
                    controller: controller,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final response = await pingServer(Uri.http(controller.text));
                            if (context.mounted) {
                              final stringResponse =
                                  'Serever status code ${response.statusCode.toString()}';
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(stringResponse)));
                            }
                          } catch(e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Wrong URL')));
                            }
                          }
                        },
                        child: const Text('Ping')),
                  )
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        heroTag: "accept_settings",
        child: const Icon(Icons.done),
        onPressed: () {
          Navigator.pop(context, controller.text);
        },
      ),
    );
  }
}
