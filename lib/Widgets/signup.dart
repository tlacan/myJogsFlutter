import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:my_jogs/Services/userService.dart';

import '../Services/engine.dart';
import '../Utils/localizable.dart';
import './roundButton.dart';
import '../Utils/helper.dart';
import '../Utils/constants.dart';
import '../Services/widgetRefreshManager.dart';
import './loginSignup.dart';
import './alert.dart';

class SignUpWidget extends StatefulWidget {
  final Engine engine;
  SignUpWidget(this.engine);

  _SignUpWidgetState createState() => _SignUpWidgetState(engine: engine);
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final Engine engine;
  _SignUpWidgetState({this.engine});

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
                    key: "SIGNUP.BARITEM.LOGIN", context: context),
                onPressed: () {
                  engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.tabBarKey, value: 0);
                }),
          ),
          Container(
            child: SizedBox(
              width: 200,
              height: 200,
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
              child: SingUpForm(
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
class SingUpForm extends StatefulWidget {
  final Engine engine;
  SingUpForm({this.engine});

  @override
  SingUpFormState createState() {
    return SingUpFormState(engine: engine);
  }
}

class SingUpFormState extends State<SingUpForm> {
  final _formKey = GlobalKey<FormState>();
  final Engine engine;
  String email;
  String password;
  String confirmPassword;
  RoundButton roundButton;
  PasswordConfirmErrorText passwordConfirmErrorText;
  bool isLoaging = false;
  bool displayingDifferentConfirmPassword = false;
  String errorMessage;

  SingUpFormState({this.engine});

  void onPressed() {
    FormState form = _formKey.currentState;
    bool valid = form.validate();
    if (valid) {
      form.save();
      setState(() {
        isLoaging = true;
      });
      //signUp();
    }
  }

  void signUp() async {
    String error = await engine.userService.signUp(login: email, password: password, context: context);
    setState(() {
      isLoaging = false;
    });
    if (error != null) {
      AlertWidget.presentDialog(messsage: error, context: context);
    }
  }

  VoidCallback buttonOnPressed() {
    final bool hasEmail = !Helper.isNullOrEmpty(email);
    final bool hasPassword = !Helper.isNullOrEmpty(password);
    final bool validConfirmation = !Helper.isNullOrEmpty(confirmPassword) && password == confirmPassword;
    return (hasEmail && hasPassword && validConfirmation) ? onPressed : null;
  }

  void refresh() {
    engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.signupFormKey, value: buttonOnPressed());
    engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.signupPassworComfirmKey, value: displayDifferentConfirmPassword());
  }

  bool displayDifferentConfirmPassword() {
    if (Helper.isNullOrEmpty(password) || Helper.isNullOrEmpty(confirmPassword)) {
      return false;
    }
    return password != confirmPassword;
  }

  @override
  Widget build(BuildContext context) {
    roundButton = RoundButton(
        engine: engine,
        text: Localizable.valuefor(key: "SIGNUP.SIGNUP.BUTTON", context: context),
        onPressed: buttonOnPressed(),
        refreshManagerKey: WidgetRefreshManager.signupFormKey);
    
    passwordConfirmErrorText = PasswordConfirmErrorText(engine: engine, display: displayDifferentConfirmPassword());
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        autovalidate: true,
        child: 
        isLoaging ? CircularProgressIndicator(backgroundColor: Colors.black,) :
        Column(children: [
          EmailTextField(onSaved: (value) {
            final oldValue = email;
            email = value;
            if ((email?.isEmpty ?? true) != (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }, withValidation: true,),
          Container(height: 1, color: Constants.colors.lightGray),
          PasswordTextField(onSaved: (value) {
            final oldValue = password;
            password = value;
            if ((password?.isEmpty ?? true) != (oldValue?.isEmpty ?? true)) {
              refresh();
            }
          }, withValidation: true),
          Container(height: 1, color: Constants.colors.lightGray),
          PasswordTextField(onSaved: (value) {
            confirmPassword = value;
            refresh();
          }, isConfirmation: true,),
          passwordConfirmErrorText,
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: roundButton
            )
        ]));
  }
  void checkForm() {
    _formKey.currentState.validate();
  }
}

class PasswordConfirmErrorText extends StatefulWidget {
  final bool display;
  final Engine engine;
  PasswordConfirmErrorText({this.display, this.engine});

  @override
  _PasswordConfirmErrorTextState createState() => _PasswordConfirmErrorTextState(display: display, engine: engine);
}

class _PasswordConfirmErrorTextState extends State<PasswordConfirmErrorText> implements WidgetRefresherManagerObserver{
  bool display;
  final Engine engine;

  _PasswordConfirmErrorTextState({this.display, this.engine}) {
    engine?.widgetRefreshManager?.addObserver(key: WidgetRefreshManager.signupPassworComfirmKey, observer: this);
  }

  @override
	void dispose(){
		super.dispose();
    engine?.widgetRefreshManager?.removeObserver(key: WidgetRefreshManager.signupPassworComfirmKey, observer: this);
	}

  @override
  Widget build(BuildContext context) {
    return Row(children: display ? [ 
            Container(
            width: 150,
            child: null),
            Expanded(
              child:Text(Localizable.valuefor(key: "SIGNUP.PASSWORD.DIFFERENT", context: context),
                    textAlign: TextAlign.left,
                    style: Constants.theme.errorText,
                    )
            )
          ] : []);
  }

  @override
  void doRefresh(Object value) {
    setState(() {
      display = value;
    });
  }
}
