import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/DbHelper.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/Kelimeler.dart';

class KelimeDao{



  Future<List<Kelimeler>> randomlyFetch() async{
    var db = await DbHelper.dbAccess();

    List<Map<dynamic,dynamic>> maps = await db.rawQuery(
        "SELECT*FROM kelimeler"
            " ORDER BY RANDOM() LIMIT 10");
    return List.generate(maps.length, (index){
      var line = maps[index];
      return Kelimeler(
        line["kelime_id"],
        line["turkce"],
        line["english"],
      );
    }
    );
  }







  Future<List<Kelimeler>> randomlyBringWrongOnes(int kelime_id) async{
    var db = await DbHelper.dbAccess();

    List<Map<dynamic,dynamic>> maps = await db.rawQuery(
        "SELECT*FROM kelimeler"
            " WHERE kelime_id != $kelime_id"
            " ORDER BY RANDOM() LIMIT 3");
    return List.generate(maps.length, (index){
      var line = maps[index];
      return Kelimeler(
        line["kelime_id"],
        line["turkce"],
        line["english"],
      );
    }
    );
  }



  Future<List<Kelimeler>> tumKelimeler() async {
    var db = await DbHelper.dbAccess();

    List<Map<dynamic,dynamic>> maps = await db.rawQuery("SELECT * FROM kelimeler");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kelimeler(satir["kelime_id"], satir["turkce"], satir["english"]);
    });
  }

  Future<void> kelimeEkle(String tr, String eng) async {
    var db = await DbHelper.dbAccess();

    var bilgiler = Map<String,dynamic>();

    bilgiler["turkce"] = tr;
    bilgiler["english"] = eng;

    await db.insert("kelimeler", bilgiler);
  }

  Future<void> kelimeGuncelle(int kelime_id,String tr,String eng) async {
    var db = await DbHelper.dbAccess();

    var bilgiler = Map<String,dynamic>();
    bilgiler["turkce"] = tr;
    bilgiler["english"] = eng;

    await db.update("kelimeler", bilgiler,where: "kelime_id=?",whereArgs: [kelime_id]);
  }

  Future<void> kelimeSil(int kelime_id) async {
    var db = await DbHelper.dbAccess();
    await db.delete("kelimeler",where: "kelime_id=?",whereArgs: [kelime_id]);
  }


}