import 'package:flutter/material.dart';
import 'package:a_dysfagie/pages/home.dart';
import 'package:a_dysfagie/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
      },
  ));
}



