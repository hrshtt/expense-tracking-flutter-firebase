import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods {
  final AuthMethods _auth;

  DatabaseMethods({AuthMethods auth})
      : _auth = auth,
        pinAuth = ValueNotifier<Map<String, dynamic>>({
          "pinAuth": false,
          "counter": 0,
          "lastAuthChange": Timestamp.now(),
        });

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference get expenseCollection =>
      _firebaseFirestore.collection('expense');

  Query getDailyExpenses() {
    return _firebaseFirestore.collection('expense').where('creationDateTime',
        isGreaterThan:
            Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 23))));
  }

  Future<Map<String, dynamic>> refreshIdTokens() async {
    return await _auth.refreshTokenIds();
  }

  final ValueNotifier<Map<String, dynamic>> pinAuth;

  Stream<Map<String, dynamic>> userClaims() {
    if (_auth.user != null) {
      return _firebaseFirestore
          .collection('user-claims')
          .doc(_auth.user.uid)
          .snapshots()
          .handleError((err) => print("docs mai error: $err"))
          .map((docSnapshot) {
        return docSnapshot.data();
      });
    } else {
      return null;
    }
  }

  Stream<List<Expense>> get expenseStream {
    if (_auth.user != null) {
      return _firebaseFirestore
          .collection('expense')
          .where('creationDateTime',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(Duration(hours: 23))))
          .snapshots()
          .handleError((error) => print(error))
          .map((list) =>
              list.docs.map((doc) => Expense.fromMap(doc.data())).toList());
    } else {
      return null;
    }
  }

  Stream<List<SafeLocalUser>> get usersStream {
    if (_auth.user != null) {
      return _firebaseFirestore
          .collection('users')
          .snapshots()
          .asBroadcastStream()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return SafeLocalUser(
            displayName: doc.data()["displayName"],
            userID: doc.id,
            uniqueInitials: doc.data()["uniqueInitials"],
            isCurrentUser: doc.id == _auth.safeUserID,
          );
        }).toList();
      });
    } else {
      return null;
    }
  }
}
