import 'package:flutter/material.dart';
// import 'package:tmtdiseases/homePage.dart';
import 'package:tmtdiseases/results.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: Homepage(),
      home: Results(),
    );
  }
}
