import 'package:expense_tracker/routes/routeNames.dart';
import 'package:expense_tracker/ui/base_view.dart';
import 'package:expense_tracker/ui/splashpage/splashpage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  static const String routeName = '/';
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
        model: SplashViewModel(authenticationService: Provider.of(context)),
        builder: (context, model, child) {
          Future.delayed(Duration(microseconds: 100)).then((_) {
            if (model.loggedin) {
              Navigator.pushReplacementNamed(context, PageRoutes.lock);
            } else {
              Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
            }
          });

          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}
