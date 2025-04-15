import 'package:login_notes_project/utils/const_value.dart';
import 'package:login_notes_project/utils/shared_preferences_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/note_model.dart';

class DbController{
  late Database database;

  openDataBaseFile() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Users (id INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT, Email TEXT, Password TEXT)'
      );
      await db.execute(
          'CREATE TABLE Note (id INTEGER PRIMARY KEY AUTOINCREMENT,msg TEXT, idUser INTEGER, FOREIGN KEY(idUser) REFERENCES Users(id) ON DELETE CASCADE)'
      );
    },
    );
  }

  Future<bool> login({required String email, required String password}) async{
    await openDataBaseFile();
    List<Map> res = await database.rawQuery(
        'SELECT * FROM Users WHERE Email = "$email" AND Password = "$password"',
    );
    await database.close();
    if(res.length > 0){
      
      SharedPreferencesHelper().savePrefString(
          key: ConstValue.name,
          value: res[0]["Name"]
      );

      // SharedPreferencesHelper().savePrefString(
      //     key: ConstValue.email,
      //     value: res[0]["Email"]
      // );

      SharedPreferencesHelper().savePrefString(
          key: ConstValue.id,
          value: res[0]["id"].toString()
      );
      await database.close();
      return true;
    }else{
      return false;
    }
  }
  signUp({
    required String name,
    required String email,
    required String password
  }) async {
    await openDataBaseFile();
     await database.rawInsert(
        'INSERT INTO Users(Name, Email, Password) VALUES("$name", "$email", "$password")',
    );
    await database.close();
  }

  insertNote({required String msg}) async{
    await openDataBaseFile();
    int userId= await SharedPreferencesHelper().getPrefInt(key: ConstValue.id, defaultValue: -1,);
    await database.rawInsert(
      'INSERT INTO Note(msg, idUser) VALUES("$msg", "$userId")',
    );
    await database.close();
  }
  updateNote({required String msg, required int id}) async{
    await openDataBaseFile();
    await database.rawUpdate(
      'UPDATE Note SET msg = "$msg" WHERE id = "$id"',
    );
    await database.close();
  }
  deleteNote({required int id}) async{
    await openDataBaseFile();
    await database.rawDelete(
      'DELETE FROM Note WHERE id = "$id"',
    );
    await database.close();
  }
  Future<List<NoteModel>> getNotes() async {
    List<NoteModel> data = [];
    await openDataBaseFile();
    int userId = await SharedPreferencesHelper().getPrefInt(
      key: ConstValue.id, defaultValue: -1,);
    List<Map> res = await database.rawQuery(
      'SELECT * FROM Note WHERE idUser = "$userId"',
    );
    for(Map i in res){
      data.add(NoteModel(id: i["id"], msg: i["msg"], idUser: i["idUser"]));
    }
    await database.close();
    return data;

  }
}