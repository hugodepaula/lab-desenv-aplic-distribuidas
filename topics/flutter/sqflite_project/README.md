# Usando o `sqflite` no Flutter

Vamos utilizar o sqflite para armazenar e consultar dados em um banco de dados SQLite local.

## Passo 1: Criar o Projeto Flutter


## Passo 2: Adicionar a Dependência `sqflite`

1. No arquivo `pubspec.yaml`, adicione o pacote `sqflite` e `path`:

```dart
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.2+3
  path: ^1.8.0
```

Ou execute: 
```
flutter pub add sqflite
```

2. Execute o comando para instalar as dependências:

```dart
flutter pub get
```


## Passo 3: Criar Aplicação

1. Criar uma classe de gerenciamento do banco de dados com o nome de `DatabaseHelper` em `lib`para configurar e gerenciar o banco de dados SQLite.

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Modelo de usuário
class User {
  final int? id;
  final String name;

  User({this.id, required this.name});

  // Converter de User para Map (para salvar no SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Converter de Map para User
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
    );
  }
}

// Classe que gerencia o banco de dados
class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'app_database.db';
  static const String _tableName = 'users';

  // Obtém o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');
    });
  }

  // Inserir usuário no banco de dados
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Recuperar todos os usuários
  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Atualizar usuário
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      _tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Remover usuário
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```


2. Agora vamos criar uma tela onde o usuário pode adicionar e visualizar os dados armazenados no SQLite. No arquivo `lib/main.dart`, substitua o código pelo seguinte:

```dart
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart'; // Importe o arquivo onde está o DatabaseHelper

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _controller = TextEditingController();

  // Lista de usuários
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Carregar usuários do banco de dados
  Future<void> _loadUsers() async {
    List<User> users = await _dbHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  // Adicionar usuário ao banco de dados
  Future<void> _addUser() async {
    if (_controller.text.isNotEmpty) {
      User user = User(name: _controller.text);
      await _dbHelper.insertUser(user);
      _controller.clear();
      _loadUsers();
    }
  }

  // Deletar usuário do banco de dados
  Future<void> _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários Salvos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para digitar o nome
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome do usuário',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Adicionar Usuário'),
            ),
            SizedBox(height: 16),
            // Lista de usuários
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_users[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteUser(_users[index].id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```