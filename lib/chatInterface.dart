import 'package:flutter/material.dart';

class Chatinterface extends StatelessWidget {
  const Chatinterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Chat Interface')),
        backgroundColor: Colors.green,
      ),
    );
  }
}
