import 'dart:convert' show utf8;
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Famous Quotes',
      home: new RandomQuotes(),
    );
  }
}

class RandomQuotes extends StatefulWidget {
  @override
  createState() => new RandomQuotesState();
}

class RandomQuotesState extends State<RandomQuotes> {

  var _randomQuote = '-';

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('TAGLINES'),
        ),
        body: new Center(

        child : new Padding(
            padding: new EdgeInsets.all(20.0),
            child : new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(_randomQuote,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                spacer,
                spacer,
                new ElevatedButton(
                  onPressed: _getRandomQuote,
                  child: new Text('Buscar tagline'),
                ),
              ],
            ),
        ),
      ),
    );
  }

  _getRandomQuote() async {
    var url = 'https://us-central1-quotes-app-455da.cloudfunctions.net/getquotes-function';
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var data = await response.transform(utf8.decoder).join();
        result = data;
      } else {
        result =
        'Erro buscando citação:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Falha na invocação da função getquotes: ${exception.toString()}.';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _randomQuote = result;
    });
  }

}