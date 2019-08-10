import 'package:flutter/material.dart';

import '../Utils/constants.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RoundButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2.0,
                ),
                borderRadius: BorderRadius.circular(18.0),
      ),
      child: 
      FlatButton(
        child: Text(text, style: Constants.theme.subtitle),
        onPressed: onPressed,
      ),
    );
  }
}