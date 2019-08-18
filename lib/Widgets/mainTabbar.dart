import 'package:flutter/cupertino.dart';
import 'package:my_jogs/Models/UserModel.dart';
import 'package:my_jogs/Services/userService.dart';

import '../Services/engine.dart';
import '../Services/serviceState.dart';
import '../Widgets/login.dart';
import '../Widgets/signUp.dart';

class MainWidget extends StatefulWidget {
  final Engine engine;
  MainWidget(this.engine);

  @override
  _MainWidgetState createState() => _MainWidgetState(engine);
}

class _MainWidgetState extends State<MainWidget> implements UserServiceObserver {
  final Engine engine;
  _MainWidgetState(this.engine) {
    engine.userService.addObserver(this);
  }

  @override
	void dispose(){
		super.dispose();
    engine.userService.removeObserver(this);
	}

  List<BottomNavigationBarItem> connectedItems() {
    return [BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle), title: Text("Jambon")),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock), title: Text("Fromage"))];
  }

  List<BottomNavigationBarItem> notConnectedItems() {
    return [BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle), title: Text("Login")),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock), title: Text("Signup"))];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: engine.userService.connected() ? connectedItems() : notConnectedItems()
        ,
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return engine.userService.connected() ? Center(child: Text("Tab 1")) : Center(child: LoginWidget(engine),);
            break;
          case 1:
            return engine.userService.connected() ? Center(child: Text("Tab 2")) : Center(child: SignUpWidget(engine),);
            break;
          default:
           return Center(child: Text("Tab x"));
        }
      },
    );
  }

  void userDidLogin() {
    setState(() {});
  }

  void onUserService({UserService userService, ServiceState state, String error}) {
    
  }
}