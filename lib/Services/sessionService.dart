
import 'package:localstorage/localstorage.dart';

import '../Models/sessionModel.dart';
import 'engine.dart';

class SessionService implements EngineComponent {
  final LocalStorage storageManager;
  static final String kAutorizationHeader = "Authorization";
  SessionModel _sessionModel;

  SessionService({this.storageManager});

  SessionModel get sessionModel => _sessionModel;
  set sessionModel(SessionModel sessionModel) {
    this._sessionModel = sessionModel;
    if (sessionModel == null) {
      storageManager.deleteItem(SessionModel.storageKey); 
      return;
    }
    storageManager.setItem(SessionModel.storageKey, sessionModel.encrypted());
  }

  Map<String, String> sessionHeader() {
    if (sessionModel == null) {
      return Map();
    }
    return {SessionService.kAutorizationHeader : "Bearer ${sessionModel.token}"};
  }

  @override
  storageReady() {
    final storedSessionModelNotMapped = storageManager.getItem(SessionModel.storageKey);
    if (storedSessionModelNotMapped != null) {
      sessionModel = SessionModel.fromJson(storedSessionModelNotMapped).decrypted();
    }
  }

  @override
  userDidLogOut() {
    this.sessionModel = null;
  }

}