import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/bilinmeyenler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/favoriler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/ogrenilenler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {

  int dogruSayisi;


  ResultPage({super.key, required this.dogruSayisi});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {


  //final FirebaseAuth _auth = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    kaydetBasariOrani();
  }

 void kaydetBasariOrani() async {
   final String userId = FirebaseAuth.instance.currentUser!.uid;
   final double mevcutOran = (widget.dogruSayisi * 100) / 10;
   final prefs = await SharedPreferences.getInstance();

   // Toplam ve quiz sayısını güncelle
   double toplamOran = prefs.getDouble('toplamOran_$userId') ?? 0.0;
   int quizSayisi = prefs.getInt('quizSayisi_$userId') ?? 0;

   toplamOran += mevcutOran;
   quizSayisi += 1;

   prefs.setDouble('toplamOran_$userId', toplamOran);
   prefs.setInt('quizSayisi_$userId', quizSayisi);

   double genelOrtalama = toplamOran / quizSayisi;
   // Firestore'a kaydet
   await _firestore.collection('basariOranlari').doc(userId).set({
     'userId': userId,
     'genelOrtalama': genelOrtalama,
   }, SetOptions(merge: true));
 }

/*
  void kaydetBasariOrani() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final double mevcutOran = (widget.dogruSayisi * 100) / 10;
    final prefs = await SharedPreferences.getInstance();

    List<String> oranlar = prefs.getStringList('genelOrtalama_$userId') ?? [];
    oranlar.add(mevcutOran.toString());
    prefs.setStringList('genelOrtalama_$userId', oranlar);

    double toplam = oranlar.fold(0.0, (previousValue, element) => previousValue + double.parse(element));
    double genelOrtalama = toplam / oranlar.length;
    prefs.setDouble('genelOrtalama_$userId', genelOrtalama);

    await _firestore.collection('basariOranlari').doc(userId).set({
      'userId': userId,
      'genelOrtalama': genelOrtalama,
    }, SetOptions(merge: true));
  }
*/

/*
  void kaydetBasariOrani() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final double mevcutOran = (widget.dogruSayisi * 100) / 10;
    final prefs = await SharedPreferences.getInstance();

    // Kullanıcının şu ana kadar ki başarı oranlarını getir ve güncelle
    List<String> oranlar = prefs.getStringList('genelOrtalama_$userId') ?? [];
    oranlar.add(mevcutOran.toString());
    prefs.setStringList('genelOrtalama_$userId', oranlar);

    // Genel ortalamayı hesapla ve hem SharedPreferences hem de Firestore'a kaydet
    double toplam = oranlar.fold(0.0, (previousValue, element) => previousValue + double.parse(element));
    double genelOrtalama = toplam / oranlar.length;
    prefs.setDouble('genelOrtalama_$userId', genelOrtalama);

    // Firestore'a kaydet
    _firestore.collection('basariOranlari').doc(userId).set({
      'userId': userId,
      'genelOrtalama': genelOrtalama,
    }, SetOptions(merge: true));
  }*/

  /*_firestore.collection('basariOranlari').add({
  'userId' : userId,
  'genelOrtalama' : genelOrtalama,
  });
}*/


/*
  void kaydetBasariOrani() async {
    final String userId = _auth.currentUser!.uid;
    final String userEmail = _auth.currentUser!.email!;
    final double mevcutOran = (widget.dogruSayisi * 100) / 10;

    if (userEmail == 'admin@gmail.com') {
      // Admin için Firestore'a kaydetme işlemi
      final CollectionReference oranlarRef = _firestore.collection('kullaniciBasariOranlari');

      oranlarRef.doc(userId).set({
        'email': userEmail,
        'sonOran': mevcutOran,
        'tarih': Timestamp.now(),
      }, SetOptions(merge: true));
    } else {
      // Diğer kullanıcılar için SharedPreferences kullanma işlemi
      final prefs = await SharedPreferences.getInstance();

      // Kullanıcı ID'sine göre başarı oranını kaydet
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<String> oranlar = prefs.getStringList('quizOranlari_$userId') ?? [];
      oranlar.add(mevcutOran.toString());
      prefs.setStringList('quizOranlari_$userId', oranlar);

// Genel ortalamayı güncelle
      double toplam = oranlar.fold(0.0, (previousValue, element) => previousValue + double.parse(element));
      double genelOrtalama = toplam / oranlar.length;
      prefs.setDouble('genelOrtalama_$userId', genelOrtalama);

    }
  }*/





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,

      appBar: AppBar(
        title: const Text("Sonuç Ekranı", style: TextStyle(color: Colors.indigo),),
      ),



      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Text("${widget.dogruSayisi} DOĞRU ${10-widget.dogruSayisi} YANLIŞ", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),),
            Text("%${(widget.dogruSayisi*100)~/10} Başarı Oranı", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),),
            widget.dogruSayisi >= 7   ?   Text("TEBRİKLER!", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),)       :      Text("GELİŞMELİSiNİZ!", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),),




            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("TEKRAR OYNA", style: TextStyle(color: Colors.indigo.shade900),),
              ),
            ),


          ],
        ),



      ),


    );



  }






}
