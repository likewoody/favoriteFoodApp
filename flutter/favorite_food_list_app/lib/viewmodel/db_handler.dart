import 'package:favorite_food_list_app/model/foodList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHandler{

  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'favoritefood.db'),
      onCreate: (db, version) async{
        await db.execute(
          "create table list (id integer primary key autoincrement, name text, phone text, lat text, lng text, sqlImg blob, rate text, inputDate text)"
        );
      },
      version: 1,
    );
  }

  // searchQuery
  Future<List<FoodList>> queryFoodList() async{
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult 
      = await db.rawQuery('select * from list');
    // 맵 형식인 result를 List로 변환하여 card로 사용한다.
    return queryResult.map((e) => FoodList.fromMap(e)).toList();
  }


  // insert
  Future<void> insertFoodList(FoodList foodList) async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into list(name, phone, lat, lng, sqlImg, rate, inputDate) values(?,?,?,?,?,?,?)',
      // ?에 값 넣기
      [foodList.name, foodList.phone, foodList.lat, foodList.lng, 
      foodList.sqlImg, foodList.rate, foodList.inputDate]
    );
  }

  // update
  Future<void> updateFoodList(FoodList foodList) async{
    final Database db = await initializeDB();
    await db.rawUpdate(
      'update list set name=?, phone=?, lat=?, lng=?, sqlImg=?, rate=?, inputDate=? where id = ?',
      // ?에 값 넣기
      [foodList.name, foodList.phone, foodList.lat, foodList.lng, 
      foodList.sqlImg, foodList.rate, foodList.inputDate, foodList.id]
    );
  }

  // delete
  Future<void> deleteFoodList(id) async{
    final Database db = await initializeDB();
    await db.rawDelete(
      'delete from list where id = ?',
      // ?에 값 넣기
      [id]
    );
  }
}