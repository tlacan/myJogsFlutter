import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:my_jogs/Models/jogModel.dart';
import 'package:my_jogs/Models/positionModel.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Services/serviceState.dart';
import 'package:my_jogs/Services/sessionService.dart';
import 'package:my_jogs/Utils/constants.dart';
import 'package:my_jogs/Utils/localizable.dart';

abstract class JogsServiceObserver {
  void onJogsService({JogsService jogsService, ServiceState state, String error});
}

class JogsService implements EngineComponent {
  final LocalStorage storageManager;
  final SessionService sessionService;
  ServiceState state = ServiceState.idle;
  List<JogModel> _jogs = List();
  List<JogsServiceObserver> _observers = List();
  Stopwatch stopwatch = Stopwatch();

  JogsService({this.storageManager, this.sessionService});

  List<JogModel> get jogs => _jogs;
  set jogs(List<JogModel> jogs) {
    this._jogs = jogs;
    if (_jogs == null) {
      storageManager.deleteItem(JogModel.storageKey); 
      return;
    }
    storageManager.setItem(JogModel.storageKey, _jogs);
  }

  void startTimer() {
    stopwatch.reset();
    stopwatch.start();
  }

  void pauseTimer() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      return;
    }
    stopwatch.start();
  }

  void resetTimer() {
    stopwatch.reset();
    stopwatch.stop();
  }

  void _addJog(JogModel jog) {
    jogs.add(jog);
    storageManager.setItem(JogModel.storageKey, _jogs);
  }

  void _removeJog(JogModel jog) {
    jogs.remove(jog);
    storageManager.setItem(JogModel.storageKey, _jogs);
  }

  Future<JogModel> _createJog({int userId, List<LocationData> locations, DateTime begin}) async {
    List<PositionModel> positions = List();
    DateTime end = begin.add(Duration(milliseconds:stopwatch.elapsedMilliseconds));
    for (var location in locations) {
      positions.add(PositionModel(lat: location.latitude, lon: location.longitude));
    }
    return JogModel(userId: userId, position: positions, beginDate: begin, endDate: end);
  }

  Future<String> saveJog({int userId, List<LocationData> locations, DateTime begin, BuildContext context}) async {
    JogModel jog = await _createJog(userId: userId, locations: locations, begin: begin);
    _addJog(jog);
    return postJog(jog: jog, context: context);
  }

  Future<String> postJog({JogModel jog, BuildContext context}) async {
    final body = jog.toJson();
    var headers = sessionService.sessionHeader();
    headers["content-type"] = "application/json";
    final response = await http.post(Constants.url.jogs, body: convert.jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jogs[jogs.indexOf(jog)].id = jsonResponse["id"];
      return null;
    }
    return context == null ? null : Localizable.valuefor(key:"JOG.ALERT.FAIL.MESSAGE", context: context);
  }

  addObserver(JogsServiceObserver observer) {
    _observers.add(observer);
  }

  removeObserver(JogsServiceObserver observer) {
    _observers.remove(observer);
  }

  void setState({ServiceState newState, String error}) {
    state = newState;
    for (JogsServiceObserver observer in _observers) {
      observer.onJogsService(jogsService: this, state: state, error: error);
    }
  }

  void saveStoredJogsIfNeeded() async {
    for (var jog in jogs) {
      if (jog.id == null) {
        postJog(jog: jog, context: null);
      }
    }
  }

  @override
  storageReady() {
    final storedJogsNotMapped = storageManager.getItem(JogModel.storageKey);
    if (storedJogsNotMapped != null) {
      jogs = JogModel.fromJsonArray(storedJogsNotMapped);
      saveStoredJogsIfNeeded();
      return;
    }
    jogs = List();
  }

  @override
  userDidLogOut() {
    jogs = List();
    stopwatch.reset();
  }

}