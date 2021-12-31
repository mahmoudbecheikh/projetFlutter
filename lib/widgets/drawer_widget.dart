import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({Key key}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  String email = "";
  String fullName = "";
  void logoutUser(BuildContext context) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
    Navigator.pushNamed(context, "/login");
  }

  void sharedPrefInit() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    setState(() {
      email = prefs.getString("email");
      fullName = prefs.getString("fullName");
    });
  }

  @override
  void initState() {
    super.initState();
    sharedPrefInit();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(
            "Email : $email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          accountName: Text(
            "FullName :  $fullName",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage("assets/images/user.png"),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "Home",
            style: TextStyle(fontSize: 15.0),
          ),
          leading: Icon(
            Icons.home,
            color: Colors.blueGrey,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, "/home");
          },
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          title: Text(
            "Profil",
            style: TextStyle(fontSize: 15.0),
          ),
          leading: Icon(
            Icons.person,
            color: Colors.blueGrey,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, "/profile");
          },
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          title: Text(
            "Déconnexion",
            style: TextStyle(fontSize: 15.0),
          ),
          leading: Icon(
            Icons.logout,
            color: Colors.blueGrey,
            size: 25,
          ),
          onTap: () {
            Navigator.of(context).pop();
            logoutUser(context);
          },
        ),
      ],
    ));
  }
}
