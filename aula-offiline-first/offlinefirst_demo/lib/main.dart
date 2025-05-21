import 'package:flutter/material.dart';
import 'service/api_service.dart';
import 'service/database_service.dart';
import 'repository/notes_repository.dart';
import 'ui/notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar serviços
    final apiService = ApiService(baseUrl: 'https://api.exemplo.com');
    final databaseService = DatabaseService();
    
    // Criar repositório
    final notesRepository = NotesRepository(
      apiService: apiService,
      databaseService: databaseService,
    );

    return MaterialApp(
      title: 'Offline-First Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: NotesScreen(repository: notesRepository),
    );
  }
}