class Retour {
  int id;
  int id_emprunt;
  String etat;
  String dateRetour;

  Retour(int id_emprunt, String etat, String date) {
    this.id_emprunt = id_emprunt;
    this.etat = etat;
    this.dateRetour = date;
  }

  //

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_emprunt': id_emprunt,
      'etat': etat,
      'dateRetour': dateRetour,
    };
  }

  factory Retour.fromMap(Map<String, dynamic> map) => new Retour(
        map['id_emprunt'],
        map['etat'],
        map['date'],
      );

  String toString() {
    // TODO: implement toString
    return this.id.toString();
  }
}
