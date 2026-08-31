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
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vse dokonceno!')),
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
            Text(
              aktualnicvik.nazev,
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal[900]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15,),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tady bude video', textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: _posunNaDalsi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                currentIndex == widget.vybraneCviky.length - 1
                    ? 'Dokoncit cviceni'
                    : 'Dalsi cvik',
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
