import 'package:flutter/material.dart';

class SegundaTela extends StatefulWidget {
  String valor;
  SegundaTela({this.valor});
  @override
  _SegundaTelaState createState() => _SegundaTelaState();
}

class _SegundaTelaState extends State<SegundaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Tela"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Você está na segunda tela",
              style: TextStyle(
                backgroundColor: Colors.green,
              ),),
            Text("\nNome: " + widget.valor,
              style: TextStyle(
                color: Colors.orange,
              ),),
          ],
        ),
      ),
    );
  }
}