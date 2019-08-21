import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:my_jogs/Services/serviceState.dart';
import 'package:my_jogs/Services/userService.dart';

import '../Services/engine.dart';
import '../Utils/localizable.dart';
import './roundButton.dart';
import '../Utils/helper.dart';
import '../Utils/constants.dart';
import '../manager/widgetRefreshManager.dart';
import './loginSignup.dart';
import './alert.dart';

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
                onPressed: () {
                  engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.tabBarKey, value: 1);
                }),
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
              child: LoginForm(
                engine: engine,
              ))
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

class LoginFormState extends State<LoginForm> implements UserServiceObserver {
  final _formKey = GlobalKey<FormState>();
  final Engine engine;
  String email;
  String password;
  RoundButton roundButton;
  ServiceState loginState;
  String errorMessage;

  LoginFormState({this.engine}) {
    engine.userService.addObserver(this);
    loginState = engine.userService.state;
  }

  void onPressed() {
    FormState form = _formKey.currentState;
    bool valid = form.validate();
    if (valid) {
      form.save();
      engine.userService.login(login: email, password: password, context: context);
    }
  }

  VoidCallback buttonOnPressed() {
    final bool hasEmail = !Helper.isNullOrEmpty(email);
    final bool hasPassword = !Helper.isNullOrEmpty(password);
    return (hasEmail && hasPassword) ? onPressed : null;
  }

  void refresh() {
    engine.widgetRefreshManager.notifyRefresh(
        key: WidgetRefreshManager.loginFormKey, value: buttonOnPressed());
  }

  @override
  Widget build(BuildContext context) {
    roundButton = RoundButton(
        engine: engine,
        text: Localizable.valuefor(key: "LOGIN.LOGIN.BUTTON", context: context),
        onPressed: buttonOnPressed(),
        refreshManagerKey: WidgetRefreshManager.loginFormKey,);
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        autovalidate: true,
        child: 
        loginState == ServiceState.loading ? CircularProgressIndicator(backgroundColor: Colors.black,) :
        Column(children: [
          EmailTextField(onSaved: (value) {
            final oldValue = email;
            email = value;
            if ((email?.isEmpty ?? true) != (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }),
          Container(height: 1, color: Constants.colors.lightGray),
          PasswordTextField(onSaved: (value) {
            final oldValue = password;
            password = value;
            if ((password?.isEmpty ?? true) != (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }),
          Container(child: roundButton)
        ]));
  }

  void checkForm() {
    _formKey.currentState.validate();
  }

  @override
  void onUserService({UserService userService, ServiceState state, String error}) {
    setState(() {
      loginState = state;
      if (error != null) {
        AlertWidget.presentDialog(messsage: error, context: context);
      }
    });
  }

  @override
  void userDidLogin() {
    return;
  }

  @override
  void userDidLogout() {
    return;
  }
}
