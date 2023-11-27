import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ConfigScreen extends StatefulWidget {
  static const String routeName = '_config_screen';
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConfigScreen'),
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
