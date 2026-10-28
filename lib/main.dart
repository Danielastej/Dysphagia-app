import 'package:a_dysfagie/data/cviky_data.dart';
import 'package:flutter/material.dart';
import 'package:a_dysfagie/pages/home.dart';
import 'package:a_dysfagie/pages/loading.dart';
import 'package:a_dysfagie/pages/nastaveni.dart';
import 'package:a_dysfagie/pages/seznamcviku.dart';
import 'package:a_dysfagie/pages/informace.dart';
<<<<<<< HEAD
import 'package:a_dysfagie/pages/statistiky.dart';
=======
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:a_dysfagie/pages/login.dart';
import 'package:a_dysfagie/pages/doctor_home.dart';
>>>>>>> d396ca4 (Přihlašování doktor/pacient)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await nacistVybraneCviky();

  runApp(MaterialApp(
    initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/loading': (context) => Loading(),
        '/home': (context) => Home(),
        '/doctor_home': (context) => DoctorHome(),
        '/nastaveni': (context) => Settings(),
        '/seznamcviku': (context) => Seznamcviku(),
        '/informace': (context) => Informace(),
        '/statistiky': (context) => const StatistikyPage(),
      },
  ));
}



