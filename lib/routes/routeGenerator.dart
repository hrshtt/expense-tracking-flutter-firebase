import 'package:flutter/material.dart';
import 'package:expense_tracker/routes/routeNames.dart';
import 'package:expense_tracker/ui/views.dart';

class RouteGenerator {
  static Route<MaterialPageRoute> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case PageRoutes.splash:
        return MaterialPageRoute(builder: (context) => SplashView());
      case PageRoutes.loginPage:
        return MaterialPageRoute(builder: (context) => LoginView());
      case PageRoutes.groupRooms:
        return MaterialPageRoute(builder: (context) => GroupRoomView());
      case PageRoutes.settings:
        return MaterialPageRoute(builder: (context) => SettingsPage());
      case PageRoutes.lock:
        return MaterialPageRoute(builder: (context) => LockView());
      case PageRoutes.chatPage:
        return MaterialPageRoute(builder: (context) => ChatPageView());
      case PageRoutes.addChat:
        final ExpenseFormStarted args = settings.arguments;
        // print("Main hu genroutes mai ${args.credited}");
        return MaterialPageRoute(
            builder: (context) => ExpenseFormView(
                  credited: args.credited,
                  supText: args.supText,
                ));
      default:
        return MaterialPageRoute(builder: (context) => ChatPageView());
    }
  }
}
