import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Admin.dart';
import 'package:flutter_projet/pages/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final GlobalKey<FormState> _formUpdate = GlobalKey<FormState>();
  String email;
  void sharedPrefInit() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    setState(() {
      List fullname = prefs.getString("fullName").split(" ");
      _email.text = prefs.getString("email");
      email = prefs.getString("email");
      _tel.text = (prefs.getInt("tel")).toString();
      _nom.text = fullname[0];
      _prenom.text = fullname[1];
    });
  }

  @override
  void initState() {
    super.initState();
    sharedPrefInit();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Modify profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Form(
                key: _formUpdate,
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "Nom",
                          Icons.account_box,
                          _nom,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "Prenom",
                          Icons.account_box,
                          _prenom,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "email",
                          Icons.account_box,
                          _email,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "Téléphone",
                          Icons.phone,
                          _tel,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "********",
                          Icons.lock,
                          _password,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    customButton(),
                  ],
                )))
          ],
        ),
      ),
    );
  }

  Widget customButton() {
    return GestureDetector(
      onTap: () {
        if (_nom.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter your informations'),
          ));
        }
      },
      child: ElevatedButton(
          onPressed: () => {onSubmit()},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
            child: Text(
              "Modifier",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextFormField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var form = _formUpdate.currentState;

    Admin admin = new Admin(_nom.text, _prenom.text, int.parse(_tel.text),
        _email.text, _password.text);
    String fullName = _nom.text + " " + _prenom.text;
    prefs.setString("email", _email.text);
    prefs.setString("fullName", fullName);
    prefs.setInt("tel", int.parse(_tel.text));
    Navigator.pushNamed(context, "/home");
    if (form.validate()) {
      form.save();
      StockDB.instance.modifierAdmin(email, admin);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated !'),
      ));
    }
  }
}
