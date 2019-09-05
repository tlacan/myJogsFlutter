import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:my_jogs/Utils/constants.dart';

import '../Services/engine.dart';
import '../Utils/localizable.dart';
import './roundButton.dart';

class OnboardingScreenWidget extends StatefulWidget {
  final Engine engine;

  OnboardingScreenWidget(this.engine);
  @override
  _OnboardingScreenWidgetState createState() => _OnboardingScreenWidgetState(engine);
}

class _OnboardingScreenWidgetState extends State<OnboardingScreenWidget> {
  final Engine engine;
  final pageController = PageController(initialPage: 0);
  int currentPage = 0;
  static final totalPages = 3;

  _OnboardingScreenWidgetState(this.engine);

  void pageChanged(int currentPage) {
    setState(() {
      this.currentPage = currentPage;
    });
  }

  Widget dotsOrButton(BuildContext context) {
    var roundButton = RoundButton(text: Localizable.valuefor(key: "ONBOARDING.END.BUTTON", context: context),
    onPressed: () { 
      engine.onboardingCompleted();
      Navigator.of(context).pushReplacementNamed('/main'); 
    } );
    return currentPage == totalPages - 1 ? roundButton :
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
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: AutoSizeText(
              description ?? "",
              textAlign: TextAlign.center,
              style: Constants.theme.onboardingText,
              maxLines:3
            ),)
            
          ],
        ),
      ),
    );
  }
}
