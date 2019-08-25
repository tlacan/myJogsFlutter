import 'package:flutter/cupertino.dart';

import 'package:my_jogs/Utils/localizable.dart';
import 'package:my_jogs/Widgets/newJog.dart';
import 'package:my_jogs/Widgets/settings.dart';
import '../manager/widgetRefreshManager.dart';
import '../Services/engine.dart';
import '../Services/serviceState.dart';
import '../Services/userService.dart';
import '../Widgets/login.dart';
import '../Widgets/signUp.dart';

class MainWidget extends StatefulWidget {
  final Engine engine;
  MainWidget(this.engine);

  @override
  _MainWidgetState createState() => _MainWidgetState(engine);
}

class _MainWidgetState extends State<MainWidget> implements UserServiceObserver, WidgetRefresherManagerObserver {
  final Engine engine;
  final CupertinoTabController _controller = CupertinoTabController();

  _MainWidgetState(this.engine) {
    engine.userService.addObserver(this);
    engine.widgetRefreshManager.addObserver(key: WidgetRefreshManager.tabBarKey, observer: this);
  }

  @override
	void dispose(){
		super.dispose();
    _controller.dispose();
    engine.userService.removeObserver(this);
    engine.widgetRefreshManager.removeObserver(key: WidgetRefreshManager.tabBarKey, observer: this);
	}

  List<BottomNavigationBarItem> connectedItems() {
    return [BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections), title: Text(Localizable.valuefor(key: "TABBAR.ITEM.1", context: context))),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled), title: Text(Localizable.valuefor(key: "TABBAR.ITEM.2", context: context))),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear), title: Text(Localizable.valuefor(key: "TABBAR.ITEM.3", context: context)))];
  }

  List<BottomNavigationBarItem> notConnectedItems() {
    return [BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person), title: Text(Localizable.valuefor(key: "TABBAR.NOTCONNECTED.ITEM.1", context: context))),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_add), title: Text(Localizable.valuefor(key: "TABBAR.NOTCONNECTED.ITEM.2", context: context)))];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _controller,
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.black,
        inactiveColor: CupertinoColors.inactiveGray,
        items: engine.userService.connected() ? connectedItems() : notConnectedItems(),
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return engine.userService.connected() ? Center(child: Text("Tab 1")) : Center(child: LoginWidget(engine),);
            break;
          case 1:
            return engine.userService.connected() ? NewJogWidget(engine: engine) : Center(child: SignUpWidget(engine),);
            break;
          case 2:
            return engine.userService.connected() ? SettingsWidget(engine: engine) : Center(child: SignUpWidget(engine),);
          default:
           return Center(child: Text("Tab x"));
        }
      },
    );
  }

  void userDidLogin() {
    setState(() {});
  }

  void userDidLogout() {
    setState(() {
      _controller.index = 0;
    });
  }

  void onUserService({UserService userService, ServiceState state, String error}) {
    
  }

  @override
  void doRefresh(Object value) {
    _controller.index = value;
  }
}