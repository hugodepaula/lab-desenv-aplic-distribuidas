import 'package:flutter/material.dart';

class EntradaRadioButton extends StatefulWidget {
  @override
  _EntradaRadioButtonState createState() => _EntradaRadioButtonState();
}

class _EntradaRadioButtonState extends State<EntradaRadioButton> {
  String _selecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesquisa de Satisfação"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
            ),
            Text("Satisfeito com o produto? "),
            RadioListTile(
              title: Text("Sim"),
              value: "sim",
              groupValue: _selecionado,
              onChanged: (String escolha){
                setState(() {
                  _selecionado = escolha;
                });
              },
            ),
            RadioListTile(
              title: Text("Não"),
              value: "nao",
              groupValue: _selecionado,
              onChanged: (String escolha){
                setState(() {
                  _selecionado = escolha;
                });
              },
            ),
            ElevatedButton(
                child: Text("Salvar"),
                onPressed: (){
                  print("Item selecionado: " + _selecionado);
                }
                ),
            /*
            Text("Masculino"),
            Radio(
                value: "m",
                groupValue: _selecionado,
                onChanged: (String escolha){
                  print("Resultado: " + escolha);
                  setState(() {
                    _selecionado = escolha;
                  });
                }
            ),
            Text("Feminino"),
            Radio(
                value: "f",
                groupValue: _selecionado,
                onChanged: (String escolha){
                  print("Resultado: " + escolha);
                  setState(() {
                    _selecionado = escolha;
                  });
                }
            ),*/
          ],
        ),
      ),
    );
  }
}
