import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        synchronized INTEGER NOT NULL
      )
    ''');
  }

  // Obter todas as notas do banco de dados
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Obter uma nota específica pelo ID
  Future<Note?> getNote(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    return Note.fromMap(maps.first);
  }

  // Inserir uma nova nota no banco de dados
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Atualizar uma nota existente
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Excluir uma nota
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obter todas as notas não sincronizadas
  Future<List<Note>> getUnsynchronizedNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'synchronized = ?',
      whereArgs: [0],
    );
    
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}