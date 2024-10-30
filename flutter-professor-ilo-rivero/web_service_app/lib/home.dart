import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String _resultado = "Resultado";
  TextEditingController _controllercep = TextEditingController();
  _recuperaCep() async{
    String cepDigitado = _controllercep.text;
    var uri = Uri.parse("https://viacep.com.br/ws/${cepDigitado}/json/");
    http.Response response;
    response = await http.get(uri);
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    setState(() { //configurar o _resultado
      _resultado = "${logradouro}, ${complemento}, ${bairro}, ${localidade} ";
    });
    /*print("Logradouro: ${logradouro} "
        " complemento: ${complemento}"
        " bairro: ${bairro}"
        " localidade: ${localidade}");*/
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Digite o cep ex: 30360190"
              ),
              style: TextStyle(
                fontSize: 20,
              ),
              controller: _controllercep,
            ),
            ElevatedButton(
                child: Text("Clique aqui"),
                onPressed: _recuperaCep
            ),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}
