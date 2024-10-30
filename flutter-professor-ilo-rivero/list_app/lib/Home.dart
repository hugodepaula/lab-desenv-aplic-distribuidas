import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _itens = [];

  void _carregarItens(){
    _itens = [];
    for(int i=0; i<=10; i++){
      Map<String, dynamic> item = Map();
      item["titulo"] = "Titulo ${i} da lista";
      item["descricao"]="Descrição ${i} da lista";
      _itens.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    _carregarItens();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: _itens.length,
            itemBuilder: (context, indice) {
              //print("item ${indice}");
              //Map<String, dynamic> item =_itens[indice];
              //print("item ${_itens[indice]["titulo"]}");
              return ListTile(
                onTap: (){
                  //print("Clique com onTap ${indice}");
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text(_itens[indice]["titulo"]),
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            backgroundColor: Colors.yellow,
                          ),
                          content: Text(_itens[indice]["descricao"]),
                          actions: <Widget>[ //definir widgets
                            TextButton(
                                onPressed: (){
                                  print("Selecionado sim");
                                  Navigator.pop(context);
                                },
                                child: Text("Sim")
                            ),
                            TextButton(
                                onPressed: (){
                                  print("Selecionado não");
                                  Navigator.pop(context);
                                },
                                child: Text("Não")
                            ),
                          ],
                        );
                      }
                  );
                },
                onLongPress: (){
                  //print("Clique com onLongPress ${indice}");
                },
                title: Text(_itens[indice]["titulo"]),
                subtitle: Text(_itens[indice]["descricao"]),
              );
            }
        ),
      ),
    );
  }
}
