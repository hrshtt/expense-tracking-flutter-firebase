import 'package:flutter/material.dart';
// import 'package:expense_tracker/ui/shared/text_styles.dart';
// import 'package:provider_arc/ui/shared/ui_helpers.dart';

class LoginHeader extends StatelessWidget {
  final TextEditingController emailCont;
  final TextEditingController passwordCont;
  // final String validationMessage;

  LoginHeader({
    @required this.emailCont,
    @required this.passwordCont,
    // this.validationMessage
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      LoginTextField(
        controller: emailCont,
        labelText: "Email",
        hintText: "Enter a Valid Email",
        obscureText: false,
      ),
      SizedBox(
        height: 10,
      ),
      LoginTextField(
        controller: passwordCont,
        labelText: "Password",
        hintText: "Enter a Secure Password",
        obscureText: true,
      ),
      SizedBox(
        height: 10,
      ),
      // this.validationMessage != null
      //     ? Text(validationMessage, style: TextStyle(color: Colors.red))
      //     : Container()
    ]);
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final String hintText;

  LoginTextField({
    this.controller,
    this.obscureText,
    this.labelText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent, width: 2.0),
        ),
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.amber[400]),
        hintStyle: TextStyle(color: Colors.white70),
      ),
    );
  }
}
