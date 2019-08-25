import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_jogs/Services/engine.dart';
import '../Utils/constants.dart';

class NewJogWidget extends StatefulWidget {
  final Engine engine;
  NewJogWidget({this.engine});
  _NewJogWidgetState createState() => _NewJogWidgetState(engine: engine);
}

class _NewJogWidgetState extends State<NewJogWidget> {
  final Engine engine;
  final Stopwatch stopwatch = Stopwatch();
  _NewJogWidgetState({this.engine});



  @override
  Widget build(BuildContext context) {
    stopwatch.start();
    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(stopwatch.elapsed.inSeconds.toString(), style: Constants.theme.chromo, textAlign: TextAlign.center,),
              ]
            ),
        )
    );
  }
}
