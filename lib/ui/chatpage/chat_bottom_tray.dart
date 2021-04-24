import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:expense_tracker/ui/expenseform/expense_form_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPageBottomTray extends StatefulWidget {
  const ChatPageBottomTray({
    Key key,
  }) : super(key: key);

  @override
  _ChatPageBottomTrayState createState() => _ChatPageBottomTrayState();
}

class _ChatPageBottomTrayState extends State<ChatPageBottomTray> {
  final TextEditingController _supTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _supTextController,
                // textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  // border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.amberAccent, width: 2.0),
                  ),
                  // labelText: "Email",
                  hintText: "Enter Details",
                  // labelStyle: TextStyle(color: Colors.amber[400]),
                  // helperStyle: TextStyle(color: Colors.black, font),
                  hintStyle: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Container(
                      margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                      alignment: Alignment.bottomCenter,
                      child: FunkyOverlay(
                        supText: _supTextController.text,
                      )),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Color(0xff8dbdff),
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  // String getSupText() {
  //   return _supTextController.text;
  // }
}

class AddExpense extends StatelessWidget {
  final Expense _expense;

  AddExpense(this._expense);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add(_expense.toMap())
          .then((value) => print("Expense Added"))
          .catchError((error) => print("Failed to add Expense: $error"));
    }

    return FlatButton(
      onPressed: addUser,
      child: Text(
        "Add Expense",
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  const FunkyOverlay({Key key, this.supText}) : super(key: key);
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
  final String supText;
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.reset();

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\u{20B9} Paid \n(Debited)",
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.7,
                        color: Colors.redAccent[400]),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.arrow_circle_up_rounded,
                    color: Colors.redAccent[400],
                  )
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageRoutes.addChat,
                    arguments: ExpenseFormStarted(
                        credited: false, supText: widget.supText));
                // _controller.reset();
              },
              color: Colors.red[50],
              height: 52,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\u{20B9} Recieved \n(Credited)",
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.7,
                        color: Colors.greenAccent[400]),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.arrow_circle_down_rounded,
                    color: Colors.greenAccent[400],
                  )
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageRoutes.addChat,
                    arguments: ExpenseFormStarted(
                        credited: true, supText: widget.supText));
                // _controller.reset();

                // _controller.reset();
              },
              color: Colors.green[50],
              height: 52,
              // padding: EdgeInsets.only(bottom: 5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
