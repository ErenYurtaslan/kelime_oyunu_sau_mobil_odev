import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimelerListesi.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/KelimeDao.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/Kelimeler.dart';

// ignore: must_be_immutable
class KelimeDetay extends StatefulWidget {
  Kelimeler kelime;
  KelimeDetay({super.key, required this.kelime});

  @override
  State<KelimeDetay> createState() => _KelimeDetayState();
}

class _KelimeDetayState extends State<KelimeDetay> {

  var tr = TextEditingController();
  var eng = TextEditingController();

  Future<void> sil(int kelime_id) async {
    await KelimeDao().kelimeSil(kelime_id);

  }

  Future<void> guncelle(int kelime_id,String tr, String eng) async {
    await KelimeDao().kelimeGuncelle(kelime_id, tr, eng);

  }

  @override
  void initState() {
    super.initState();
    var kelime = widget.kelime;
    tr.text = kelime.turkce.toString();
    eng.text = kelime.english.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: Text("Kelime Detayı"),
        actions: [
          TextButton(
            child: Text("Sil",style: TextStyle(color: Colors.white),),
            onPressed: (){
              sil(widget.kelime.kelime_id);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KelimelerListesi()));
            },
          ),
          TextButton(
            child: Text("Güncelle",style: TextStyle(color: Colors.white),),
            onPressed: (){
              guncelle(widget.kelime.kelime_id, tr.text, eng.text);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KelimelerListesi()));
            },
          ),
        ],
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
    );
  }
}
