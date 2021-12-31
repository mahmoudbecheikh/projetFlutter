class Membre {
  int id;
  String nom;
  String prenom;
  int tel;

  Membre(String nom, String prenom, int tel) {
    this.nom = nom;
    this.prenom = prenom;
    this.tel = tel;
  }

  //

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'tel': tel};
  }

  factory Membre.fromMap(Map<String, dynamic> map) =>
      new Membre(map['nom'], map['prenom'], map['tel']);

  @override
  String toString() {
    // TODO: implement toString
    return this.nom.toString();
  }
}
