/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/bilinmeyenler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/favoriler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimelerListesi.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/ogrenilenler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/quiz.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {

bool _isAdmin = false;


  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == 'admin@gmail.com') {
      setState(() {
        _isAdmin = true;
      });
    } else {
      setState(() {
        _isAdmin = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,

      appBar: AppBar(
        actions: [

          if(_isAdmin)
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => KelimelerListesi()));
              }, child: const Text("Kelime Listesi")),


          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color:Colors.black,
            ),
          ),
        ],
        title: const Text('Kelime Bilmece'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[




            Container(
              margin: const EdgeInsets.only(
                bottom:20,
                left: 20,
                right:20,
              ),
              width: 190,
              child: Image.asset('images/girisresmi.png'),
            ),





            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage()));
                },
                child: Text("BAŞLA", style: TextStyle(color: Colors.white),),
              ),
            ),


          ],
        ),
      ),

      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 30,
            bottom: 150,
            child: FloatingActionButton.extended(
              heroTag: 'fab1',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Favoriler()));
              },
              label: Text("Favorilerim"),
              icon: Icon(Icons.favorite),
            ),
          ),

          Positioned(
            right: 30,
            bottom: 90,
            child: FloatingActionButton.extended(
                heroTag: 'fab2',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Ogrenilenler()));
              },
              label: Text("Öğrendiklerim"),
              icon: Icon(Icons.play_lesson),
            ),
          ),

          Positioned(
            right: 30,
            bottom: 30,
            child: FloatingActionButton.extended(
                heroTag: 'fab3',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bilinmeyenler()));
              },
              label: Text("Bilemediklerim"),
              icon: Icon(Icons.device_unknown),
            ),
          ),
        ],
      ),


    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/basariOranlari.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/bilinmeyenler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/favoriler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimelerListesi.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/ogrenilenler.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/quiz.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isAdmin = user != null && user.email == 'admin@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      appBar: AppBar(
        actions: [
          if (_isAdmin)
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => KelimelerListesi()));
              },
              icon: const Icon(Icons.list, color: Colors.white),
              tooltip: 'Kelime Listesi',
            ),

          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BasariOranlariPage()));
          }, child: _isAdmin==true ? Text("Başarı Oranları",style: TextStyle(color: Colors.white),) : Text("Başarı Oranım",style: TextStyle(color: Colors.white))),

          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            tooltip: 'Çıkış Yap',
          ),
        ],
        title: const Text('Kelime Bilmece' , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/girisresmi.png', width: 190),
            const SizedBox(height: 20),
            _buildButton(context, 'BAŞLA', () => QuizPage(), Colors.deepPurple, Colors.white),
            const SizedBox(height: 10),
          ],
        ),
      ),

      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget Function() page, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: bgColor),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page())),
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }


  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildFloatingActionButton('Favorilerim', Icons.favorite, () => Favoriler(), "1"),
        const SizedBox(height: 10),
        _buildFloatingActionButton('Öğrendiklerim', Icons.play_lesson, () => Ogrenilenler(), "2"),
        const SizedBox(height: 10),
        _buildFloatingActionButton('Bilemediklerim', Icons.device_unknown, () => Bilinmeyenler(), "3"),
      ],
    );
  }

  Widget _buildFloatingActionButton(String label, IconData icon, Widget Function() page, String heroTag) {
    return FloatingActionButton.extended(
      heroTag: heroTag,
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page())),
      label: Text(label),
      icon: Icon(icon),
    );
  }

}
