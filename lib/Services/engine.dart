import 'package:localstorage/localstorage.dart';

class EngineState {
  static final storageKey = "engineState";
  bool appAlreadyLaunched;

  EngineState({this.appAlreadyLaunched});
  EngineState.fromJson(Map<String, dynamic> json)
      : appAlreadyLaunched = json['appAlreadyLaunched'];

  Map<String, dynamic> toJson() => {
        'appAlreadyLaunched': appAlreadyLaunched,
      };
}

class Engine {
  final LocalStorage storageManager = LocalStorage("Engine");
  EngineState engineState;

  Engine() {
    final storedEngineStateNotMapped = storageManager.getItem(EngineState.storageKey);
    if (storedEngineStateNotMapped != null) {
      engineState = EngineState.fromJson(storedEngineStateNotMapped);
      return;
    }
    engineState = EngineState(appAlreadyLaunched: false);
  }

  launchedApplication() {
    engineState.appAlreadyLaunched = true;
    storageManager.setItem(EngineState.storageKey, engineState);
    final storedEngineStateNotMapped = storageManager.getItem(EngineState.storageKey);
    if (storedEngineStateNotMapped != null) {
      engineState = EngineState.fromJson(storedEngineStateNotMapped);
      return;
    }
  }
}
