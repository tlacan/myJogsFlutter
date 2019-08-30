import 'dart:async';

import 'package:location/location.dart';
import './engine.dart';

abstract class LocationServiceObserver {
  void onLocationChanged(LocationData currentLocation);
}

class LocationService implements EngineComponent {
  Location location = Location();
  StreamSubscription currentStream;
  List<LocationServiceObserver> _observers = List();

  addObserver(LocationServiceObserver observer) {
    _observers.add(observer);
  }

  removeObserver(LocationServiceObserver observer) {
    _observers.remove(observer);
  }
  
  void startTracking() {
    currentStream = location.onLocationChanged().listen((LocationData currentLocation) {
      for (LocationServiceObserver observer in _observers) {
        observer.onLocationChanged(currentLocation);
      }
    });
  }
    
  void stopTracking() {
    currentStream.cancel();
  }

  @override
  userDidLogOut() {
    stopTracking();
  }

  @override
  storageReady() {
    return;
  }
}