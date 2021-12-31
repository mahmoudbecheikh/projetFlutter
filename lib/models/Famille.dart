class Famille {
  int id;
  String nom;

  Famille(String nom) {
    this.nom = nom;
  }

  //

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom};
  }

  factory Famille.fromMap(Map<String, dynamic> map) => new Famille(map['nom']);

  @override
  String toString() {
    // TODO: implement toString
    return this.id.toString();
  }
}
