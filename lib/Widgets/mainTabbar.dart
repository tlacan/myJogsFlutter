import 'package:flutter/cupertino.dart';
import 'package:my_jogs/Models/UserModel.dart';
import 'package:my_jogs/Services/userService.dart';

import '../Services/engine.dart';
import '../Services/serviceState.dart';
import '../Widgets/login.dart';

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
        items: engine.userService.userModel == null ? notConnectedItems() : connectedItems()
        ,
      ),
      tabBuilder: (context, index) {
        return Center(
          child: LoginWidget(engine),
        );
      },
    );
  }

  void userDidLogin() {
    setState(() {});
  }

  void onUserService({UserService userService, ServiceState state, String error}) {
    
  }
}