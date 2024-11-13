# Usando o `Shared Preferences` no Flutter

Vamos criar um exemplo de uma tela de login no Flutter onde o nome do usuário pode ser salvo utilizando o pacote `shared_preferences`. A ideia é que o nome digitado pelo usuário seja armazenado de forma persistente e carregado automaticamente quando o usuário voltar à tela de login.

## Passo 1: Criar o Projeto Flutter


## Passo 2: Adicionar a Dependência `shared_preferences`

1. No arquivo `pubspec.yaml`, adicione o pacote `shared_preferences`:

```dart
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.3.3
```

2. Execute o comando para instalar as dependências:

```dart
flutter pub get
```


## Passo 3: Criar Aplicação

1. No arquivo `lib/main.dart`, substitua o código pelo seguinte:

```dart
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
  TextEditingController _nameController = TextEditingController();
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
```