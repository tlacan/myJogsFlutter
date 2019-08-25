import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Utils/constants.dart';
import 'package:my_jogs/Utils/localizable.dart';

class SettingsWidget extends StatefulWidget {
  final Engine engine;
  SettingsWidget({this.engine});

  _SettingsWidgetState createState() => _SettingsWidgetState(engine: engine);
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final Engine engine;
  _SettingsWidgetState({this.engine});

  void logoutPressed() {
    engine.userDidLogout();
  }

  TableCell speedCell() {
    return TableCell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Constants.colors.border, width: 1))),
            height: 45,
            child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(Localizable.valuefor(key: "SETTINGS.TARGET.LABEL", context: context)),
                    ),
                    CupertinoSlider(
                      activeColor: Colors.indigoAccent,
                      min: 5.0,
                      max: 24.0,
                      onChanged: (value) {
                        setState(() =>
                            engine.settingsService.changeSpeedTarget(value));
                      },
                      value: engine.settingsService.settingsModel.speedTarget,
                    ),
                    Container(
                      child: Text("${engine
                          .settingsService.settingsModel.speedTarget
                          .toStringAsFixed(1)} km/h", textAlign: TextAlign.center,),
                      width: 45,
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0))));
  }
  
  TableCell toleranceCell() {
    return TableCell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Constants.colors.border, width: 1),
                    bottom: BorderSide(color: Constants.colors.border, width: 1))),
            height: 45,
            child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(Localizable.valuefor(key: "SETTINGS.DELTA.LABEL", context: context)),
                    ),
                    CupertinoSlider(
                      activeColor: Colors.indigoAccent,
                      min: 0.05,
                      max: 0.3,
                      onChanged: (value) {
                        setState(() =>
                            engine.settingsService.changeToleranceValue(value));
                      },
                      value: min(0.3, engine.settingsService.settingsModel.toleranceValue),
                    ),
                    Container(
                      child: Text("${(engine
                          .settingsService.settingsModel.toleranceValue * 100).toStringAsFixed(0)
                          } %", textAlign: TextAlign.center,),
                      width: 45,
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0))));
  }
  
  TableCell logoutCell(){
    return TableCell(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                color: Constants.colors.border, width: 1),
                            bottom: BorderSide(
                                color: Constants.colors.border, width: 1),
                          )),
                      height: 45,
                      child: Container(
                          alignment: Alignment.center,
                          child: FlatButton(
                              onPressed: logoutPressed,
                              textColor: Constants.colors.red,
                              child: Text(Localizable.valuefor(
                                  key: "SETTINGS.LOGOUT.BUTTON",
                                  context: context))),
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 0))));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: AutoSizeText(
            engine.userService.userModel?.email ??
                Localizable.valuefor(key: "SETTINGS.TITLE", context: context),
            style: Constants.theme.appTitle,
            maxLines: 1,
          ),
        ),
        child: SafeArea(
            child: Container(
                child: Table(
          children: [
            TableRow(children: [
              Container(
                height: 30,
              )
            ]),
            TableRow(children: [speedCell()]),
            TableRow(children: [toleranceCell()]),
            TableRow(children: [
              Container(
                height: 30,
              )
            ]),
            TableRow(children: [logoutCell()]),
          ],
        ))));
  }
}
