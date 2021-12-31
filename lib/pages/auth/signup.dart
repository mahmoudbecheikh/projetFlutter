import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Admin.dart';
import 'package:flutter_projet/pages/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final GlobalKey<FormState> _formKeySign = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create an account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 40,
            ),
            Container(
              width: size.width / 1.1,
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: size.width / 1.1,
              child: Text(
                "Create Account to Contiue!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Form(
                key: _formKeySign,
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(
                        size,
                        "email",
                        Icons.account_box,
                        _email,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                          size,
                          "password",
                          Icons.lock,
                          _password,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(
                        size,
                        "Téléphone",
                        Icons.phone,
                        _tel,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    customButton(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginScreen())),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
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
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
    var form = _formKeySign.currentState;
    var nom = _nom.text;
    var prenom = _prenom.text;
    var tel = int.parse(_tel.text);
    var password = _password.text;
    var email = _email.text;
    Admin admin = new Admin(nom, prenom, tel, email, password);
    String fullName = nom + " " + prenom;
    prefs.setString("email", email);
    prefs.setString("fullName", fullName);
    prefs.setInt("tel", tel);
    Navigator.pushNamed(context, "/home");
    if (form.validate()) {
      form.save();
      StockDB.instance.insertAdmin(admin);
    }
  }
}
