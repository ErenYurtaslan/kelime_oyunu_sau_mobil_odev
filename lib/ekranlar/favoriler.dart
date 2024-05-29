import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favoriler extends StatefulWidget {
  const Favoriler({super.key});

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  Future<List<Map<String, dynamic>>> getFavoriteWords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    var favoritesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favorites');
    var snapshot = await favoritesRef.get();
    return snapshot.docs.map((doc) => {
      'docId': doc.id, // Belge ID'sini al
      ...doc.data() as Map<String, dynamic>,
    }).toList();
  }

  void removeWordFromFavorites(String docId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(docId)
          .delete();
      setState(() {}); // Liste güncellemesi için ekranı yeniden çiz
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Kelimeler',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getFavoriteWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Favori kelime yok.'));
          }
          var favoriteWords = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteWords.length,
            itemBuilder: (context, index) {
              var word = favoriteWords[index];
              return Card(

                child: SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(word['word-eng']),
                    subtitle: Text(word['word-tr']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeWordFromFavorites(word['docId']);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
