// import 'package:expense_tracker/main.dart';
// import 'package:expense_tracker/core/enums/viewstate.dart';
// import 'package:expense_tracker/services/auth.dart';
// import 'package:expense_tracker/services/database.dart';
// import 'package:expense_tracker/ui/views/base_view.dart';
import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:expense_tracker/ui/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:stacked/stacked.dart';

import 'expense_form_view_model.dart';
import 'form_custom_fields.dart';

class ExpenseFormStarted {
  final bool credited;
  final String supText;

  ExpenseFormStarted({this.credited, this.supText});
}

class ExpenseFormView extends StatefulWidget {
  static const String routeName = '/chatpage/expenseform';
  const ExpenseFormView({
    Key key,
    @required this.credited,
    @required this.supText,
  }) : super(key: key);
  final bool credited;
  final String supText;

  @override
  _ExpenseFormViewState createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  // final FocusNode focusNode = FocusNode();
  String author;

  @override
  Widget build(BuildContext context) {
    String dropdownSuffixText = widget.credited ? "Recieved By" : "Paid By";
    List<SafeLocalUser> usersList = Provider.of(context);
    print("My fav bool ${usersList == null}");
    return BaseView<ExpenseFormViewModel>(
        model: ExpenseFormViewModel(
          authMethods: Provider.of(context),
          databaseMethods: Provider.of(context),
          credited: widget.credited,
          suptext: widget.supText,
        ),
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              appBar: AppBar(),
              body: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (widget.credited ? Colors.green : Colors.red)),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            DropdownButtonFormField<String>(
                              onSaved: (val) {
                                model.setExpenseData(
                                    "transcByUser",
                                    usersList
                                        .where((u) => u.userID == val)
                                        .single);
                              },
                              value: usersList
                                  .where((u) => u.isCurrentUser)
                                  .single
                                  .userID,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person_add_alt_1),
                              ),
                              items: usersList.map<DropdownMenuItem<String>>(
                                (SafeLocalUser val) {
                                  return DropdownMenuItem(
                                    child: Text((val.isCurrentUser
                                        ? "$dropdownSuffixText You"
                                        : "$dropdownSuffixText ${val.displayName}")),
                                    value: val.userID,
                                  );
                                },
                              ).toList(),
                              onChanged: (val) => {},
                            ),
                            TextFormField(
                              onSaved: (val) => model.setExpenseData(
                                  "amount", int.parse(val)),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: (widget.credited
                                      ? '\u{20B9} Amount Recieved'
                                      : '\u{20B9} Amount Paid'),
                                  icon: Icon(Icons.money_rounded),
                                  // suffix: ,
                                  suffixIcon: (widget.credited
                                      ? Icon(
                                          Icons.arrow_downward_rounded,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.arrow_upward_rounded,
                                          color: Colors.redAccent[400],
                                        )),
                                  focusColor: Colors.pinkAccent),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please Enter an Amount";
                                if (int.parse(value) <= 0)
                                  return "Please Enter Amount more than Zero";
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              autofocus: true,
                            ),
                            DropdownButtonFormField<String>(
                              onSaved: (val) =>
                                  model.setExpenseData("amountType", val),
                              value: model.amountTypeList[0],
                              focusColor: Colors.pinkAccent,
                              decoration: InputDecoration(
                                labelText: 'Payment Mode',
                                icon: Icon(Icons.payments_rounded),
                              ),
                              items: model.amountTypeList
                                  .map<DropdownMenuItem<String>>(
                                (String val) {
                                  return DropdownMenuItem(
                                    child: Text(val),
                                    value: val,
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                model.showRefrenceField =
                                    model.amountTypeRef.contains(val);
                                if (!model.showRefrenceField) {
                                  model.setExpenseData("paymentRefrence", null);
                                }
                              },
                            ),
                            Visibility(
                                child: TextFormField(
                                  onSaved: (val) => model.setExpenseData(
                                      "paymentRefrence", val),
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      labelText: 'Refrence No.',
                                      icon: Icon(MdiIcons.numeric),
                                      focusColor: Colors.pinkAccent),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Please Enter Refrence Number";
                                    // if (int.parse(value) <= 0)
                                    //   return "Please Enter Amount more than Zero";
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                replacement: SizedBox.shrink(),
                                visible: model.showRefrenceField),
                            TextFormField(
                              initialValue: widget.supText ?? "",
                              onSaved: (val) =>
                                  model.setExpenseData("supText", val),
                              // model.unsafeExpense.supText = val,
                              keyboardType: TextInputType.text,
                              // maxLines: 3,
                              decoration: InputDecoration(
                                  labelText: widget.credited
                                      ? "What/Who Recieved this Payment?"
                                      : "What/Who Paid this Payment?",
                                  icon: Icon(Icons.text_fields_rounded),
                                  focusColor: Colors.pinkAccent),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please Enter Details";
                                // if (int.parse(value) <= 0)
                                //   return "Please Enter Amount more than Zero";
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            MyDateField(
                              formattedDate: model.formattedDate,
                              selectDate: model.selectDate,
                              timeagoTime: model.timeagoTime,
                              // selectedDate: model.selectedDate,
                            ),
                            Divider(
                              indent: 40,
                              thickness: 1.4,
                              color: Colors.grey[600],
                            ),
                            MySwitchFormField(
                              decoration: InputDecoration(
                                  labelText: 'Pending Status',
                                  hintText: null,
                                  icon: Icon(Icons.pending_actions_outlined)),
                              initialValue: model.pendingStatus,
                              onSaved: (value) =>
                                  model.setExpenseData("pendingStatus", value),
                              constraints: BoxConstraints(maxHeight: 27),
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 40,
                                  child: RaisedButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily),
                                      ),
                                      color: Color(0xff8dbdff),
                                      textColor: Colors.white,
                                      onPressed: () {
                                        _formKey.currentState.reset();
                                        // ('Payment Canceled');
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  width: 140,
                                  height: 40,
                                  child: model.state == ViewState.Busy
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : RaisedButton(
                                          child: Text(
                                            model.paymentButtonText,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                                fontFamily:
                                                    GoogleFonts.montserrat()
                                                        .fontFamily),
                                          ),
                                          color: model.paymentButtonColor,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();

                                              await model
                                                  .writeExpense(usersList
                                                      .where((u) =>
                                                          u.isCurrentUser)
                                                      .single)
                                                  .then((bool success) {
                                                if (success) {
                                                  Navigator.pop(context);
                                                } else {}
                                              });
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
