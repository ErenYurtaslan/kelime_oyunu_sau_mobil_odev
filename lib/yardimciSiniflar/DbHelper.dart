import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static const String dbName = "kelimelerFlip.db";

  static Future<Database> dbAccess() async{
    String dbPath = join(await getDatabasesPath(), dbName);

    if(await databaseExists(dbPath)){//veri tabanı var mı yok mu kontrolü
      print("Veri tabanı kaydı zaten var.");
    }else{
      //assetten veri tabanının alınması
      ByteData data =await rootBundle.load("database/$dbName");
      //Veri tabanının copy işlemi için byte dönüşümü
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //Veri tabanının kopyalanması
      await File(dbPath).writeAsBytes(bytes, flush: true);
      print("Veri tabanı kopyalandı.");
    }

    return openDatabase(dbPath);

  }
}