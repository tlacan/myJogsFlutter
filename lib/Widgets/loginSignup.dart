import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Utils/localizable.dart';
import '../Utils/constants.dart';
import '../Utils/helper.dart';
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
              Flexible(
                fit: FlexFit.tight,
                child:
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: AutoSizeText(
                    Localizable.valuefor(key: "Main.App.Title", context: context),
                    style: Constants.theme.appTitle,
                    maxLines: 1,
                  ))),
              Expanded(child: 
                RoundButton(
                    text: buttonText,
                    onPressed: onPressed),
              )
              
            ],
          );
  }
}

class EmailTextField extends StatelessWidget {
  final void Function(String) onSaved;
  final bool withValidation;
  EmailTextField({this.onSaved, this.withValidation = false});

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
                errorStyle: Constants.theme.errorText,
                border: InputBorder.none,
                hintText: Localizable.valuefor(
                    key: "COMMON.TEXTFIELD.REQUIRED", context: context),
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: onSaved,
              // The validator receives the text that the user has entered.
              validator: (value) {
                onSaved(value);
                if (!withValidation || Helper.isNullOrEmpty(value)) {
                  return null;
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                  return Localizable.valuefor(key: "SIGNUP.EMAIL.NOTVALID", context: context);
                }
                return null;
              })),
    ]);
  }
}

class PasswordTextField extends StatelessWidget {
  final void Function(String) onSaved;
  final bool withValidation;
  final bool isConfirmation;
  PasswordTextField({this.onSaved, this.withValidation = false, this.isConfirmation = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: isConfirmation ? 150 : 100,
          child: Text(
              Localizable.valuefor(
                  key: isConfirmation ? "SIGNUP.PASSWORD_CONFIRM.TEXTFIELD" : "LOGIN.PASSWORD.TEXTFIELD", context: context),
              style: Constants.theme.subtitle)),
      Expanded(
          child: TextFormField(
              decoration: InputDecoration(
                errorStyle: Constants.theme.errorText,
                border: InputBorder.none,
                hintText: Localizable.valuefor(
                    key: "COMMON.TEXTFIELD.REQUIRED", context: context),
              ),
              obscureText: true,
              onSaved: onSaved,
              validator: (value) {
                onSaved(value);
                if (!withValidation) {
                  return null;
                }
                int length = value?.length ?? 0;
                if (length > 0 && length < 8) {
                  return Localizable.valuefor(key: "SIGNUP.PASSWORD.NOTVALID", context: context);
                }
                return null;
              }))
    ]);
  }
}
