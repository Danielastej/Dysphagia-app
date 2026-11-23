import 'package:flutter/material.dart';
import 'package:a_dysfagie/models/cvik.dart';

class Cviceni extends StatefulWidget {
  final List<Cvik> vybraneCviky;
  const Cviceni({super.key,required this.vybraneCviky});

  @override
  State<Cviceni> createState() => _CviceniState();
}

class _CviceniState extends State<Cviceni> {
  int currentIndex = 0;
  void _posunNaDalsi(){
   if (currentIndex < widget.vybraneCviky.length - 1) {
     setState(() {
       currentIndex++;
     });
   }
   else {
     Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vše dokončeno!')),
     );
   }
  }
  @override
  Widget build(BuildContext context) {
    final aktualnicvik = widget.vybraneCviky[currentIndex];

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(
          'Cvik ${currentIndex+1} z ${widget.vybraneCviky.length}',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Kategorie cviku
                    Text(
                      aktualnicvik.kategorie.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Colors.teal[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Název cviku
                    Text(
                      aktualnicvik.nazev,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),

                    // Zástupný box pro video
                    Container(
                      height: 220,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tady bude video',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Popisek provedení pro pacienta
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Postup cvičení:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            aktualnicvik.popis,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Pomůcky a upozornění (zobrazí se jen tehdy, když u cviku existují)
                    if (aktualnicvik.pomucky != null &&
                        aktualnicvik.pomucky!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          border: Border.all(color: Colors.amber.shade700, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.amber[900],
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                aktualnicvik.pomucky!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Spodní tlačítko pro posun na další cvik
            ElevatedButton(
              onPressed: _posunNaDalsi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentIndex == widget.vybraneCviky.length - 1
                    ? 'Dokončit cvičení'
                    : 'Další cvik',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}