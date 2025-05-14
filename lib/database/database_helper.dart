import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "gastos.db");

    print("Ruta de la base de datos SQLite: $path"); // Para depuración

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE gastos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT,
            categoria TEXT,
            monto REAL,
            fecha TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertGasto(Map<String, dynamic> gasto) async {
    final db = await database;
    print("Guardando en SQLite: $gasto"); // Verifica los datos antes de insertar
    return await db.insert('gastos', gasto);
  }

  Future<List<Map<String, dynamic>>> getGastos() async {
    final db = await database;
    return await db.query('gastos', orderBy: 'fecha DESC'); // Ordenado por fecha más reciente
  }

  Future<int> updateGasto(Map<String, dynamic> gasto) async {
    final db = await database;
    return await db.update('gastos', gasto, where: 'id = ?', whereArgs: [gasto['id']]);
  }

  Future<int> deleteGasto(int id) async {
    final db = await database;
    return await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }
}
