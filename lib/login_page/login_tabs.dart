import 'package:flutter/material.dart';
import 'package:messanger/login_page/login_form.dart';
import 'package:messanger/login_page/sign_up_form.dart';

class LoginTabs extends StatefulWidget {
  const LoginTabs({super.key, required this.onTabChange, required this.serverUrl});

  final Function(int) onTabChange;
  final Uri serverUrl;

  @override
  State<LoginTabs> createState() => _LoginTabsState();
}

class _LoginTabsState extends State<LoginTabs>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Вход'),
    Tab(text: 'Регистрация'),
  ];
  late TabController _tabController;
  double heightFactor = 0.4;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(() {
      // debugPrint(_tabController.animation!.value.toString());
      setState(() {
        heightFactor = 0.4 + 0.1 * _tabController.animation!.value;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 100),
        heightFactor: heightFactor,
        widthFactor: 0.9,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: myTabs),
          Expanded(
              child: TabBarView(controller: _tabController, children:  [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: LoginForm(serverUrl: widget.serverUrl,)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SignUpForm(serverUrl: widget.serverUrl,))
          ]))
        ]));
  }
}