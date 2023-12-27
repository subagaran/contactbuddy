import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static Future<Database> _openDatabase() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,'my_database.db');
    return openDatabase(path,version: 1,onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db,int version)async{
    await db.execute('''CREATE TABLE IF NOT EXISTS Contact(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        Name TEXT,
                        TelephoneNo TEXT,
                        Email TEXT)
                        ''');
  }

  static Future<int> insertContact(String name, String telephoneNo, String email)async{
    final db = await _openDatabase();
    final data ={
      'Name':name,
      'Telephoneno':telephoneNo,
      'Email':email,
    };
    return await db.insert('Contact', data);
  }

  static Future<List<Map<String,dynamic>>> getContact() async{
    final db = await _openDatabase();
    return  await db.query('Contact');
  }
  static Future<int> deleteContact(int id) async{
    final db = await _openDatabase();
    return await db.delete('Contact',where: 'id=?',whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> getFirstOrderDefault(int id) async{
    final db = await _openDatabase();
    List<Map<String,dynamic>> result = await db.query(
      'Contact',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty?result.first:null;
  }

  static Future<int> updateContact(int id, Map<String,dynamic> data)async{
    final db = await _openDatabase();
    return await db.update('Contact', data,where:'id = ?',whereArgs: [id]);
  }

  static Future<List<Map<String,dynamic>>>searchContacts(String keyword) async {
    final db = await _openDatabase();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from Contact where Name LIKE ?", ["%$keyword%"]);
    return searchResult;
  }
}