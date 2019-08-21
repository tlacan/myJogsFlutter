
import 'package:localstorage/localstorage.dart';
import 'package:my_jogs/Models/sessionModel.dart';

import '../Models/sessionModel.dart';
import 'engine.dart';

class SessionService implements EngineComponent {
  final LocalStorage storageManager;
  static final String kAutorizationHeader = "Authorization";
  SessionModel _sessionModel;

  SessionService({this.storageManager});

  SessionModel get sessionModel => _sessionModel;
  set sessionModel(SessionModel sessionModel) {
    this._sessionModel = _sessionModel;
    if (sessionModel == null) {
      storageManager.deleteItem(SessionModel.storageKey); 
      return;
    }
    storageManager.setItem(SessionModel.storageKey, sessionModel);
  }

  Map<String, String> sessionHeader() {
    if (sessionModel == null) {
      return Map();
    }
    return {SessionService.kAutorizationHeader : sessionModel.token};
  }

  @override
  storageReady() {
    final storedUserModelNotMapped = storageManager.getItem(SessionModel.storageKey);
    if (storedUserModelNotMapped != null) {
      sessionModel = SessionModel.fromJson(storedUserModelNotMapped);
    }
  }

  @override
  userDidLogOut() {
    this.sessionModel = null;
    return null;
  }

}