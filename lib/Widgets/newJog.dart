import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:my_jogs/Manager/widgetRefreshManager.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Services/locationService.dart';
import 'package:my_jogs/Utils/localizable.dart';
import 'package:my_jogs/Widgets/alert.dart';
import 'package:my_jogs/Widgets/speed.dart';
import '../Utils/constants.dart';

class NewJogWidget extends StatefulWidget {
  final Engine engine;
  NewJogWidget({this.engine});
  _NewJogWidgetState createState() => _NewJogWidgetState(engine: engine);
}

class _NewJogWidgetState extends State<NewJogWidget> implements LocationServiceObserver {
  final Engine engine;
  List<LocationData> locations = new List();
  DateTime start;
  _NewJogWidgetState({this.engine});

  @override
  void initState() {
    initializeLocation();
    engine.locationService.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    engine.locationService.stopTracking();
    engine.locationService.removeObserver(this);
    super.dispose();
  }

  void initializeLocation() async {
    await engine.locationService.location.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);
    bool serviceStatus = await engine.locationService.location.serviceEnabled();
    print("Service status: $serviceStatus");
    if (serviceStatus) {
      bool permission = await engine.locationService.location.requestPermission();
      if (!permission) {
        AlertWidget.presentDialog(messsage: Localizable.valuefor(key: "JOG.ERROR.AUTHORIZATION", context: context), context: context);
      }
    }
  }

  void startPressed() {
    start = DateTime.now();
    engine.locationService.startTracking();
    engine.jogsService.startTimer();
  }

  void pausePressed() {
    if (engine.jogsService.stopwatch.isRunning) {
      engine.locationService.stopTracking();
    } else {
      engine.locationService.startTracking();
    }
    engine.jogsService.pauseTimer();
  }

  void resetPressed() {
    locations = new List();
    engine.locationService.startTracking();
    engine.jogsService.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TimerTextWidget(engine: engine),
                SpeedTextWidget(engine: engine),
                Row(children: <Widget>[
                  FlatButton(onPressed: startPressed, child: Text("start"), textColor: Colors.white,),
                  FlatButton(onPressed: engine.jogsService.pauseTimer, child: Text("pause"), textColor: Colors.white,),
                ],)
              ]
            ),
        )
    );
  }

  @override
  void onLocationChanged(LocationData currentLocation) {
    locations.add(currentLocation);
    engine.widgetRefreshManager.notifyRefresh(key: WidgetRefreshManager.speedKey, value: currentLocation);
  }
}

class TimerTextWidget extends StatefulWidget {
  final Engine engine;
  TimerTextWidget({this.engine});
  
  _TimerTextWidgetState createState() => _TimerTextWidgetState(engine: engine);
}

class _TimerTextWidgetState extends State<TimerTextWidget> {
  final Engine engine;
  Timer timer;

  _TimerTextWidgetState({this.engine});

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: 100), (Timer t) {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String minutes() {
    int hundreds = (engine.jogsService.stopwatch.elapsedMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    return minutes.toString().padLeft(2, '0');
  }

  String seconds() {
    int hundreds = (engine.jogsService.stopwatch.elapsedMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int secondsToDisplay = seconds - minutes * 60;
    return secondsToDisplay.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('${minutes()}:${seconds()}', style: Constants.theme.chromo, textAlign: TextAlign.center),
    );
  }
}
