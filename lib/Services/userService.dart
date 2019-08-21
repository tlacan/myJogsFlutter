import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_jogs/Models/sessionModel.dart';

import './engine.dart';
import './serviceState.dart';
import './sessionService.dart';
import '../Utils/constants.dart';
import '../Utils/localizable.dart';
import '../Models/userModel.dart';

abstract class UserServiceObserver {
  void onUserService({UserService userService, ServiceState state, String error});
  void userDidLogin();
  void userDidLogout();
}

class UserService implements EngineComponent {
  final LocalStorage storageManager;
  final SessionService sessionService;
  ServiceState state = ServiceState.idle;

  List<UserServiceObserver> _observers = List();
  UserModel _userModel;

  UserModel get userModel => _userModel;
  set userModel(UserModel userModel) {
    this._userModel = userModel;
    if (userModel == null) {
      storageManager.deleteItem(UserModel.storageKey); 
      return;
    }
    storageManager.setItem(UserModel.storageKey, userModel);
    state = ServiceState.loaded;
  }

  UserService({this.storageManager, this.sessionService});

  addObserver(UserServiceObserver observer) {
    _observers.add(observer);
  }

  removeObserver(UserServiceObserver observer) {
    _observers.remove(observer);
  }
  
  bool connected() {
    return userModel != null;
  }

  void setState({ServiceState newState, String error}) {
    state = newState;
    for (UserServiceObserver observer in _observers) {
      observer.onUserService(userService: this, state: state, error: error);
    }
  }

  Future<String> login({String login, String password, BuildContext context}) async {
    setState(newState: ServiceState.loading);
    final response = await http.post(Constants.url.login, 
      body: {'email': login, 'password': password});
        
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // If server returns an OK response, parse the JSON.
      var user = UserModel.fromJson(jsonResponse);
      var session = SessionModel.fromJson(jsonResponse);
      if (user == null || session == null) {
        setState(newState: ServiceState.error, error: Localizable.valuefor(key:"APIERROR.COMMON", context: context));
        return Localizable.valuefor(key:"APIERROR.COMMON", context: context);
      }
      sessionService.sessionModel = session;
      userModel =  UserModel(email: login, password: password, userId: user.userId);
      for (UserServiceObserver observer in _observers) {
        observer.userDidLogin();
      }
      setState(newState: ServiceState.loaded);
      return null;
    } else if (response.statusCode == 400) {
      setState(newState: ServiceState.error, error: Localizable.valuefor(key:"APIERROR.WRONG_CREDENTIALS", context: context));
      return Localizable.valuefor(key:"APIERROR.WRONG_CREDENTIALS", context: context);
    } else {
      setState(newState: ServiceState.error, error: Localizable.valuefor(key:"APIERROR.COMMON", context: context));
      return Localizable.valuefor(key:"APIERROR.WRONG_CREDENTIALS", context: context);
    }
  }

  Future<String> signUp({String login, String password, BuildContext context}) async {
    setState(newState: ServiceState.loading);
    final response = await http.post(Constants.url.signUp, 
      body: {'email': login, 'password': password});
    if (response.statusCode == 200) {
      return this.login(login: login, password: password, context: context);
    } else if (response.statusCode == 400) {
      return Localizable.valuefor(key:"APIERROR.WRONG_CREDENTIALS", context: context);
    } else {
      return Localizable.valuefor(key:"APIERROR.COMMON", context: context);
    }
  }

  @override
  storageReady() {
    final storedUserModelNotMapped = storageManager.getItem(UserModel.storageKey);
    if (storedUserModelNotMapped != null) {
      userModel = UserModel.fromJson(storedUserModelNotMapped);
    }
  }

  @override
  userDidLogOut() {
    userModel = null;
    for (UserServiceObserver observer in _observers) {
        observer.userDidLogout();
      }
  }
}