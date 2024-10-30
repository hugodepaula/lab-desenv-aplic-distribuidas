
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animais',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Principal(title: 'Registrar Animal'),
    );
  }
}

class Principal extends StatefulWidget {
  Principal({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Registrar o animal",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic)),
                  RegistrarAnimal(),
                ]),
          )),
    );
  }
}
class RegistrarAnimal extends StatefulWidget {
  RegistrarAnimal({Key? key}) : super(key: key);

  @override
  _RegistrarAnimalState createState() => _RegistrarAnimalState();
}

class _RegistrarAnimalState extends State<RegistrarAnimal> {
  final _formKey = GlobalKey<FormState>();
  final listadePets = ["Gatos", "Cachorros", "Pássaros"];
  String? valorPadraoMenu = 'Cachorros';
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("animais");

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    labelText: "Digite o nome do animal",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite o nome:';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: DropdownButtonFormField(
                  value: valorPadraoMenu,
                  icon: Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    labelText: "Selecione o tipo",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: listadePets.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      valorPadraoMenu = newValue;
                    });
                  },
                  validator: (dynamic value) {
                    if (value.isEmpty) {
                      return 'Favor selecionar o tipo';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: idadeController,
                  decoration: InputDecoration(
                    labelText: "Digite a idade",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Favor digitar a idade';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            dbRef.push().set({
                              "nome": nomeController.text,
                              "idade": idadeController.text,
                              "tipo": valorPadraoMenu
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Adicionado')));
                              idadeController.clear();
                              nomeController.clear();
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(onError)));
                            });
                          }
                        },
                        child: Text('Enviar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(title: "Principal")),
                          );
                        },
                        child: Text('Verificar'),
                      ),
                    ],
                  )),
            ])));
  }

  @override
  void dispose() {
    super.dispose();
    idadeController.dispose();
    nomeController.dispose();
  }
}