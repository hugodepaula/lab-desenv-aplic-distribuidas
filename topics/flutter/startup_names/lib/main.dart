import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return MaterialApp(
        title: 'Startup names',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Startup names'),
          ),
          body: Center(
            child: Text(wordPair.asPascalCase),
          ),
        ));
  }
}
