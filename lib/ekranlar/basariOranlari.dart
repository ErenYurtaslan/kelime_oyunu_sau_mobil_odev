import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/sonuc.dart';


class BasariOranlariPage extends StatefulWidget {
  @override
  _BasariOranlariPageState createState() => _BasariOranlariPageState();
}

class _BasariOranlariPageState extends State<BasariOranlariPage> {
  double? genelOrtalama;

  @override
  void initState() {
    super.initState();
    yukleGenelOrtalama();
  }

  void yukleGenelOrtalama() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    genelOrtalama = prefs.getDouble('genelOrtalama_$userId');
    setState(() {});
  }

  Widget buildAdminView() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('basariOranlari').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Bir hata oluştu.');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['userId'] ?? 'Bilinmiyor'),
              subtitle: Text('Genel Başarı Oranı: ${data['genelOrtalama']?.toStringAsFixed(2)}%'),
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildUserView() {
    return Center(
      child: genelOrtalama == null
          ? Text('Başarı oranınız yükleniyor...')
          : Text('Genel Başarı Oranınız: ${genelOrtalama!.toStringAsFixed(2)}%'),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com';
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Tüm Kullanıcıların Başarı Oranları' : 'Genel Başarı Oranım'),
      ),
      body: isAdmin ? buildAdminView() : buildUserView(),
    );
  }
}
