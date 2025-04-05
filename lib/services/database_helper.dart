import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quiz.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quizzes.db');
    return await openDatabase(
      path,
      version: 2, // Increment when making schema changes
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE quizzes ADD COLUMN passed INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE quizzes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quizName TEXT NOT NULL,
            score INTEGER NOT NULL,
            overallScore INTEGER NOT NULL,
            passed INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    int result = await db.insert('quizzes', quiz.toMap());
    return result;
  }

  Future<List<Quiz>> getQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('quizzes');
    return maps.map((quiz) => Quiz.fromMap(quiz)).toList();
  }

  Future<int> updateQuiz(Quiz quiz) async {
    final db = await database;
    return await db.update(
      'quizzes',
      quiz.toMap(),
      where: 'id = ?',
      whereArgs: [quiz.id],
    );
  }

  Future<int> deleteQuiz(int id) async {
    final db = await database;
    return await db.delete('quizzes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
