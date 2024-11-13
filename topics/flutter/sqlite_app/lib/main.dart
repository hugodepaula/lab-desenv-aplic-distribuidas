import 'package:flutter/material.dart';
import 'package:sqlite_app/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

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
