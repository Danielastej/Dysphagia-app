import 'package:flutter/material.dart';
import 'package:a_dysfagie/models/cvik.dart';
import 'package:a_dysfagie/data/cviky_data.dart';
import 'package:a_dysfagie/pages/cviceni.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final bool isDemoMode;

  const Home({
    super.key,
    this.isDemoMode = false, // Výchozí hodnota je false (běžný pacient)
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(
          widget.isDemoMode ? 'Aplikace (Ukázkový režim)' : 'Aplikace',
          style: const TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Jemná lišta pro ukázkový režim zachovávající teal paletu
          if (widget.isDemoMode)
            Container(
              color: Colors.teal[900],
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Předváděcí režim pro pacienta – zpřístupněny všechny cviky',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.teal[700],
                  ),
                  child: Icon(Icons.question_mark_rounded,size: 40,color: Colors.white,),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () async {
                  List<Cvik> kProcviceni = [];

                  if (widget.isDemoMode) {
                    // V Ukázkovém/Demo režimu lékaře jsou přístupné všechny cviky
                    kProcviceni = vsechnyCviky;
                  } else {
                    // 1. Zjistíme ID přihlášeného pacienta
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // 2. Načteme uložené cviky z kolekce assigned_exercises
                      final docSnap = await FirebaseFirestore.instance
                          .collection('assigned_exercises')
                          .doc(user.uid)
                          .get();

                      if (docSnap.exists) {
                        List<dynamic> assignedNames = docSnap.get('exercises') ?? [];

                        // 3. Vybereme pouze ty cviky z aplikace, které má pacient přiřazené od lékaře
                        kProcviceni = vsechnyCviky
                            .where((cvik) => assignedNames.contains(cvik.nazev))
                            .toList();
                      }
                    }
                  }

                  if (!mounted) return;

                  if (kProcviceni.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Nemáte od lékaře přiřazené žádné cviky.'),
                        backgroundColor: Colors.grey[800],
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cviceni(vybraneCviky: kProcviceni),
                      ),
                    );
                  }
                },
                customBorder: const CircleBorder(),
                child: Container(
                  width: 200,
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal[700]!,
                      width: 5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.asset(
                      'assets/swallowicon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.teal[700],
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/informace');
                  },
                  icon: Icon(
                      Icons.lightbulb_outline_rounded
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/statistiky');
                  },
                  icon: Icon(
                      Icons.bar_chart
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.email_outlined
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/nastaveni');
                  },
                  icon: Icon(
                      Icons.settings
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

