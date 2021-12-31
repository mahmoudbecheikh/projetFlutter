import 'package:flutter_projet/models/Membre.dart';

class Admin extends Membre {
  String email;
  String password;

  Admin(String nom, String prenom, int tel, this.email, this.password)
      : super(nom, prenom, tel);

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'tel': tel,
      'email': email,
      'password': password
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) => new Admin(
        map['nom'],
        map['prenom'],
        map['tel'],
        map['email'],
        map['password'],
      );

  @override
  String toString() {
    return super.toString();
  }
}
