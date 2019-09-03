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

class _NewJogWidgetState extends State<NewJogWidget>
    implements LocationServiceObserver {
  final Engine engine;
  List<LocationData> locations = new List();
  DateTime start;
  bool isLoading = false;
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
    await engine.locationService.location
        .changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);
    bool serviceStatus = await engine.locationService.location.serviceEnabled();
    print("Service status: $serviceStatus");
    if (serviceStatus) {
      bool permission =
          await engine.locationService.location.requestPermission();
      if (!permission) {
        AlertWidget.presentDialog(
            messsage: Localizable.valuefor(
                key: "JOG.ERROR.AUTHORIZATION", context: context),
            context: context);
      }
    }
  }

  void startPressed() {
    setState(() {
      start = DateTime.now();
      engine.locationService.startTracking();
      engine.jogsService.startTimer();
    });
  }

  void pausePressed() {
    setState(() {
      if (engine.jogsService.stopwatch.isRunning) {
        engine.locationService.stopTracking();
      } else {
        engine.locationService.startTracking();
      }
      engine.jogsService.pauseTimer();
    });
    engine.widgetRefreshManager
        .notifyRefresh(key: WidgetRefreshManager.speedKey, value: null);
  }

  void resetData() {
    start = null;
    locations = new List();
    engine.locationService.stopTracking();
    engine.jogsService.resetTimer();
    engine.widgetRefreshManager
      .notifyRefresh(key: WidgetRefreshManager.speedKey, value: null);
  }

  void resetPressed() {
    setState(() {
      resetData();
    });
  }

  void savePressed() async {
    setState(() {
      isLoading = true;
    });
    String error = await engine.jogsService.saveJog(userId: engine.userService.userModel.userId,
                  locations: locations, begin: start, context: context);
    setState(() {
      isLoading = false;
      resetData(); 
    });
    if (error != null) {
      AlertWidget.presentDialog(messsage: error, context: context);
    } else {
      AlertWidget.presentDialog(messsage: Localizable.valuefor(
                                          key: "JOG.ALERT.SUCCESS.MESSAGE",
                                          context: context), context: context);
    }
  }

   bool speedValid() {
    if (locations.isNotEmpty) {
      LocationData lastLocation = locations.last;
      double speed = (lastLocation.speed ?? 0) * 3.6;
      double speedTarget = engine.settingsService.settingsModel.speedTarget;
      if (speed > speedTarget) {
        return (speed -
                (speedTarget *
                    engine.settingsService.settingsModel.toleranceValue)) <=
            speedTarget;
      }
      return (speed +
              (speedTarget *
                  engine.settingsService.settingsModel.toleranceValue)) >=
          speedTarget;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        child: SafeArea(
          child:
          Container(
            decoration: 
            !engine.jogsService.stopwatch.isRunning ? BoxDecoration() :
            BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.4, 0.6],
              colors:
              [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.black,
                speedValid() ? Constants.colors.green : Constants.colors.red,
                Colors.black,
              ]
            ),),
          child: Column(
            
              mainAxisAlignment: MainAxisAlignment.center,
              children: isLoading
                  ? [
                      CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      )
                    ]
                  : <Widget>[
                      TimerTextWidget(engine: engine),
                      SpeedTextWidget(engine: engine),
                      Container(height: 30, width: 200),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: start != null
                            ? <Widget>[
                              Spacer(),
                                TimerButtonWidget(
                                    onPressed: resetPressed,
                                    text: Localizable.valuefor(
                                        key: "JOG.RESET.BUTTON",
                                        context: context),
                                    color: Constants.colors.red),
                                Spacer(),
                                TimerButtonWidget(
                                  onPressed: pausePressed,
                                  text: engine.jogsService.stopwatch.isRunning
                                      ? Localizable.valuefor(
                                          key: "JOG.PAUSE.BUTTON",
                                          context: context)
                                      : Localizable.valuefor(
                                          key: "JOG.RESUME.BUTTON",
                                          context: context),
                                  color: Colors.yellow,
                                ),
                                Spacer(),
                                TimerButtonWidget(
                                    onPressed: savePressed,
                                    text: Localizable.valuefor(
                                        key: "JOG.SAVE.BUTTON",
                                        context: context),
                                    color: Constants.colors.green),
                                Spacer(),
                              ]
                            : [
                                TimerButtonWidget(
                                    onPressed: startPressed,
                                    text: Localizable.valuefor(
                                        key: "JOG.START.BUTTON",
                                        context: context),
                                    color: Constants.colors.green)
                              ],
                      )
                    ]),
    )));
  }

  @override
  void onLocationChanged(LocationData currentLocation) {
    setState(() {
      locations.add(currentLocation);
    });
    engine.widgetRefreshManager.notifyRefresh(
        key: WidgetRefreshManager.speedKey, value: currentLocation);
  }
}

class TimerButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  TimerButtonWidget({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return 
        GestureDetector(
        onTap: onPressed,
        child: ClipOval(
          child: Container(
            color: color.withOpacity(0.3),
            height: 80.0, // height of the button
            width: 80.0, // width of the button
            child: Center(child: Text(text, style: TextStyle(color: color)),),
          ),
        ),
      );
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
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String minutes() {
    int hundreds =
        (engine.jogsService.stopwatch.elapsedMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    return minutes.toString().padLeft(2, '0');
  }

  String seconds() {
    int hundreds =
        (engine.jogsService.stopwatch.elapsedMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int secondsToDisplay = seconds - minutes * 60;
    return secondsToDisplay.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('${minutes()}:${seconds()}',
          style: Constants.theme.chromo, textAlign: TextAlign.center),
    );
  }
}
