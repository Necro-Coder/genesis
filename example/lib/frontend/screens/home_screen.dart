import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '_home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: ScreenTypeLayout.builder(
        mobile: (context) => Container(color:Colors.blue),
        tablet: (context) => Container(color: Colors.yellow),
        desktop: (context) => Container(color: Colors.red),
        watch: (context) => Container(color: Colors.purple),
      ),
    );
  }
}
