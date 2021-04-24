import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:flutter/cupertino.dart';

class Expense {
  final Timestamp creationDateTime;
  final Timestamp transactionDateTime;
  final SafeLocalUser addedByUser;
  final SafeLocalUser transcByUser;
  final String expenseID;
  final String supText;
  final int amount;
  final String amountType;
  final String paymentRefrence;
  final bool credited;
  final bool pendingStatus;

  const Expense({
    @required this.creationDateTime,
    @required this.transactionDateTime,
    @required this.expenseID,
    @required this.addedByUser,
    @required this.transcByUser,
    @required this.supText,
    @required this.amount,
    @required this.amountType,
    @required this.paymentRefrence,
    @required this.credited,
    @required this.pendingStatus,
  });

  Expense.fromMap(Map map)
      : creationDateTime = map['creationDateTime'],
        transactionDateTime = map['transactionDateTime'],
        expenseID = map['expenseID'],
        addedByUser = (map['addedByUser'] is SafeLocalUser
            ? map['addedByUser']
            : SafeLocalUser.fromMap(map['addedByUser'])),
        transcByUser = (map['transcByUser'] is SafeLocalUser
            ? map['transcByUser']
            : SafeLocalUser.fromMap(map['transcByUser'])),
        supText = map['supText'],
        amount = map['amount'],
        amountType = map['amountType'],
        paymentRefrence = map['paymentRefrence'],
        credited = map['credited'],
        pendingStatus = map['pendingStatus'];

  Map<String, dynamic> toMap() {
    return {
      "creationDateTime": creationDateTime,
      "transactionDateTime": transactionDateTime,
      "expenseID": expenseID,
      "addedByUser": addedByUser.toMap(),
      "transcByUser": transcByUser.toMap(),
      "supText": supText,
      "amount": amount,
      "amountType": amountType,
      "paymentRefrence": paymentRefrence,
      "credited": credited,
      "pendingStatus": pendingStatus,
    };
  }
}

class UnsafeExpense {
  Timestamp creationDateTime;
  Timestamp transactionDateTime;
  SafeLocalUser addedByUser;
  SafeLocalUser transcByUser;
  String expenseID;
  String supText;
  int amount;
  String amountType;
  String paymentRefrence;
  bool credited;
  bool pendingStatus;

  UnsafeExpense({
    this.creationDateTime,
    this.transactionDateTime,
    this.expenseID,
    this.addedByUser,
    this.transcByUser,
    this.supText,
    this.amount,
    this.amountType,
    this.paymentRefrence,
    this.credited,
    this.pendingStatus,
  });

  UnsafeExpense.fromMap(Map map)
      : creationDateTime = map['creationDateTime'],
        transactionDateTime = map['transactionDateTime'],
        expenseID = map['expenseID'],
        addedByUser = map['addedByUser'],
        transcByUser = map['transcByUser'],
        supText = map['supText'],
        amount = map['amount'],
        amountType = map['amountType'],
        paymentRefrence = map['paymentRefrence'],
        credited = map['credited'],
        pendingStatus = map['pendingStatus'];

  Map<String, dynamic> toMap() {
    return {
      "creationDateTime": creationDateTime,
      "transactionDateTime": transactionDateTime,
      "expenseID": expenseID,
      "addedByUser": addedByUser,
      "transcByUser": transcByUser,
      "supText": supText,
      "amount": amount,
      "amountType": amountType,
      "paymentRefrence": paymentRefrence,
      "credited": credited,
      "pendingStatus": pendingStatus,
    };
  }
}
