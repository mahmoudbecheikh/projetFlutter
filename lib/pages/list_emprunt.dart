import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Composant.dart';
import 'package:flutter_projet/models/Emprunt.dart';
import 'package:flutter_projet/models/Membre.dart';
import 'package:intl/intl.dart';

class ListEmprunt extends StatefulWidget {
  const ListEmprunt({Key key}) : super(key: key);

  @override
  _ListEmpruntState createState() => _ListEmpruntState();
}

class _ListEmpruntState extends State<ListEmprunt> {
  List<Map<String, dynamic>> _emprunt = [];
  List<Composant> _composants = [];
  List<Membre> _membres = [];
  String composant;
  String membre;

  String convert(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void _loop() async {
    List<Composant> composants = await StockDB.instance.ListComp();
    List<Membre> membres = await StockDB.instance.ListMem();
    for (var item in membres) {
      _membres.add(item);
    }

    for (var item in composants) {
      _composants.add(item);
    }
  }

  void _refreshEmprunt() async {
    final data = await StockDB.instance.ListEmprunt();
    setState(() {
      _emprunt = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshEmprunt();
    _loop();
  }

  final TextEditingController _quantiteController = TextEditingController();

  void _showForm(int id) async {
    if (id != null) {
      final existingMembre =
          _emprunt.firstWhere((element) => element['id'] == id);
      _quantiteController.text = (existingMembre['quantite']).toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DropdownButtonFormField(
                      value: this.composant,
                      hint: Text(
                        'Choose a composant',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          this.composant = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          this.composant = value;
                        });
                      },
                      validator: (value) {
                        if (value.nom.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: _composants.map((Composant val) {
                        return DropdownMenuItem(
                          value: val.nom,
                          child: Text(
                            val.nom,
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButtonFormField(
                      value: this.membre,
                      hint: Text(
                        'choose a membre',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          this.membre = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          this.membre = value;
                        });
                      },
                      validator: (value) {
                        if (value.nom.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: _membres.map((Membre val) {
                        return DropdownMenuItem(
                          value: val.nom,
                          child: Text(
                            val.nom,
                          ),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _quantiteController,
                      decoration: const InputDecoration(hintText: 'Quantite'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addItem();
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> _addItem() async {
    int id_composant = await StockDB.instance.getComposantByName(composant);
    int id_membre = await StockDB.instance.getMembreByName(membre);
    String date = convert(DateTime.now());

    Emprunt emprunt = new Emprunt(
        id_composant, id_membre, int.parse(_quantiteController.text), date, 0);
    int res = await StockDB.instance.insertEmprunt(emprunt);
    if (res == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully added a emprunt !'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur !'),
      ));
    }

    _refreshEmprunt();
  }

  void _deleteItem(int id) async {
    StockDB.instance.supprimerEmprunt(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a emprunt !'),
    ));
    _refreshEmprunt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprunts'),
      ),
      body: ListView.builder(
        itemCount: _emprunt.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(
                "Emprunt n° : " +
                    (_emprunt[index]['id']).toString() +
                    "\nMembre : " +
                    (_emprunt[index]['prenom']).toString() +
                    "(" +
                    (_emprunt[index]['tel']).toString() +
                    ")\nComposant : " +
                    (_emprunt[index]['nom']).toString() +
                    "\nquantite : " +
                    (_emprunt[index]['quantite']).toString() +
                    "\n" +
                    (_emprunt[index]['dateEmprunt']),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_emprunt[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
