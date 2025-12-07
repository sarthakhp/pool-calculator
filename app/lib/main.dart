import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pool_calculator/screens/pool_table_screen.dart';

void main() {
  if (kIsWeb) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
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

