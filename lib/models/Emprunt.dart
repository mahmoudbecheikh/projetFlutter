class Emprunt {
  int id;
  int id_composant;
  int id_membre;
  int quantite;
  String dateEmprunt;
  int emprunte;

  Emprunt(int id_composant, int id_membre, int quantite, String date,
      int emprunte) {
    this.id_composant = id_composant;
    this.id_membre = id_membre;
    this.quantite = quantite;
    this.dateEmprunt = date;
    this.emprunte = emprunte;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'id_composant': id_composant,
      'id_membre': id_membre,
      'quantite': quantite,
      "dateEmprunt": dateEmprunt,
      "emprunte": emprunte
    };
  }

  factory Emprunt.fromMap(Map<String, dynamic> map) => new Emprunt(
      map['id_composant'],
      map['id_membre'],
      map['quantite'],
      map['dateEmprunt'],
      map['emprunte']);

  @override
  String toString() {
    return this.id.toString();
  }
}
