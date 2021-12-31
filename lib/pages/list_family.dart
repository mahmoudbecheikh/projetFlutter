import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Famille.dart';

class ListFamily extends StatefulWidget {
  const ListFamily({Key key}) : super(key: key);

  @override
  _ListFamilyState createState() => _ListFamilyState();
}

class _ListFamilyState extends State<ListFamily> {
  List<Map<String, dynamic>> _familles = [];

  void _refreshFamily() async {
    final data = await StockDB.instance.ListFamille();
    setState(() {
      _familles = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFamily();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int id) async {
    if (id != null) {
      final existingFamily =
          _familles.firstWhere((element) => element['id'] == id);
      _titleController.text = existingFamily['nom'];
      ;
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 175,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'nom'),
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

                        _titleController.text = '';

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
    Famille famille = new Famille(_titleController.text);
    StockDB.instance.insertFamille(famille);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a family !'),
    ));
    _refreshFamily();
  }

  Future<void> _updateItem(int id) async {
    StockDB.instance.modifierFamille(id, _titleController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated a family !'),
    ));
    _refreshFamily();
  }

  void _deleteItem(int id) async {
    StockDB.instance.supprimerFamille(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a family !'),
    ));
    _refreshFamily();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Familles'),
      ),
      body: ListView.builder(
        itemCount: _familles.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(
                (_familles[index]['id']).toString() +
                    " " +
                    _familles[index]['nom'],
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
                      onPressed: () => _showForm(_familles[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_familles[index]['id']),
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
