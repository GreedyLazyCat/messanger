import 'package:flutter/material.dart';
import 'package:messanger/chats_page/chat_main_page.dart';
import 'package:messanger/login_page/login_tabs.dart';
import 'package:messanger/login_page/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? 'no token';
  final initialRoute = token == 'no token'? '/login' : '/chats';
  debugPrint(initialRoute);
  runApp(MaterialApp(
    initialRoute: initialRoute,
    routes: {
      '/login': (context) => const MessangerApp(),
      '/chats': (context) => const ChatsMainPage(),
    },
  ));
}

class MessangerApp extends StatefulWidget {
  const MessangerApp({super.key});

  @override
  State<MessangerApp> createState() => _MessangerAppState();
}

class _MessangerAppState extends State<MessangerApp> {
  // double _verticalPadding = 280;
  bool change = true;
  Uri serverUrl = Uri();

  Future<void> _launchSettings(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsPage(serverUrl: serverUrl)));
    if (!context.mounted) return;
    if (result is String) {
      setState(() {
        _setServerUri(Uri.http(result));
      });
    }
  }

  Future<void> _setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> _getServerUri() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = Uri.parse(prefs.getString('serverUri') ?? 'http://localhost');
    });
  }

  Future<void> _setServerUri(Uri uri) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = uri;
      prefs.setString('serverUri', uri.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _getServerUri();
    _setAuthToken('no token');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    final appBar = AppBar(
      actions: [
        IconButton(
            onPressed: () {
              _launchSettings(context);
            },
            icon: const Icon(Icons.settings))
      ],
    );

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size(
              size.width,
              size.height -
                  appBar.preferredSize.height -
                  padding.top -
                  padding.bottom)),
          child: Center(
              child: LoginTabs(
            onTabChange: (index) {},
            serverUrl: serverUrl,
          )),
        )));
  }
}
