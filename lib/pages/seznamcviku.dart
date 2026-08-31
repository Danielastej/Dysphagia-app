import 'package:flutter/material.dart';
import 'package:a_dysfagie/data/cviky_data.dart';

class Seznamcviku extends StatefulWidget {
  const Seznamcviku({super.key});

  @override
  State<Seznamcviku> createState() => _SeznamcvikuState();
}

class _SeznamcvikuState extends State<Seznamcviku> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Seznam cviků', style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        itemCount: vsechnyCviky.length,
        itemBuilder: (context,index){
          final cvik = vsechnyCviky[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CheckboxListTile(
                activeColor: Colors.teal[700],
                title: Text(cvik.nazev,style: TextStyle(fontSize: 20,color: Colors.teal[900])),
                value: cvik.isSelected,
                onChanged: (bool? newValue) {
                  setState(() {
                    cvik.isSelected = newValue ?? false;
                  });
                  ulozitVybraneCviky();
                },
            ),
          );
        },
      ),
    );
  }
}
