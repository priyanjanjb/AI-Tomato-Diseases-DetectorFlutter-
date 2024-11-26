import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:tmtdiseases/const.dart';
import 'package:tmtdiseases/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

late OpenAI openAI;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    openAI = OpenAI.instance.build(token: OPENAI_API_KEY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: Homepage(),
      home: Splashscreen(),
    );
  }
}
