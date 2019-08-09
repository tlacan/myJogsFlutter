import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


import './Services/engine.dart';
import './Widgets/onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final engine = Engine();

  @override
  Widget build(BuildContext context) {
    return engine.engineState.appAlreadyLaunched ? CupertinoApp(home: HomeScreen(engine)) :
    CupertinoApp(
      routes: <String, WidgetBuilder> {
        '/onBoarding': (BuildContext context) => OnboardingScreen(engine),
        '/main': (BuildContext context) => MainScreen(engine),
      },
    home: HomeScreen(engine)
    );
  }
}

class MainScreen extends StatelessWidget {
  final Engine engine;

  MainScreen(this.engine);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle), title: Text("Jambon")),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock), title: Text("Fromage")),
        ],
      ),
      tabBuilder: (context, index) {
        return Center(
          child: Text("Hello"),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Engine engine;

  HomeScreen(this.engine);
  @override
  Widget build(BuildContext context) {
    return !engine.engineState.appAlreadyLaunched ? OnboardingScreen(engine) :
      MainScreen(engine);
  }
}
