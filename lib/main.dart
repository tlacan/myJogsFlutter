import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import './Services/engine.dart';
import './Utils/localizable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomeScreen(),
    );
  }
}

class _ClassOnboardingPageElement extends StatelessWidget {
  final AssetImage image;
  final String description;
  _ClassOnboardingPageElement({this.image, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Image(
              image: image,
            ),
            Text(description ?? "")
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final Engine engine;
  final pageController = PageController(initialPage: 0);
  OnboardingScreen(this.engine);

  @override
  Widget build(BuildContext context) {
    engine.launchedApplication();
    return CupertinoPageScaffold(
        backgroundColor: Colors.yellow,
        child: PageView(
          controller: pageController,
          children: <Widget>[
            _ClassOnboardingPageElement(
              image: AssetImage('assets/images/icon-logo-bis.png'),
              description: Localizable.valuefor(
                  key: "ONBOARDING.STEP.1.DESCRIPTION", context: context),
            ),
            _ClassOnboardingPageElement(
              image: AssetImage('assets/images/icon-shoe.png'),
              description: Localizable.valuefor(
                  key: "ONBOARDING.STEP.2.DESCRIPTION", context: context),
            ),
            _ClassOnboardingPageElement(
              image: AssetImage('assets/images/icon-chrono.png'),
              description: Localizable.valuefor(
                  key: "ONBOARDING.STEP.3.DESCRIPTION", context: context),
            )
          ],
        ));
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
  final engine = Engine();

  @override
  Widget build(BuildContext context) {
    //if (!this.engine.engineState.appAlreadyLaunched) {
      return OnboardingScreen(engine);
    //}
    //return MainScreen(engine);
  }
}
