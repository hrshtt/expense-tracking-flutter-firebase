import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base_view.dart';
import 'grouproom_view_model.dart';

class GroupRoomView extends StatelessWidget {
  static const String routeName = '/grouprooms';
  @override
  Widget build(BuildContext context) {
    return BaseView<GroupRoomModel>(
        model: GroupRoomModel(
            claimsUpdateService: Provider.of(context),
            callableFunctions: Provider.of(context)),
        builder: (context, model, child) {
          // model.listToChanges();
          return GestureDetector(
            onTap: () {
              model.rebuildUI();
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () async {
                      await model.pinUnauth().then((_) {
                        Navigator.pop(context);
                      });
                      // print(success);
                    }),
                title: Text("Hisab Hamalo"),
                centerTitle: true,
                actions: [
                  FlatButton(
                      child: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, PageRoutes.settings);
                      }),
                ],
              ),
              // drawer: navigationDrawer(),
              body: model.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                          child: InkWell(
                            child: GroupRoomCard(
                              name: "Expense Group",
                              status: model.isUserPinAuthorized,
                            ),
                            onTap: () async {
                              if (model.isUserPinAuthorized) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  PageRoutes.chatPage,
                                );
                              } else {
                                return SimpleDialog(
                                  children: [Text("Enter a chat page")],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
            ),
          );
        });
  }
}

class GroupRoomCard extends StatelessWidget {
  const GroupRoomCard({
    Key key,
    this.name,
    this.status,
  }) : super(key: key);

  final String name;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: status ? Colors.grey[50] : Colors.grey[600],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 15, 4, 15),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.grey[600],
              ),
            ),
          ], // Children
        ),
      ),
    );
  }
}
