import 'package:flutter/material.dart';
import 'package:a_dysfagie/models/card_sablona.dart';

class Informace extends StatelessWidget {
  const Informace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Informace o Dysfagii', style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          InfoKarta(
              nadpis: 'Fáze polykání',
              htmlPath: 'assets/html/faze_polykani_interaktivni.html'),
          InfoKarta(
              nadpis: 'Nervy a struktury polykání',
              htmlPath: 'assets/html/nervy_a_struktury_polykani.html'),
          InfoKarta(
              nadpis: 'Režimová opatření',
              htmlPath: 'assets/html/rezimova_opatreni_mobil_jeden_sloupec.html'),
          InfoKarta(
              nadpis: 'Správné polykání a aspirace',
              htmlPath: 'assets/html/spravne_polykani_vs_aspirace.html')
        ],
      ),
    );
  }
}
