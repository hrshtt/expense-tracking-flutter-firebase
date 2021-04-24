import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/ui/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/routes/routeNames.dart';

import 'login_view_model.dart';
import 'login_headers.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: LoginHeader(
        emailCont: _emailController,
        passwordCont: _passwordController,
      ),
      builder: (context, model, child) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                child,
                SizedBox(
                  height: 10,
                ),
                model.state == ViewState.Busy
                    ? CircularProgressIndicator()
                    : Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.amber[200],
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          onPressed: () async {
                            bool loginSuccess = await model.login(
                                email: _emailController.text,
                                password: _passwordController.text);
                            if (loginSuccess) {
                              Navigator.pushReplacementNamed(
                                  context, PageRoutes.lock);
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );

    // return BaseView<LoginViewModel>(
    //   model: LoginViewModel(authenticationService: Provider.of(context)),
    //   child: LoginHeader(
    //     emailCont: _emailController,
    //     passwordCont: _passwordController,
    //   ),
    //   builder: (context, model, child) =>
    // );
  }
}
