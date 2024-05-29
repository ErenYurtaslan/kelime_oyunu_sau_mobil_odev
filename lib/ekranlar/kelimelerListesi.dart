import 'package:flutter/material.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimeDetay.dart';
import 'package:kelime_oyunu_sau_mobil_odev/ekranlar/kelimeKayit.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/KelimeDao.dart';
import 'package:kelime_oyunu_sau_mobil_odev/yardimciSiniflar/Kelimeler.dart';

class KelimelerListesi extends StatefulWidget {
  const KelimelerListesi({super.key});

  @override
  State<KelimelerListesi> createState() => _KelimelerListesiState();
}

class _KelimelerListesiState extends State<KelimelerListesi> {

  Future<List<Kelimeler>> tumKelimelerGoster() async {
    var kelimelerListesi = await KelimeDao().tumKelimeler();
    return kelimelerListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelimeler", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body:FutureBuilder<List<Kelimeler>>(
        future: tumKelimelerGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
              itemBuilder: (context,indeks){
                var kelime = kelimelerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => KelimeDetay(kelime: kelime,)));
                  },
                  child: Card(
                    child: SizedBox(height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(kelime.turkce.toString()),
                          Text(kelime.english.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return const Center();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KelimeKayit()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
