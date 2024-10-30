import 'package:flutter/material.dart';

class SegundaTela extends StatefulWidget {
  @override
  _SegundaTelaState createState() => _SegundaTelaState();
}

class _SegundaTelaState extends State<SegundaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Tela"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Text("Você está na segunda tela"),
            ElevatedButton(
              child: Text("voltar para a primeira tela"),
              onPressed: (){
                Navigator.pushNamed(
                    context,
                    "/",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
