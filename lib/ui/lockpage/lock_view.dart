import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:expense_tracker/ui/shared/text_styles.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../base_view.dart';
import 'lock_view_model.dart';

class LockView extends StatefulWidget {
  LockView({Key key}) : super(key: key);
  static const String routeName = '/lock';

  @override
  _LockViewState createState() => _LockViewState();
}

class _LockViewState extends State<LockView> {
  final _myController = TextEditingController(text: "");

  // @override
  // void dispose() {
  //   print("my custom dispose");
  //   super.dispose();
  // }

  Widget digitFlatButton({String digit}) {
    return Expanded(
      child: FlatButton(
        child: Text(
          digit,
          style: keypadTextStyle,
        ),
        onPressed: () {
          if (_myController.text.length < 4) {
            _myController.text = _myController.text + digit;
          }
        },
        padding: keypadPadding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Builder(
      builder: (context) => BaseView<LockViewModel>(
          model: LockViewModel(
              claimsUpdateService: Provider.of(context),
              // userClaims: Provider.of(context),
              callableFunctions: Provider.of(context),
              maxWidth: maxWidth),
          builder: (context, model, child) {
            // model.userListener();
            return Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Visibility(
                      child: Center(
                        child: Container(
                          child: Text(
                            "Max Trials Exceeded!\nTry Again Later",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      visible: false,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        width: model.progressBarWidth,
                        height: 4,
                        decoration: BoxDecoration(
                          color: model.progressBarColor,
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitFlatButton(digit: "1"),
                      digitFlatButton(digit: "2"),
                      digitFlatButton(digit: "3"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitFlatButton(digit: "4"),
                      digitFlatButton(digit: "5"),
                      digitFlatButton(digit: "6"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitFlatButton(digit: "7"),
                      digitFlatButton(digit: "8"),
                      digitFlatButton(digit: "9"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: Icon(
                            Icons.cancel,
                            size: keypadElemSize,
                          ),
                          onPressed: () => {_myController.clear()},
                          padding: keypadPadding,
                        ),
                      ),
                      digitFlatButton(digit: "0"),
                      Expanded(
                        child: model.state == ViewState.Busy
                            ? Center(child: CircularProgressIndicator())
                            : FlatButton(
                                child: Icon(
                                  Icons.check,
                                  size: keypadElemSize,
                                ),
                                onPressed: () async {
                                  bool authStatus = await model
                                      .pinAuth(pin: _myController.text)
                                      .catchError(print);

                                  if (authStatus) {
                                    Future.delayed(Duration(milliseconds: 750))
                                        .then((_) {
                                      Navigator.pushNamed(
                                          context, PageRoutes.groupRooms);
                                    });
                                  }
                                  model.printValue();
                                  model.updateProgressBar(authStatus);

                                  _myController.clear();
                                },
                                padding: keypadPadding,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
