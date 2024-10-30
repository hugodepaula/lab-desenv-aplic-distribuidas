import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbRef = FirebaseDatabase.instance.reference().child("animais");
  List<Map<dynamic, dynamic>> lista = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot)  {
              if (snapshot.hasData) {
                lista.clear();
                Map<dynamic, dynamic> values = snapshot.data as Map;
                values.forEach((key, values) {
                  lista.add(values);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lista.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Nome: " + lista[index]["nome"]),
                                Text("Idade: " + lista[index]["idade"]),
                                Text("Tipo: " + lista[index]["tipo"]),
                              ],
                            ),
                          ],  ), );
                    });
              }
              return CircularProgressIndicator();
            }
            )
    );
  }
}
