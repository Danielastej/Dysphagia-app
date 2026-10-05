import 'package:flutter/material.dart';
import 'package:a_dysfagie/data/html_zobrazovac.dart';

class InfoKarta extends StatelessWidget {
  final String nadpis;
  final String htmlPath;
  const InfoKarta({
    super.key,
    required this.nadpis,
    required this.htmlPath
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        title: Text(
          nadpis,
          style: TextStyle(
              color: Colors.teal[700],
              fontSize: 22),
        ),
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => HtmlDetailPage(
                      nadpis: nadpis,
                      htmlPath: htmlPath
                  ),
              ),
          );
        },
      ),
    );
  }
}

