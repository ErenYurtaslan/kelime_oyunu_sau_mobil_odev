import 'dart:collection';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/KelimeDao.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/sonuc.dart';
import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/Kelimeler.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

/*
class GlobalLists {
  static final GlobalLists _instance = GlobalLists._internal();

  factory GlobalLists() {
    return _instance;
  }

  GlobalLists._internal();

  List<Kelimeler> dogruCevaplar = [];
  List<Kelimeler> yanlisCevaplar = [];
}*/

class GlobalLists {
  static final GlobalLists _instance = GlobalLists._internal();

  factory GlobalLists() {
    return _instance;
  }

  GlobalLists._internal();

  List<Kelimeler> dogruCevaplar = [];
  List<Kelimeler> yanlisCevaplar = [];

  void clearLists() {
    dogruCevaplar.clear();
    yanlisCevaplar.clear();
  }
}




class _QuizPageState extends State<QuizPage> {



  var questions = <Kelimeler>[];
  var wrongAnswers = <Kelimeler>[];
  late Kelimeler correctAnswer;
  var allAnswers = HashSet<Kelimeler>();

  int questionCounter = 0;
  int correctCounter = 0;
  int wrongCounter = 0;

  String flagImageName = "placeholder.png";
  String aButtonText = "";
  String bButtonText = "";
  String cButtonText = "";
  String dButtonText = "";


  @override
  void initState() {
    super.initState();
    GlobalLists().clearLists();
    getQuestions();
  }




  Future<void> getQuestions() async{
    questions = await KelimeDao().randomlyFetch();
    uploadQuestion();
  }


  Future<void> uploadQuestion() async{
    correctAnswer = questions[questionCounter];

    flagImageName = correctAnswer.english;

    wrongAnswers = await KelimeDao().randomlyBringWrongOnes(correctAnswer.kelime_id);




    allAnswers.clear();

    allAnswers.add(correctAnswer);

    allAnswers.add(wrongAnswers[0]);
    allAnswers.add(wrongAnswers[1]);
    allAnswers.add(wrongAnswers[2]);


    aButtonText = allAnswers.elementAt(0).turkce;
    bButtonText = allAnswers.elementAt(1).turkce;
    cButtonText = allAnswers.elementAt(2).turkce;
    dButtonText = allAnswers.elementAt(3).turkce;

    setState(() {});

  }


  void processQuizResults() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Kullanıcı girişi yapılmamış.");
      return;
    }

    var ogrenilenlerRef =  FirebaseFirestore.instance.collection('users').doc(userId).collection('ogrenilenler');
    var bilinmeyenlerRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('bilinmeyenler');

    try {
      for (var kelime in GlobalLists().dogruCevaplar) {
        await bilinmeyenlerRef.doc(kelime.kelime_id.toString()).delete();
        await ogrenilenlerRef.doc(kelime.kelime_id.toString()).set({'word-eng': kelime.english, 'word-tr': kelime.turkce});
      }

      for (var kelime in GlobalLists().yanlisCevaplar) {
        await ogrenilenlerRef.doc(kelime.kelime_id.toString()).delete();
        await bilinmeyenlerRef.doc(kelime.kelime_id.toString()).set({'word-eng': kelime.english, 'word-tr': kelime.turkce});
      }
    } catch (e) {
      print("Bir hata oluştu: $e");
    }
  }




  void questionCounterControlling(){
    questionCounter++;

    if(questionCounter != 10){
      uploadQuestion();
    }else{
      processQuizResults();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(dogruSayisi: correctCounter)));
    }

  }




  void correctControlling(String buttonText) {
    var globalLists = GlobalLists();
    if (correctAnswer.turkce == buttonText) {
      correctCounter++;
      globalLists.dogruCevaplar.add(correctAnswer);
    } else {
      wrongCounter++;
      globalLists.yanlisCevaplar.add(correctAnswer);
    }
  }

  void addWordToFavorites(Kelimeler word) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Kullanıcı girişi yapılmamışsa hata mesajı göster veya işlem yapma
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .add({'word-eng': word.turkce, 'word-tr':word.english}); // Veya word'ün diğer özellikleri...
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,

      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              addWordToFavorites(correctAnswer); // Burada doğru cevap kelimesi favorilere ekleniyor
            },
          ),

        ],
        title: const Text("Bilmece Ekranı", style:  TextStyle(color: Colors.indigo),),
      ),




      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Doğru : $correctCounter", style: TextStyle(fontSize: 18, color: Colors.cyanAccent.shade100),),
                Text("Yanlış : $wrongCounter", style: TextStyle(fontSize: 18, color: Colors.cyanAccent.shade100),),
              ],
            ),




            questionCounter != 10     ?      Text("${questionCounter+1}. SORU", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),)         :        Text("$questionCounter. SORU", style: TextStyle(fontSize: 30, color: Colors.cyanAccent.shade100),),


            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 100,
                minHeight: 100,
                maxWidth: 300,
                maxHeight: 300,
              ),
              child: Card(
                color: Colors.pink.shade900,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(flagImageName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 50),),
                ),
              ),
            ),






            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
               onPressed: (){
                  correctControlling(aButtonText);
                  questionCounterControlling();
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(dogruSayisi: 3,)));
                },

                child: Text("A) $aButtonText", style: TextStyle(color: Colors.indigo.shade900),),
              ),
            ),




            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  correctControlling(bButtonText);
                  questionCounterControlling();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(dogruSayisi: 3,)));
                },
                child: Text("B) $bButtonText", style: TextStyle(color: Colors.indigo.shade900),),
              ),
            ),




            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  correctControlling(cButtonText);
                  questionCounterControlling();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(dogruSayisi: 3,)));
                },
                child: Text("C) $cButtonText", style: TextStyle(color: Colors.indigo.shade900),),
              ),
            ),





            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  correctControlling(dButtonText);
                  questionCounterControlling();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(dogruSayisi: 3,)));
                },
                child: Text("D) $dButtonText", style: TextStyle(color: Colors.indigo.shade900),),
              ),
            ),

          ],
        ),
      ),

    );
  }

}



