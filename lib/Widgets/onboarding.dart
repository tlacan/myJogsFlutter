import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:my_jogs/Utils/constants.dart';

import '../Services/engine.dart';
import '../Utils/localizable.dart';

class OnboardingScreen extends StatefulWidget {
  final Engine engine;

  OnboardingScreen(this.engine);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState(engine);
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Engine engine;
  final pageController = PageController(initialPage: 0);
  int currentPage = 0;
  static final totalPages = 3;

  _OnboardingScreenState(this.engine);

  void pageChanged(int currentPage) {
    setState(() {
      this.currentPage = currentPage;
    });
  }

  Widget dotsOrButton(BuildContext context) {
    return currentPage == totalPages - 1 ? _CloseOnboardingButton(engine) :
      DotsIndicator(
        dotsCount: totalPages,
        position: currentPage,
        decorator: dotDecorator,
      );
  }

  final dotDecorator = DotsDecorator(
      activeColor: Colors.black,
      activeSize: Size.square(12.0),
      color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.yellow,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: _ClassOnboardingPageView(
                pageController: pageController,
                onPageChanged: pageChanged,
              )),
              Center(
                  child: Container(
                alignment: AlignmentDirectional(0.0, 0.0),
                width: double.infinity,
                height: 50,
                child: dotsOrButton(context),
              ))
            ],
          ),
        ));
  }
}

class _CloseOnboardingButton extends StatelessWidget {
  final Engine engine;

  _CloseOnboardingButton(this.engine);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2.0,
                ),
                borderRadius: BorderRadius.circular(18.0),
      ),
      child: 
      FlatButton(
        child: Text(Localizable.valuefor(key: "ONBOARDING.END.BUTTON", context: context),
        style: Constants.theme.subtitle,),
        onPressed: () { 
          engine.launchedApplication();
          Navigator.of(context).pushReplacementNamed('/main'); 
          },
      ),
    );
  }
}

class _ClassOnboardingPageView extends StatelessWidget {
  final PageController pageController;
  final void Function(int) onPageChanged;

  _ClassOnboardingPageView({this.pageController, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              Localizable.valuefor(key: "Main.App.Title", context: context),
              style: Constants.theme.appTitle,
            ),
            Image(
              image: image,
              color: Colors.black,
              width: 200,
              height: 200,
            ),
            Text(
              description ?? "",
              textAlign: TextAlign.center,
              style: Constants.theme.onboardingText,
            )
          ],
        ),
      ),
    );
  }
}
