import 'package:flutter/material.dart';
import 'SegundaTela.dart';

void main() {
  runApp(MaterialApp(
    home: PrimeiraTela(),
  ));
}
class PrimeiraTela extends StatefulWidget {
  @override
  _PrimeiraTelaState createState() => _PrimeiraTelaState();
}

class _PrimeiraTelaState extends State<PrimeiraTela> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Primeira Tela"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Digite seu nome: "
              ),
              style: TextStyle(
                fontSize: 30,
              ),
              controller: _textEditingController,
            ),
            ElevatedButton(
                child: Text("Ir para a segunda tela"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SegundaTela(valor: _textEditingController.text)
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}