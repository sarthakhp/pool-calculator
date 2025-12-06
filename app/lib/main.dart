import 'package:flutter/material.dart';
import 'package:pool_calculator/screens/pool_table_screen.dart';

void main() {
  runApp(const PoolCalculatorApp());
}

class PoolCalculatorApp extends StatelessWidget {
  const PoolCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pool Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PoolTableScreen(),
    );
  }
}

