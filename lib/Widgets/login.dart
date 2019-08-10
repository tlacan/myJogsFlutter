import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lottie/flutter_lottie.dart';

import '../Services/engine.dart';
import '../Utils/localizable.dart';
import './headerLoginSignUp.dart';
import '../Utils/constants.dart';
import './roundButton.dart';
import '../Services/userService.dart';

class LoginWidget extends StatefulWidget {
  final Engine engine;

  LoginWidget(this.engine);

  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  LottieController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        body: SafeArea(
            child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: HeaderLoginSignupWidget(
                buttonText: Localizable.valuefor(
                    key: "LOGIN.BARITEM.SIGNUP", context: context),
                onPressed: () {}),
          ),
          Container(
            child: SizedBox(
              width: 300,
              height: 300,
              child: LottieView.fromFile(
                filePath: "assets/lottie/run.json",
                autoPlay: true,
                loop: true,
                onViewCreated: onViewCreated,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child:LoginForm()
          )
        ])));
  }

  void onViewCreated(LottieController controller) {
    this.controller = controller;

    this.controller.onPlayFinished.listen((bool animationFinished) {

    });
  }
}

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}


class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: TextFormField(

          keyboardType: TextInputType.emailAddress,
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value.isEmpty) {
              return Localizable.valuefor(key: "SIGNUP.EMAIL.NOTVALID", context: context);
            }
            if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
              return Localizable.valuefor(key: "SIGNUP.EMAIL.NOTVALID", context: context);
            }
            return null;
          },
        ));
  }
}
