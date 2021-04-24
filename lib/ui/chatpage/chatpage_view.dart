// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker/core/enums/viewstate.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/core/models/chatModel.dart';
import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:expense_tracker/services/claimsUpdateService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../base_view.dart';
import 'chatpage_view_model.dart';
import 'chat_bottom_tray.dart';
import 'chat_expense.dart';

class ChatPageView extends StatefulWidget {
  ChatPageView({Key key}) : super(key: key);
  static const String routeName = '/chatpage';

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    // List<Expense> expenseList = Provider.of<List<Expense>>(context);
    List<SafeLocalUser> usersList = Provider.of<List<SafeLocalUser>>(context);
    if (Provider.of<ClaimsUpdateService>(context).userClaims.value["pinAuth"]) {
      return BaseView<ChatPageViewModel>(
          model: ChatPageViewModel(claimsUpdateService: Provider.of(context)),
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(),
              body: (!model.isUserPinAuthorized)
                  ? Center(
                      child: Text(
                        "No Pin Authorization",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : (usersList == null)
                      ? Center(child: CircularProgressIndicator())
                      : Consumer<List<Expense>>(
                          builder: (context, expenseList, _) => Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    child: ListView.builder(
                                      itemCount: expenseList.length,
                                      controller: _controller,
                                      shrinkWrap: true,
                                      // reverse: true,
                                      // padding: EdgeInsets.only(top: 10, bottom: 10),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatContainer(
                                          chatBoxElement: ChatBoxElement(
                                            expense: expenseList[index],
                                            expenseFromAuthor:
                                                expenseList[index]
                                                        .addedByUser
                                                        .userID ==
                                                    usersList
                                                        .where((u) =>
                                                            u.isCurrentUser)
                                                        .single
                                                        .userID,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              ChatPageBottomTray(),
                            ],
                          ),
                        ),
            );
          });
    } else {
      return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, futureData) => AlertDialog(
          title: Text("Please Enter Pin Again"),
          actions: [
            TextButton(
              child: Text(
                "Enter Pin Again",
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageRoutes.splash, (_) => false);
              },
            ),
            TextButton(
              child: Text("Exit", style: TextStyle(color: Colors.red)),
              onPressed: () {
                SystemNavigator.pop(animated: true);
              },
            )
          ],
        ),
      );
    }
  }
}
