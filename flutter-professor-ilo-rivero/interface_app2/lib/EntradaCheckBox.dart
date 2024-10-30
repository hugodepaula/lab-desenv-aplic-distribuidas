import 'package:flutter/material.dart';

class EntradaCheckBox extends StatefulWidget {
  @override
  _EntradaCheckBoxState createState() => _EntradaCheckBoxState();
}

class _EntradaCheckBoxState extends State<EntradaCheckBox> {
  bool _leite = false;
  bool _pao = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            CheckboxListTile(
                title: Text("Leite"),
                secondary: Icon(Icons.add_box),
                value: _leite,
                onChanged: (bool valor){
                  setState(() {
                    _leite = valor;
                  });
                }
            ),
            CheckboxListTile(
                title: Text("Pão"),
                secondary: Icon(Icons.add_box),
                value: _pao,
                onChanged: (bool valor){
                  setState(() {
                    _pao = valor;
                  });
                }
            ),
            ElevatedButton(
                child: Text("Salvar"),
                onPressed: (){
                  print(
                      " Leite: " +_leite.toString() +
                          " Pão: " +_pao.toString()
                  );
                }
            ),
            /* Text("Leite"),
            Checkbox(
              value: _selecionado,
              onChanged: (bool valor){
                print("Valor do checkbox: "+valor.toString());
                setState(() {
                  _selecionado = valor;
                });
              },
            ), */
          ],
        ),
      ),
    );
  }
}
