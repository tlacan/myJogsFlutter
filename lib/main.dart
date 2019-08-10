import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


import './Services/engine.dart';
import './Widgets/onboarding.dart';
import './Widgets/mainTabbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final engine = Engine();

  @override
  Widget build(BuildContext context) {
    return engine.engineState.onboardingCompleted ? CupertinoApp(home: HomeScreen(engine)) :
    CupertinoApp(
      routes: <String, WidgetBuilder> {
        '/onBoarding': (BuildContext context) => OnboardingScreenWidget(engine),
        '/main': (BuildContext context) => MainWidget(engine),
      },
    home: HomeScreen(engine)
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Engine engine;

  HomeScreen(this.engine);
  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
          future: engine.storageManager.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
                // localstorage is ready
                engine.loadDataInStoreManager();
                return !engine.engineState.onboardingCompleted ? OnboardingScreenWidget(engine) :
                      MainWidget(engine);
            } else {
                return CircularProgressIndicator();
            }
          }
      );
  }
}
