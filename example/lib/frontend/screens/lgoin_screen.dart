import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LgoinScreen extends StatefulWidget {
  static const String routeName = '_lgoin_screen';
  const LgoinScreen({super.key});

  @override
  State<LgoinScreen> createState() => _LgoinScreenState();
}

class _LgoinScreenState extends State<LgoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LgoinScreen'),
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
