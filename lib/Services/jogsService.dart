import 'package:localstorage/localstorage.dart';

import 'package:my_jogs/Models/jogModel.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Services/serviceState.dart';
import 'package:my_jogs/Services/sessionService.dart';

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
  }

  void addJog(JogModel jog) {
    jogs.add(jog);
    storageManager.setItem(JogModel.storageKey, _jogs);
  }

  void removeJog(JogModel jog) {
    jogs.remove(jog);
    storageManager.setItem(JogModel.storageKey, _jogs);
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

  @override
  storageReady() {
    final storedJogsNotMapped = storageManager.getItem(JogModel.storageKey);
    if (storedJogsNotMapped != null) {
      jogs = JogModel.fromJsonArray(storedJogsNotMapped);
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