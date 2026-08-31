import 'package:a_dysfagie/data/cviky_data.dart';
import 'package:flutter/material.dart';
import 'package:a_dysfagie/pages/home.dart';
import 'package:a_dysfagie/pages/loading.dart';
import 'package:a_dysfagie/pages/nastaveni.dart';
import 'package:a_dysfagie/pages/seznamcviku.dart';
import 'package:a_dysfagie/pages/informace.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await nacistVybraneCviky();

  runApp(MaterialApp(
    initialRoute: '/home',
      routes: {
        '/loading': (context) => Loading(),
        '/home': (context) => Home(),
        '/nastaveni': (context) => Settings(),
        '/seznamcviku': (context) => Seznamcviku(),
        '/informace': (context) => Informace(),
      },
  ));
}



