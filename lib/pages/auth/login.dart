import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Admin.dart';
import 'package:flutter_projet/pages/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 7.5,
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
                "Sign In to Contiue!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Form(
                key: _formKeyLogin,
                child: Container(
                    child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "email", Icons.account_box, _email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "password", Icons.lock, _password),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    customButton(),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CreateAccount())),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter your informations'),
          ));
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            onPressed: () => onSubmit(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
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
    var form = _formKeyLogin.currentState;
    var email = _email.text;
    var password = _password.text;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    if (form.validate()) {
      form.save();
      List admins = await StockDB.instance.getAuth(email, password);
      Admin adminUser;

      if (admins.length > 0) {
        adminUser = admins[0];

        String nom = adminUser.nom;
        String prenom = adminUser.prenom;
        int tel = adminUser.tel;
        String fullName = nom + " " + prenom;
        prefs.setString("email", email);
        prefs.setString("fullName", fullName);
        prefs.setInt("tel", tel);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully logged in !'),
        ));
        Navigator.pushNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The email or password is incorrect'),
        ));
      }
    }
  }
}
