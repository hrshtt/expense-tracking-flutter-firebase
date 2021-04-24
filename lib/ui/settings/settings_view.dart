// import 'package:expense_tracker/pages/groupRooms/groupRooms.dart';
// import 'package:expense_tracker/routes/routeNames.dart';
// import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base_view.dart';
import 'settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);
  static const String routeName = '/settings';

  // final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
        model: SettingsViewModel(authMethods: Provider.of(context)),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text("Settings"),
                centerTitle: true,
              ),
              // drawer: navigationDrawer(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        minWidth: 200,
                        height: 50,
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.amber[800],
                        onPressed: () async {
                          await model.logout();
                          Navigator.popUntil(
                              context, ModalRoute.withName(PageRoutes.splash));
                        },
                      )),
                  Text("Hisab Hamalo v0.5"),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ));
  }
}
