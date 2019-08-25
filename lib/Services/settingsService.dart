import 'package:localstorage/localstorage.dart';

import '../Models/settingsModel.dart';
import 'engine.dart';

class SettingsService implements EngineComponent {
  final LocalStorage storageManager;
  SettingsModel _settingsModel;

  SettingsService({this.storageManager});

  SettingsModel get settingsModel => _settingsModel;
  set settingsModel(SettingsModel settingsModel) {
    this._settingsModel = settingsModel;
    if (_settingsModel == null) {
      storageManager.deleteItem(SettingsModel.storageKey); 
      return;
    }
    storageManager.setItem(SettingsModel.storageKey, _settingsModel);
  }

  void changeSpeedTarget(double value) {
    this._settingsModel.speedTarget = value;
    storageManager.setItem(SettingsModel.storageKey, _settingsModel);
  }

  void changeToleranceValue(double value) {
    this._settingsModel.toleranceValue = value;
    storageManager.setItem(SettingsModel.storageKey, _settingsModel);
  }

  @override
  storageReady() {
    final storedSettingNotMapped = storageManager.getItem(SettingsModel.storageKey);
    if (storedSettingNotMapped != null) {
      settingsModel = SettingsModel.fromJson(storedSettingNotMapped);
      return;
    }
    settingsModel = SettingsModel.defaultValue();
  }

  @override
  userDidLogOut() {
    settingsModel = SettingsModel.defaultValue();
  }

}