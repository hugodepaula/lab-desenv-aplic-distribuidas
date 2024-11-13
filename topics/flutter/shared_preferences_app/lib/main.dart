import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Carregar o nome salvo
  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('user_name') ?? '';
      _nameController.text = _savedName;
    });
  }

  // Salvar o nome digitado
  Future<void> _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    setState(() {
      _savedName = _nameController.text;
    });
  }

  // Tela de login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, $_savedName',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Digite seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveName();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nome salvo com sucesso!')),
                );
              },
              child: Text('Salvar Nome'),
            ),
            SizedBox(height: 16),
            if (_savedName.isNotEmpty)
              Text(
                'Nome salvo: $_savedName',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}