import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:my_jogs/Models/UserModel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import './engine.dart';
import './serviceState.dart';
import '../Utils/constants.dart';
import '../Utils/localizable.dart';

abstract class UserServiceObserver {
  void onUserService({UserService userService, ServiceState state, String error});
  void userDidLogin();
}

class UserService implements EngineComponent {
  final LocalStorage storageManager;
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

  UserService({this.storageManager});

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
      body: {'login': login, 'password': password});
        
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // If server returns an OK response, parse the JSON.
      var user = UserModel.fromJson(jsonResponse.decode(response.body));
      if (user == null) {
        setState(newState: ServiceState.error, error: Localizable.valuefor(key:"APIERROR.COMMON", context: context));
        return Localizable.valuefor(key:"APIERROR.COMMON", context: context);
      }
      userModel = user;
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
      body: {'login': login, 'password': password});
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

  }


}