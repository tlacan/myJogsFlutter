import 'package:flutter/material.dart';

import '../Services/engine.dart';
import '../Utils/constants.dart';
import '../Services/widgetRefreshManager.dart';

class RoundButton extends StatefulWidget {
  final Engine engine;
  final String text;
  final VoidCallback onPressed;

  RoundButton({this.engine, this.text, this.onPressed});

  @override
  _RoundButtonState createState() => _RoundButtonState(engine: engine, text: text, onPressed: onPressed);
}

class _RoundButtonState extends State<RoundButton> implements WidgetRefresherManagerObserver {
  final Engine engine;
  VoidCallback onPressed;
  final String text;
  _RoundButtonState({this.engine, this.text, this.onPressed}) {
    engine?.widgetRefreshManager?.addObserver(key: WidgetRefreshManager.loginFormKey, observer: this);
  }
 
  @override
	void dispose(){
		super.dispose();
    engine?.widgetRefreshManager?.removeObserver(key: WidgetRefreshManager.loginFormKey, observer: this);
	}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
                    color: onPressed == null ? Constants.colors.lightGray : Colors.black,
                    style: BorderStyle.solid,
                    width: 2.0,
                ),
                borderRadius: BorderRadius.circular(18.0),
      ),
      child: 
      FlatButton(
        disabledTextColor: Constants.colors.lightGray,
        child: Text(widget.text, 
                style:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, 
                color: onPressed == null ? Constants.colors.lightGray : Colors.black, 
                fontFamily: "SF UI Display")),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void doRefresh(Object value) {
    if (value is VoidCallback == false && value != null) {
      return;
    }
    setState(() { 
      onPressed = value;
    });
  }
}