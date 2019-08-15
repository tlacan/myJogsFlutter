import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lottie/flutter_lottie.dart';


import '../Services/engine.dart';
import '../Utils/localizable.dart';
import './roundButton.dart';
import '../Utils/helper.dart';
import '../Services/widgetRefreshManager.dart';
import './loginSignup.dart';

class LoginWidget extends StatefulWidget {
  final Engine engine;
  LoginWidget(this.engine);

  _LoginWidgetState createState() => _LoginWidgetState(engine: engine);
}

class _LoginWidgetState extends State<LoginWidget> {
  final Engine engine;
  _LoginWidgetState({this.engine});

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
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0), child: LoginForm(engine: engine,))
        ])));
  }

  void onViewCreated(LottieController controller) {
    this.controller = controller;
    this.controller.onPlayFinished.listen((bool animationFinished) {});
  }
}

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  final Engine engine;
  LoginForm({this.engine});

  @override
  LoginFormState createState() {
    return LoginFormState(engine: engine);
  }
}

class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final Engine engine;
  String email;
  String password;
  RoundButton roundButton;

  LoginFormState({this.engine});

  void onPressed() {
    FormState form = _formKey.currentState;
    bool valid = form.validate();
    if (valid) {
      form.save();
    }
  }

  VoidCallback buttonOnPressed() {
    final bool hasEmail = !Helper.isNullOrEmpty(email) ;
    final bool hasPassword = !Helper.isNullOrEmpty(password);
    return (hasEmail && hasPassword) ? onPressed : null;
  }

  void refresh() {
    engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.loginFormKey, value: buttonOnPressed());
  }

  @override
  Widget build(BuildContext context) {
    roundButton = RoundButton(
                  engine: engine,
                  text: Localizable.valuefor(
                      key: "LOGIN.LOGIN.BUTTON", context: context),
                  onPressed: buttonOnPressed()
                );
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        autovalidate: true,
        child: Column(children: [
          EmailTextField(onSaved: (value) {
            final oldValue = email;
            email = value;
            if ((email?.isEmpty ?? true) !=  (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }),
          Container(
            height:1,
            color: Colors.grey
          ),
          PasswordTextField(onSaved: (value) {
            final oldValue = password;
            password = value;
            if ((password?.isEmpty ?? true) !=  (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }),
          Container(
              child: roundButton)
        ]));
  }

  void checkForm() {
    _formKey.currentState.validate();
  }
}
