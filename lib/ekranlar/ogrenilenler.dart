import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ogrenilenler extends StatefulWidget {
  @override
  _OgrenilenlerState createState() => _OgrenilenlerState();
}

class _OgrenilenlerState extends State<Ogrenilenler> {
  Future<List<Map<String, dynamic>>> getOgrenilenWords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    var ogrenilenlerRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('ogrenilenler');
    var snapshot = await ogrenilenlerRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Öğrenilen Kelimeler'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getOgrenilenWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Öğrenilen kelime yok.'));
          }
          var words = snapshot.data!;
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(words[index]['word-eng']),
                subtitle: Text(words[index]['word-tr']),
              );
            },
          );
        },
      ),
    );
  }
}
