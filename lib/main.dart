import 'package:flutter/material.dart';
import 'package:flutter_projet/pages/auth/login.dart';
import 'package:flutter_projet/pages/home_page.dart';
import 'package:flutter_projet/pages/list_composant.dart';
import 'package:flutter_projet/pages/list_composantNo.dart';
import 'package:flutter_projet/pages/list_emprunt.dart';
import 'package:flutter_projet/pages/list_family.dart';
import 'package:flutter_projet/pages/list_retour.dart';
import 'package:flutter_projet/pages/profile.dart';

import 'pages/list_membre.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (context) {
          return HomePage();
        },
        "/login": (context) {
          return LoginScreen();
        },
        "/profile": (context) {
          return Profile();
        },
        "/famille": (context) {
          return ListFamily();
        },
        "/composant": (context) {
          return ListComposant();
        },
        "/membre": (context) {
          return ListMembre();
        },
        "/emprunt": (context) {
          return ListEmprunt();
        },
        "/retour": (context) {
          return ListRetour();
        },
        "/composantNoRetourne": (context) {
          return ListComposantNo();
        },
      },
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: "/home",
    );
  }
}
