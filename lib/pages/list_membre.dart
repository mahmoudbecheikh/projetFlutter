import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Membre.dart';

class ListMembre extends StatefulWidget {
  const ListMembre({Key key}) : super(key: key);

  @override
  _ListMembreState createState() => _ListMembreState();
}

class _ListMembreState extends State<ListMembre> {
  List<Map<String, dynamic>> _membres = [];

  void _refreshMembre() async {
    final data = await StockDB.instance.ListMembre();
    setState(() {
      _membres = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMembre();
  }

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  void _showForm(int id) async {
    if (id != null) {
      final existingMembre =
          _membres.firstWhere((element) => element['id'] == id);
      _nomController.text = existingMembre['nom'];
      _prenomController.text = existingMembre['prenom'];
      _telController.text = (existingMembre['tel']).toString();
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
                    TextField(
                      controller: _nomController,
                      decoration: const InputDecoration(hintText: 'Nom'),
                    ),
                    TextField(
                      controller: _prenomController,
                      decoration: const InputDecoration(hintText: 'Prenom'),
                    ),
                    TextField(
                      controller: _telController,
                      decoration: const InputDecoration(hintText: 'Tel'),
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

                        if (id != null) {
                          await _updateItem(id);
                        }

                        _nomController.text = '';

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
    Membre membre = new Membre(_nomController.text, _prenomController.text,
        int.parse(_telController.text));
    StockDB.instance.insertMembre(membre);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a member !'),
    ));
    _refreshMembre();
  }

  Future<void> _updateItem(int id) async {
    StockDB.instance.modifierMembre(id, _nomController.text,
        _prenomController.text, int.parse(_telController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated a member !'),
    ));
    _refreshMembre();
  }

  void _deleteItem(int id) async {
    StockDB.instance.supprimerMembre(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a member !'),
    ));
    _refreshMembre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membres'),
      ),
      body: ListView.builder(
        itemCount: _membres.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(
                (_membres[index]['id']).toString() +
                    "- " +
                    (_membres[index]['nom']).toString() +
                    " " +
                    _membres[index]['prenom'] +
                    "\nTéléphone :" +
                    _membres[index]['tel'].toString(),
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
                      onPressed: () => _showForm(_membres[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_membres[index]['id']),
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
