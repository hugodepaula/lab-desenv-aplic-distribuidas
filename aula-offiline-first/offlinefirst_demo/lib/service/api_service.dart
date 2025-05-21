import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Buscar todas as notas do servidor
  Future<List<Note>> getNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao obter notas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Buscar uma nota específica
  Future<Note> getNote(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
      
      if (response.statusCode == 200) {
        return Note.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao obter nota: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Adicionar uma nova nota
  Future<Note> addNote(Note note) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      );
      
      if (response.statusCode == 201) {
        return Note.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao adicionar nota: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Atualizar uma nota existente
  Future<Note> updateNote(Note note) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/notes/${note.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao atualizar nota: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Excluir uma nota
  Future<void> deleteNote(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao excluir nota: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}