import 'package:flutter/material.dart';

import '../Services/engine.dart';
import '../Services/userService.dart';

class LoginWidget extends StatefulWidget {
  final Engine engine;

  LoginWidget(this.engine);

  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("jambon"),
    );
  }
}