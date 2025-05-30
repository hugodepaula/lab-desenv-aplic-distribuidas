import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Startup Names',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Projeto Startup Names'),
        ),
        body: Center(
          child: RandomWords(),
        ),
      ),
    );
  }
}


class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override                                  
  Widget build(BuildContext context) {
    final WordPair wordPair = WordPair.random();
    return Text(wordPair.asPascalCase);
  }
}