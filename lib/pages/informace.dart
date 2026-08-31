import 'package:flutter/material.dart';

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
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15)
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              backgroundColor: Colors.grey[200],
              title: Text(
                'Základní informace o dysfagii',
                style: TextStyle(color: Colors.teal[700], fontSize: 22),
              ),
              children: [
                ListTile(
                  title: Text(
                    'Co je to dysfagie?',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
                ListTile(
                  title: Text(
                    'Příznaky a příčiny',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
                ListTile(
                  title: Text(
                    'Základní lečba',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
                ListTile(
                  title: Text(
                    'Dysfagie v ČR',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15)
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              backgroundColor: Colors.grey[200],
              title: Text(
                'Dysfagie u dětí',
                style: TextStyle(color: Colors.teal[700], fontSize: 22),
              ),
              children: [
                ListTile(
                  title: Text(
                    'Rané příznaky',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
                ListTile(
                  title: Text(
                    'Léčba dysfagie u dětských pacientů',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                )
              ],
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15)
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              backgroundColor: Colors.grey[200],
              title: Text(
                'Další info',
                style: TextStyle(color: Colors.teal[700], fontSize: 22),
              ),
              children: [
                ListTile(
                  title: Text(
                    '.....',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
                ListTile(
                  title: Text(
                    '.....',
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 22),
                  ),
                  tileColor: Colors.white,
                  onTap: (){

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
