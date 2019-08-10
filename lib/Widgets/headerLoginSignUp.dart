import 'package:flutter/material.dart';

import '../Utils/constants.dart';
import '../Utils/localizable.dart';
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