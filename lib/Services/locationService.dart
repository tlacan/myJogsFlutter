import 'package:location/location.dart';
import './engine.dart';

abstract class LocationServiceObserver {
  void onLocationChanged(LocationData currentLocation);
}

class LocationService implements EngineComponent {
  Location location = Location();
  List<LocationServiceObserver> _observers = List();

  addObserver(LocationServiceObserver observer) {
    _observers.add(observer);
  }

  removeObserver(LocationServiceObserver observer) {
    _observers.remove(observer);
  }
  
  void startTracking() {
    location.onLocationChanged().listen((LocationData currentLocation) {
      for (LocationServiceObserver observer in _observers) {
        observer.onLocationChanged(currentLocation);
      }
    });
  }
    
  void stopTracking() { 
    location = null;
    location = Location();
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