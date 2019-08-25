import 'package:localstorage/localstorage.dart';
import 'package:my_jogs/Services/jogsService.dart';

import './userService.dart';
import './sessionService.dart';
import './settingsService.dart';
import '../manager/widgetRefreshManager.dart';

abstract class EngineComponent {
  userDidLogOut();
  storageReady();
}

class _EngineState {
  static final storageKey = "engineState";
  bool onboardingCompleted;

  _EngineState({this.onboardingCompleted});
  _EngineState.fromJson(Map<String, dynamic> json)
      : onboardingCompleted = json['onboardingCompleted'];

  Map<String, dynamic> toJson() => {
    'onboardingCompleted': onboardingCompleted,
  };
}

class Engine {
  final LocalStorage storageManager = LocalStorage("Engine");
  UserService userService;
  SessionService sessionService;
  SettingsService settingsService;
  JogsService jogsService;
  final WidgetRefreshManager widgetRefreshManager = WidgetRefreshManager();
  List<EngineComponent> components = List();
  _EngineState engineState = _EngineState(onboardingCompleted: false);

  Engine() {
    sessionService = SessionService(storageManager: storageManager);
    userService = UserService(storageManager: storageManager, sessionService: sessionService);
    settingsService = SettingsService(storageManager: storageManager);
    jogsService = JogsService(storageManager: storageManager);
    components.add(jogsService);
    components.add(settingsService);
    components.add(userService);
    components.add(sessionService);
  }

  loadDataInStoreManager() {
    final storedEngineStateNotMapped = storageManager.getItem(_EngineState.storageKey);
    if (storedEngineStateNotMapped != null) {
      engineState = _EngineState.fromJson(storedEngineStateNotMapped);
    }
    for (var component in components) {
      component.storageReady();
    }
  }

  userDidLogout() {
    for (var component in components) {
      component.userDidLogOut();
    }
  }

  onboardingCompleted() {
    engineState.onboardingCompleted = true;
    storageManager.setItem(_EngineState.storageKey, engineState);
  }
}
