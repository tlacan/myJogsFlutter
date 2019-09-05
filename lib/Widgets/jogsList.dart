import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_jogs/Models/jogModel.dart';
import 'package:my_jogs/Services/engine.dart';
import 'package:my_jogs/Services/jogsService.dart';
import 'package:my_jogs/Services/serviceState.dart';
import 'package:my_jogs/Utils/constants.dart';
import 'package:my_jogs/Utils/helper.dart';
import 'package:my_jogs/Utils/localizable.dart';
import 'package:my_jogs/Widgets/alert.dart';
import 'package:my_jogs/Widgets/roundButton.dart';
import 'package:statusbar/statusbar.dart';

class JogsListWidget extends StatefulWidget {
  final Engine engine;
  JogsListWidget({this.engine});

  _JogsListWidgetState createState() => _JogsListWidgetState(engine: engine);
}

class _JogsListWidgetState extends State<JogsListWidget> implements JogsServiceObserver {
  final Engine engine;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  _JogsListWidgetState({this.engine}) {
    engine.jogsService.addObserver(this);
  }

  @override
  void initState() {
    super.initState();
    engine.jogsService.refreshJogs(context: context);
  }

  @override
  void dispose() {
    engine.jogsService.removeObserver(this);
    super.dispose();
  }

  TableCell jogCell(JogModel jog) {
    return TableCell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Constants.colors.border, width: 1))),
            height: 45,
            child: Container(child: Text("jambon"),
            )
        )
    );
  }

  List<TableRow> jogCells() {
    List<TableRow> result = new List();
    for (var jog in engine.jogsService.jogs) {
      result.add(TableRow(children: [jogCell(jog)]));
    }
    return result;
  }

  Future<void> refresh() async {
    return await engine.jogsService.refreshJogs(context: context);
  }

  String distance(JogModel jog) {
    if (jog.distance == null) {
      return "- km";
    }
    if (jog.distance < 1000) {
      return "${jog.distance.round()} m";
    }
    final distanceInKm = jog.distance / 1000;
    return "${distanceInKm.toStringAsFixed(1)} km";
  }

  String speedAverage(JogModel jog) {
    if (jog.distance == null) {
      return "- km/h";
    }
    final durationInSeconds = (jog.endDate.millisecondsSinceEpoch - jog.beginDate.millisecondsSinceEpoch) / 1000;
    final speed = (jog.distance * 3600 / durationInSeconds) / 1000;
    return "${speed.toStringAsFixed(1)} km/h";
  }

  String minutes(JogModel jog) {
    final dif = jog.endDate.millisecondsSinceEpoch - jog.beginDate.millisecondsSinceEpoch;
    int hundreds =(dif / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    return minutes.toString().padLeft(2, '0');
  }

  String seconds(JogModel jog) {
    final dif = jog.endDate.millisecondsSinceEpoch - jog.beginDate.millisecondsSinceEpoch;
    int hundreds =(dif / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int secondsToDisplay = seconds - minutes * 60;
    return secondsToDisplay.toString().padLeft(2, '0');
  }

  String time(JogModel jog) {
    return "${minutes(jog)}:${seconds(jog)}";
  }

  Widget emptyView() {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(Localizable.valuefor(
                                        key: "HISTORY.EMPYT.LABEL",
                                        context: context), style: Constants.theme.subtitle,
                                        textAlign: TextAlign.center,
                                        ),
                                        Container(
                                           alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
                                          width: 200,
                                          child: RoundButton(text: Localizable.valuefor(key: "HISTORY.REFRSH.BUTTON", context: context), 
                                                              onPressed: refresh,)
                                       ,)
          ]);
  }

  Widget listView() {
    
    return ListView.separated(
            itemCount: engine.jogsService.jogs.length,
            separatorBuilder: (BuildContext context, int index) => Divider(color: Constants.colors.border, height: 1,),
            itemBuilder: (context, index) {
              final jog = engine.jogsService.jogs[index];
              final date = Helper.shortDate(jog.beginDate);
              return 
              Dismissible(
                key: Key(index.toString()),
                onDismissed: (direction) {
                setState(() {
                  engine.jogsService.deleteJog(jog: jog);
                  engine.jogsService.jogs.remove(jog);
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("deleted")));
              },
              background: Container(color: Colors.red),
              child:
              Material(child:  ListTile(title: Row(children: [Text(date, textAlign: TextAlign.left,), Expanded(child:Text(distance(jog), textAlign: TextAlign.right))]), 
                                              subtitle: Row(children: [Text(time(jog)), Expanded(child:Text(speedAverage(jog), textAlign: TextAlign.right))]))));
            });
  }

  @override
  Widget build(BuildContext context) {
    StatusBar.color(CupertinoTheme.of(context).barBackgroundColor);
    return Container(
       child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: AutoSizeText( 
            Localizable.valuefor(key: "HISTORY.TITLE", context: context),
            style: Constants.theme.appTitle,
            maxLines: 1,
          ),
        ),
        child: SafeArea(
          child:
          isLoading ? 
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      
          CircularProgressIndicator(backgroundColor: Colors.yellow,)
            ])
                  : 
          engine.jogsService.jogs.isEmpty ? emptyView()
          :
          listView()
        )
       )
    );
  }

  @override
  void onJogsService({JogsService jogsService, ServiceState state, String error}) {
    if (error != null) {
      AlertWidget.presentDialog(messsage:error, context: context);
      return;
    }
    if (state == ServiceState.loaded) {
      setState(() {
        isLoading = false;
       });
      return;
    }
    if (state == ServiceState.loading) {
      setState(() {
        isLoading = true;
       });
    }
  }
}