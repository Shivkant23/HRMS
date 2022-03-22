
import 'package:flutter/material.dart';
import 'package:hrm/ui/screens/home_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
            settings: const RouteSettings(name: HomeScreen.id));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
