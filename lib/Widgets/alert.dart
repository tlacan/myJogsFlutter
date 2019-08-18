import 'package:flutter/cupertino.dart';

import '../Utils/localizable.dart';

class AlertWidget {

  static void presentDialog({String messsage, BuildContext context, String title, VoidCallback completion}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(messsage),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    if (completion != null) {
                      completion();
                    }
                    Navigator.pop(context, 'Cancel');
                  }, 
                  child: Text(Localizable.valuefor(key: "COMMON.OK", context: context)))
            ],
          );
      },
    );
  }

}
