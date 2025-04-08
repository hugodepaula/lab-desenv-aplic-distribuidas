import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'phonebook.pbgrpc.dart';

void main() {
  runApp(PhonebookApp());
}

class PhonebookApp extends StatelessWidget {
  const PhonebookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Telefone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhonebookScreen(),
    );
  }
}

class PhonebookScreen extends StatefulWidget {
  const PhonebookScreen({super.key});

  @override
  PhonebookScreenState createState() => PhonebookScreenState();
}

class PhonebookScreenState extends State<PhonebookScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _responseText = '';
  bool _isLoading = false;

  Future<void> _lookupNumber() async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    try {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      final stub = PhonebookServiceClient(channel);
      final response = await stub.lookupNumber(
        LookupRequest()..name = _nameController.text,
        options: CallOptions(timeout: Duration(seconds: 5)),
      );

      setState(() {
        _responseText = response.found
            ? '${response.name}: ${response.phoneNumber}'
            : '${response.name} não encontrado';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Erro: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Telefone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Digite um nome para buscar',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _lookupNumber,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Buscar Número'),
            ),
            SizedBox(height: 20),
            Text(
              _responseText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
