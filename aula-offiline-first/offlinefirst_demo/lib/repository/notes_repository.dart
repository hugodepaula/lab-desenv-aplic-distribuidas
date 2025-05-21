import 'dart:async';
import '../model/note.dart';
import '../service/api_service.dart';
import '../service/database_service.dart';

class NotesRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;
  
  // Timer para sincronização periódica
  Timer? _syncTimer;

  NotesRepository({
    required ApiService apiService,
    required DatabaseService databaseService,
  }) : 
    _apiService = apiService,
    _databaseService = databaseService {
    // Iniciar sincronização periódica
    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5), 
      (timer) => syncNotes()
    );
  }

  void dispose() {
    _syncTimer?.cancel();
  }

  // IMPLEMENTAÇÃO DO PADRÃO OFFLINE-FIRST:
  // Primeiro retorna dados locais e depois busca da API

  // Obter todas as notas (stream para emitir atualizações)
  Stream<List<Note>> getNotes() async* {
    // 1. Primeiro, buscar notas do banco de dados local
    final localNotes = await _databaseService.getNotes();
    yield localNotes;
    
    // 2. Em seguida, tentar buscar notas atualizadas da API
    try {
      final apiNotes = await _apiService.getNotes();
      
      // 3. Atualizar banco de dados local com dados da API
      for (var note in apiNotes) {
        await _databaseService.updateNote(note);
      }
      
      // 4. Buscar notas atualizadas do banco para garantir consistência
      final updatedNotes = await _databaseService.getNotes();
      yield updatedNotes;
    } catch (e) {
      // Se falhar ao buscar da API, já fornecemos os dados locais anteriormente
      print('Erro ao buscar notas da API: $e');
    }
  }

  // Obter uma nota específica
  Future<Note?> getNote(int id) async {
    // 1. Primeiro, buscar do banco de dados local
    final localNote = await _databaseService.getNote(id);
    
    // 2. Tentar buscar da API
    try {
      final apiNote = await _apiService.getNote(id);
      
      // 3. Atualizar banco de dados local
      await _databaseService.updateNote(apiNote);
      
      return apiNote;
    } catch (e) {
      // Se falhar, retornar a nota local
      print('Erro ao buscar nota da API: $e');
      return localNote;
    }
  }

  // Adicionar uma nova nota
  Future<Note> addNote(Note note) async {
    // 1. Primeiro, salvar no banco de dados local como não sincronizada
    final localNote = note.copyWith(synchronized: false);
    final id = await _databaseService.insertNote(localNote);
    final savedNote = localNote.copyWith(id: id);
    
    // 2. Tentar enviar para a API
    try {
      final apiNote = await _apiService.addNote(savedNote);
      
      // 3. Atualizar banco de dados local com nota sincronizada
      await _databaseService.updateNote(apiNote.copyWith(synchronized: true));
      
      return apiNote;
    } catch (e) {
      // Se falhar, pelo menos temos a nota salva localmente
      print('Erro ao adicionar nota na API: $e');
      return savedNote;
    }
  }

  // Atualizar uma nota existente
  Future<Note> updateNote(Note note) async {
    // 1. Primeiro, atualizar no banco de dados local como não sincronizada
    final localNote = note.copyWith(synchronized: false);
    await _databaseService.updateNote(localNote);
    
    // 2. Tentar atualizar na API
    try {
      final apiNote = await _apiService.updateNote(localNote);
      
      // 3. Atualizar banco de dados local com nota sincronizada
      await _databaseService.updateNote(apiNote.copyWith(synchronized: true));
      
      return apiNote;
    } catch (e) {
      // Se falhar, pelo menos temos a nota atualizada localmente
      print('Erro ao atualizar nota na API: $e');
      return localNote;
    }
  }

  // Excluir uma nota
  Future<void> deleteNote(int id) async {
    // 1. Primeiro, excluir do banco de dados local
    await _databaseService.deleteNote(id);
    
    // 2. Tentar excluir da API
    try {
      await _apiService.deleteNote(id);
    } catch (e) {
      // Se falhar, pelo menos excluímos do banco local
      print('Erro ao excluir nota da API: $e');
    }
  }

  // Sincronizar notas não sincronizadas
  Future<void> syncNotes() async {
    try {
      // Obter todas as notas não sincronizadas
      final unsyncedNotes = await _databaseService.getUnsynchronizedNotes();
      
      for (var note in unsyncedNotes) {
        try {
          if (note.id != null) {
            // Atualizar notas existentes
            final apiNote = await _apiService.updateNote(note);
            await _databaseService.updateNote(apiNote.copyWith(synchronized: true));
          } else {
            // Adicionar novas notas
            final apiNote = await _apiService.addNote(note);
            await _databaseService.updateNote(apiNote.copyWith(synchronized: true));
          }
        } catch (e) {
          print('Erro ao sincronizar nota ${note.id}: $e');
        }
      }
    } catch (e) {
      print('Erro durante a sincronização: $e');
    }
  }
}