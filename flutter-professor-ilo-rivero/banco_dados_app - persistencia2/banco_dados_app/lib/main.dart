import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(
    MaterialApp(
      home: Home(),
    )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco3.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
          db.execute(sql);
        }
    );
    return bd;
    //print("aberto: " + bd.isOpen.toString() );
  }

  _salvarDados(String nome, int idade) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : nome,
      "idade" : idade
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id " );
  }

  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE idade=58";
    //String sql = "SELECT * FROM usuarios WHERE idade >=30 AND idade <=58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 58";
    //String sql = "SELECT * FROM usuarios WHERE nome='Maria Silva'";
    List usuarios = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " nome: "+usu['nome']+
          " idade: "+usu['idade'].toString());
    }
  }

  _listarUmUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "idade"],
        where: "id = ?",
        whereArgs: [id]
    );
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " nome: "+usu['nome']+
          " idade: "+usu['idade'].toString());
    }
  }

  /*_excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens excluidos: "+retorno.toString());
  }*/

  _excluirUsuario() async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "nome = ? AND idade = ?",  //caracter curinga
        whereArgs: ["Raquel Ribeiro", 26]
    );
    print("Itens excluidos: "+retorno.toString());
  }

  _atualizarUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : "Antonio Pedro",
      "idade" : 35,
    };
    int retorno = await bd.update(
        "usuarios", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllernome = TextEditingController();
    TextEditingController _controlleridade = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Banco de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o nome: ",
              ),
              controller: _controllernome,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a idade: ",
              ),
              controller: _controlleridade,
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Salvar um usuário"),
                    onPressed: (){
                      _salvarDados(_controllernome.text, int.parse(_controlleridade.text));
                    }
                ),
                ElevatedButton(
                    child: Text("Listar todos usuários"),
                    onPressed: (){
                      _listarUsuarios();
                    }
                ),
                ElevatedButton(
                    child: Text("Listar um usuário"),
                    onPressed: (){
                      _listarUmUsuario(2);
                    }
                ),
                ElevatedButton(
                    child: Text("Atualizar um usuário"),
                    onPressed: (){
                      _atualizarUsuario(2);
                    }
                ),
                ElevatedButton(
                    child: Text("Excluir usuário"),
                    onPressed: (){
                      _excluirUsuario();
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


