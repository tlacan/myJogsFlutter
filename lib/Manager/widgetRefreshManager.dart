abstract class WidgetRefresherManagerObserver {
    void doRefresh(Object value);
}

class WidgetRefreshManager {
  static final loginFormKey = "LoginForm";
  static final signupFormKey = "SignUpForm";
  static final signupPassworComfirmKey = "SignUpConfirm";
  static final tabBarKey = "TabbarKey";

  Map<String,List<WidgetRefresherManagerObserver>> _observers = Map<String,List<WidgetRefresherManagerObserver>>();

  void addObserver({key: String, WidgetRefresherManagerObserver observer}) {
   if (_observers.containsKey(key)) {
     var list = _observers[key];
     list.add(observer);
     _observers[key] = list;
     return;
   }
    _observers[key] = [observer];
  }

  void removeObserver({key: String, WidgetRefresherManagerObserver observer}) {
      if (_observers.containsKey(key)) {
        var list = _observers[key];
        list.remove(observer);
        _observers[key] = list;
      }
  }

  void notifyRefresh({key: String, value: Object}) {
    if (_observers.containsKey(key)) {
        List<WidgetRefresherManagerObserver> observers = _observers[key];
        for (var observer in observers) {
          observer.doRefresh(value);
        }
    }
  }
}