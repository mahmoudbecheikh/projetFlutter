class Composant {
  int id;
  String nom;
  String image;
  int quantite;
  int id_famille;
  int disponible;
  String dateAcquisition;

  Composant(String nom, String image, int quantite, int id_famille,
      int disponible, String date) {
    this.nom = nom;
    this.image = image;
    this.quantite = quantite;
    this.disponible = disponible;
    this.id_famille = id_famille;
    this.dateAcquisition = date;
  }

  //

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'nom': nom,
      'image': image,
      'quantite': quantite,
      'disponible': disponible,
      'id_famille': id_famille,
      'dateAcquisition': dateAcquisition,
    };
  }

  factory Composant.fromMap(Map<String, dynamic> map) => new Composant(
        map['nom'],
        map['image'],
        map['quantite'],
        map['disponible'],
        map['id_famille'],
        map['dateAcquisition'],
      );

  @override
  String toString() {
    // TODO: implement toString
    return this.nom;
  }
}
