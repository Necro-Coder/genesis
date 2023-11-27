import 'package:flutter/material.dart';
import '../screens/screens.dart';

class RoutesList {
  static String initialRoute = '';

  static final menuOptions = <MenuOption>[
  // menuOption instance 
MenuOption(
  name: LgoinScreen.routeName,
  screen: const LgoinScreen(),
  route: LgoinScreen.routeName),
       
MenuOption(
  name: PaidScreen.routeName,
  screen: const PaidScreen(),
  route: PaidScreen.routeName),
       
MenuOption(
  name: HomeScreen.routeName,
  screen: const HomeScreen(),
  route: HomeScreen.routeName),
       
MenuOption(
  name: ConfigScreen.routeName,
  screen: const ConfigScreen(),
  route: ConfigScreen.routeName),
      
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final e in menuOptions) {
      appRoutes.addAll({e.route: (BuildContext context) => e.screen});
    }

    return appRoutes;
  }

  static Route<dynamic>? onGeneratedRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => menuOptions[0].screen);
  }
}

class MenuOption {
  final String route;
  final String name;
  final Widget screen;

  MenuOption(
      {required this.route,
        required this.name,
        required this.screen});
}
    