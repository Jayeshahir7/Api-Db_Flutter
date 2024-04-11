import "dart:convert";
import "package:http/http.dart" as http;
import "package:sqflite/sqflite.dart";
class MyDataBase{

  Future<Database> onInit() async {
    Database db=await openDatabase("mytable.db",onCreate: (db, version) {
      db.execute("create table demo(id integer,name text)");
    },version: 1);
    return db;
  }

  Future<List> GetAll() async {
    Database db=await onInit();
    List DatabaseList=await db.query("demo");
    var res =await http.get(Uri.parse("https://660d52b86ddfa2943b3418c7.mockapi.io/faculty"));
    List<dynamic> ApiData=await jsonDecode(res.body);
    print(" ${DatabaseList.length} ${ApiData.length}");
    if(DatabaseList.length==ApiData.length){

      return DatabaseList;
    }else{

      await db.delete("demo");
      for(var i=0;i<ApiData.length;i++){
        db.insert("demo", {"id":ApiData[i]["id"],"name":ApiData[i]["name"],});
      }
    }
    return DatabaseList;
  }

  Future<void> Delete(id) async {
    Database db=await onInit();
    await db.delete("demo",where: "id = ?",whereArgs: [id]).then((value) async {
      await http.delete(Uri.parse("https://660d52b86ddfa2943b3418c7.mockapi.io/faculty/$id"));
    });
  }

  Future<void> Update(map,id) async {
    Database db=await onInit();
    await db.update("demo",map,where: "id = ?",whereArgs: [id]).then((value) {
      http.put(Uri.parse("https://660d52b86ddfa2943b3418c7.mockapi.io/faculty/$id"),body: map);
    },);
  }

  Future<void> Post(map) async {
    Database db=await onInit();
    await http.post(Uri.parse("https://660d52b86ddfa2943b3418c7.mockapi.io/faculty"),body: map).then((value) async {
      await db.insert("demo",jsonDecode(value.body));
    });
  }
}