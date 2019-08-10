import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:my_jogs/Models/UserModel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import './engine.dart';
import '../Utils/constants.dart';
import '../Utils/localizable.dart';

abstract class UserServiceObserver {
  void userDidLogin();
}

class UserService implements EngineComponent {
  final LocalStorage storageManager;

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
  }

  UserService({this.storageManager});

  addObserver(UserServiceObserver observer) {
    _observers.add(observer);
  }

  removeObserver(UserServiceObserver observer) {
    _observers.remove(observer);
  }
  loginBis() {
    for (UserServiceObserver observer in _observers) {
      observer.userDidLogin();
    }
  }

  Future<UserModel> login({String login, String password, BuildContext context}) async {
    final response = await http.post(Constants.url.login, 
      body: {'login': login, 'password': password});
        
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // If server returns an OK response, parse the JSON.
      var user = UserModel.fromJson(jsonResponse.decode(response.body));
      userModel = user;
      for (UserServiceObserver observer in _observers) {
        observer.userDidLogin();
      }
      return user;
    } else if (response.statusCode == 500) {
      throw Exception(Localizable.valuefor(key:"APIERROR.COMMON", context: context));
    } else {
      throw Exception(Localizable.valuefor(key:"APIERROR.COMMON", context: context));
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