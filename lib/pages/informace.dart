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
              nadpis: 'Fyziologie polykání',
              htmlPath: 'assets/html/1_fyziologie_polykani.html'),
          InfoKarta(
              nadpis: 'Nervy a struktury polykání',
              htmlPath: 'assets/html/2_nervy_polykani.html'),
          InfoKarta(
              nadpis: 'Správné a nesprávné polykání',
              htmlPath: 'assets/html/3_spravne_nespravne_polykani.html'),
          InfoKarta(
              nadpis: 'Režimová opatření',
              htmlPath: 'assets/html/4_rezimova_opatreni.html'),
          InfoKarta(
              nadpis: 'Zdroje',
              htmlPath: 'assets/html/5_zdroje.html'),
        ],
      ),
    );
  }
}
