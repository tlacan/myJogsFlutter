import 'package:flutter/material.dart';
import '../Utils/localizable.dart';
import '../Utils/constants.dart';
import './roundButton.dart';

class HeaderLoginSignupWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  HeaderLoginSignupWidget({this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
            children: <Widget>[
              Spacer(),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    Localizable.valuefor(key: "Main.App.Title", context: context),
                    style: Constants.theme.appTitle,
                  )),
              RoundButton(
                  text: buttonText,
                  onPressed: onPressed),
            ],
          );
  }
}

class EmailTextField extends StatelessWidget {
  final void Function(String) onSaved;
  EmailTextField({this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 100,
          child: Text(
              Localizable.valuefor(
                  key: "LOGIN.EMAIL.TEXTFIELD", context: context),
              style: Constants.theme.subtitle)),
      Expanded(
          child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Localizable.valuefor(
                    key: "COMMON.TEXTFIELD.REQUIRED", context: context),
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: onSaved,
              // The validator receives the text that the user has entered.
              validator: (value) {
                onSaved(value);
                /*
                if (value.isEmpty) {
                  return Localizable.valuefor(
                      key: "SIGNUP.EMAIL.NOTVALID", context: context);
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return Localizable.valuefor(
                      key: "SIGNUP.EMAIL.NOTVALID", context: context);
                }*/
                return null;
              })),
    ]);
  }
}

class PasswordTextField extends StatelessWidget {
  final void Function(String) onSaved;
  PasswordTextField({this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 100,
          child: Text(
              Localizable.valuefor(
                  key: "LOGIN.PASSWORD.TEXTFIELD", context: context),
              style: Constants.theme.subtitle)),
      Expanded(
          child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Localizable.valuefor(
                    key: "COMMON.TEXTFIELD.REQUIRED", context: context),
              ),
              obscureText: true,
              onSaved: onSaved,
              validator: (value) {
                onSaved(value);
                /*
                if (value.isEmpty) {
                  return Localizable.valuefor(
                      key: "COMMON.TEXTFIELD.REQUIRED", context: context);
                }*/
                return null;
              }))
    ]);
  }
}
