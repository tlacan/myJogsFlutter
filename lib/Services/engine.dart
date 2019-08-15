import 'package:localstorage/localstorage.dart';
import './userService.dart';
import './widgetRefreshManager.dart';

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
  final WidgetRefreshManager widgetRefreshManager = WidgetRefreshManager();
  List<EngineComponent> components = List();
  _EngineState engineState = _EngineState(onboardingCompleted: false);

  Engine() {
    userService = UserService(storageManager: storageManager);
    components.add(userService);
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
