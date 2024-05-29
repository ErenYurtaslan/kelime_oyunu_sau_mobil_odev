import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimelerListesi.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/KelimeDao.dart';

class KelimeKayit extends StatefulWidget {
  const KelimeKayit({super.key});

  @override
  State<KelimeKayit> createState() => _KelimeKayitState();
}

class _KelimeKayitState extends State<KelimeKayit> {


  var tr = TextEditingController();
  var eng = TextEditingController();

  Future<void> kayit(String tr, String eng) async {
    await KelimeDao().kelimeEkle(tr,eng);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KelimelerListesi()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelime Kayıt"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0,right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tr,
                decoration: InputDecoration(hintText: "Türkçe"),
              ),
              TextField(
                controller: eng,
                decoration: InputDecoration(hintText: "English"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          kayit( tr.text, eng.text);
        },
        tooltip: 'Kelime Kayıt',
        icon: Icon(Icons.save),
        label: const Text("Kaydet"),
      ),
    );
  }
}
