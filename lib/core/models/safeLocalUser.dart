import 'package:flutter/cupertino.dart';

class SafeLocalUser {
  final String userID;
  final String uniqueInitials;
  final String displayName;
  bool isCurrentUser;

  SafeLocalUser(
      {@required this.displayName,
      @required this.userID,
      this.isCurrentUser,
      @required this.uniqueInitials});

  SafeLocalUser.fromMap(Map map)
      : displayName = map['displayName'],
        userID = map['userID'],
        uniqueInitials = map['uniqueInitials'];

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "displayName": displayName,
      "uniqueInitials": uniqueInitials,
    };
  }
}
