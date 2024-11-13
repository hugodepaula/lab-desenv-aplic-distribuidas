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