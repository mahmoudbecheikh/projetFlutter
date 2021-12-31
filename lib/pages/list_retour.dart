import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projet/models/Emprunt.dart';
import 'package:flutter_projet/models/Retour.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projet/db/database.dart';

class ListRetour extends StatefulWidget {
  const ListRetour({Key key}) : super(key: key);

  @override
  _ListRetourState createState() => _ListRetourState();
}

class _ListRetourState extends State<ListRetour> {
  List<Map<String, dynamic>> _retours = [];
  List<DropdownMenuItem<String>> _emprunt = [];
  String valueEmprunt;
  String valueEtat;
  int id = 1;

  loadEmprunt() async {
    List<Map<String, dynamic>> emprunts = await StockDB.instance.ListEmp();
    emprunts.forEach((emprunt) {
      setState(() {
        _emprunt.add(DropdownMenuItem(
          child: Text("Emprunt n°${(emprunt['id']).toString()}"),
          value: emprunt['dateEmprunt'],
        ));
      });
    });
  }

  String convert(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void _refreshRetours() async {
    final data = await StockDB.instance.ListRetour();

    setState(() {
      _retours = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshRetours();
    loadEmprunt();
  }

  void _showForm(int id) async {
    if (id != null) {}

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
                      value: this.valueEmprunt,
                      hint: Text(
                        'Emprunt',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          this.valueEmprunt = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          this.valueEmprunt = value;
                        });
                      },
                      items: _emprunt,
                    ),
                    DropdownButtonFormField(
                      value: this.valueEtat,
                      hint: Text(
                        'Etat',
                      ),
                      isExpanded: true,
                      onChanged: (String value) {
                        setState(() {
                          this.valueEtat = value;
                        });
                      },
                      onSaved: (String value) {
                        setState(() {
                          this.valueEtat = value;
                        });
                      },
                      items: ["intact", "endommagé", "gravement endommagé"]
                          .map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
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
    String date = convert(DateTime.now());
    int id = await StockDB.instance.getEmpruntByDate(valueEmprunt);
    Retour retour = new Retour(id, valueEtat, date);
    int res = await StockDB.instance.inserRetour(retour);

    if (res == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully added a return !'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur !'),
      ));
    }

    _refreshRetours();
  }

  void _deleteItem(int id) async {
    StockDB.instance.ListComposantNoRetourne();
    StockDB.instance.SupprimerRetour(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a return !'),
    ));
    _refreshRetours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retours'),
      ),
      body: ListView.builder(
        itemCount: _retours.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(
                "Retour emprunt n°" +
                    (_retours[index]['id_emprunt']).toString() +
                    "\nEtat :" +
                    _retours[index]['etat'] +
                    "\nDate retour :" +
                    _retours[index]['dateRetour'],
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
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_retours[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_retours[index]['id']),
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
