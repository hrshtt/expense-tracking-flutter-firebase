import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:expense_tracker/ui/base_model.dart';
import 'package:expense_tracker/ui/shared/date_styles.dart' as _timeFormats;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class ExpenseFormViewModel extends BaseModel {
  DatabaseMethods _databaseMethods;
  UnsafeExpense _unsafeExpense;

  ExpenseFormViewModel({
    @required AuthMethods authMethods,
    @required DatabaseMethods databaseMethods,
    @required String suptext,
    @required bool credited,
  }) {
    _databaseMethods = databaseMethods;
    _unsafeExpense = UnsafeExpense(
        pendingStatus: false,
        credited: credited,
        supText: suptext,
        creationDateTime: Timestamp.now(),
        transactionDateTime: Timestamp.now());
  }

  Color defaultColor = Color(0xff8dbdff);
  Color _paymentButtonColor = Color(0xff8dbdff);
  Color get paymentButtonColor => _paymentButtonColor;

  String paymentButtonDefaultText = "Add Payment";
  String _paymentButtonText = "Add Payment";
  String get paymentButtonText => _paymentButtonText;

  bool get pendingStatus => _unsafeExpense.pendingStatus;
  bool showRefrenceField = true;

  List<String> get amountTypeList =>
      ["Invoice", "Reciept", "Order-Book", "Other"];

  List<String> get amountTypeRef => ["Invoice", "Reciept", "Order-Book"];

  String get timeagoTime => isToday
      ? "today"
      : _timeFormats.timeAgoTime(_unsafeExpense.transactionDateTime.toDate());

  bool get isToday =>
      _timeFormats
          .calculateDifference(_unsafeExpense.transactionDateTime.toDate()) ==
      0;

  String get formattedDate =>
      _timeFormats.formattedDate(_unsafeExpense.transactionDateTime.toDate());

  Future<DateTime> selectDate(BuildContext context) async {
    var val = await showDatePicker(
      context: context,
      initialDate: _unsafeExpense.transactionDateTime.toDate(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2020),
      lastDate: DateTime(2022),
      helpText: 'Select Payment Date',
      cancelText: 'Cancel',
      confirmText: 'Done',
    );

    _unsafeExpense.transactionDateTime = Timestamp.fromDate(val);

    notifyListeners();
    return val;
  }

  void setExpenseData(String key, dynamic value) {
    switch (key) {
      case "transcByUser":
        _unsafeExpense.transcByUser = (value is SafeLocalUser) ? value : null;
        break;
      case "supText":
        _unsafeExpense.supText = (value is String) ? value : null;
        break;
      case "amount":
        _unsafeExpense.amount = (value is int) ? value : null;
        break;
      case "amountType":
        _unsafeExpense.amountType = (value is String) ? value : null;
        break;
      case "paymentRefrence":
        _unsafeExpense.paymentRefrence = (value is String) ? value : null;
        break;
      case "pendingStatus":
        _unsafeExpense.pendingStatus = (value is bool) ? value : null;
        break;
    }
    notifyListeners();
  }

  List<SafeLocalUser> _usersList;

  List<SafeLocalUser> get usersList => _usersList ?? List();

  Future<bool> writeExpense(SafeLocalUser _localCurrUser) async {
    setState(ViewState.Busy);
    bool success;

    _unsafeExpense.addedByUser = SafeLocalUser.fromMap(_localCurrUser.toMap());
    _unsafeExpense.expenseID = Uuid().v5(
        _timeFormats.formattedDate(_unsafeExpense.creationDateTime.toDate()),
        _unsafeExpense.addedByUser.userID);

    Expense _expense = Expense.fromMap(_unsafeExpense.toMap());

    await _databaseMethods.expenseCollection.add(_expense.toMap()).then((_) {
      print("Expense Added");
      success = true;
    }).catchError((error) {
      print("Failed to add Expense: $error");
      success = false;
      _paymentButtonColor = Colors.red;
      _paymentButtonText = "ERROR!!";
      Future.delayed(Duration(seconds: 5)).then((_) {
        _paymentButtonColor = defaultColor;
        _paymentButtonText = "Try Again?";
        notifyListeners();
      });
    });
    setState(ViewState.Idle);

    return success;
  }
}
