import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PaidScreen extends StatefulWidget {
  static const String routeName = '_paid_screen';
  const PaidScreen({super.key});

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaidScreen'),
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
