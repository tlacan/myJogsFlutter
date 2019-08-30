import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import '../manager/widgetRefreshManager.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Utils/constants.dart';

class SpeedTextWidget extends StatefulWidget {
  final Engine engine;
  SpeedTextWidget({this.engine});
  _SpeedTextWidgetState createState() => _SpeedTextWidgetState(engine: engine);
}

class _SpeedTextWidgetState extends State<SpeedTextWidget>  implements WidgetRefresherManagerObserver {
  LocationData locationData;
  final Engine engine;

  _SpeedTextWidgetState({this.engine}) {
    engine.widgetRefreshManager.addObserver(key: WidgetRefreshManager.speedKey, observer: this);
  }

  @override
	void dispose(){
		super.dispose();
    engine.widgetRefreshManager.removeObserver(key: WidgetRefreshManager.speedKey, observer: this);
	}
  
  String speedText() {
    if (locationData == null || !engine.jogsService.stopwatch.isRunning) {
      return "";
    }
    double speed = locationData.speed * 3.6;
    return "${speed.toStringAsFixed(1)} km/h";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text(speedText(), style: Constants.theme.chromo, textAlign: TextAlign.center),
    );
  }

  @override
  void doRefresh(Object value) {
    setState(() {
      locationData = value;
    });
  }
  
}