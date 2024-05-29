import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bilinmeyenler extends StatefulWidget {
  @override
  _BilinmeyenlerState createState() => _BilinmeyenlerState();
}

class _BilinmeyenlerState extends State<Bilinmeyenler> {
  Future<List<Map<String, dynamic>>> getBilinmeyenWords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    var bilinmeyenlerRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('bilinmeyenler');
    var snapshot = await bilinmeyenlerRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bilinmeyen Kelimeler'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getBilinmeyenWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Bilinmeyen kelime yok.'));
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
