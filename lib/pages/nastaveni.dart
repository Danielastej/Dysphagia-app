import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Nastavení', style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 70,
              child:
              ElevatedButton(onPressed: (){

              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Barva aplikace',
                      style: TextStyle(
                          color: Colors.teal[700],
                          fontSize: 22
                      ),
                    ),
                    Icon(
                      Icons.palette_outlined,
                      size: 25,
                      color: Colors.teal[700],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 7,),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Odhlásit se',
                      style: TextStyle(color: Colors.teal[700], fontSize: 22),
                    ),
                    Icon(
                      Icons.logout,
                      size: 25,
                      color: Colors.teal[700],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
