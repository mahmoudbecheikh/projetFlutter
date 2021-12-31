import 'package:flutter/material.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Famille.dart';

class ListComposantNo extends StatefulWidget {
  const ListComposantNo({Key key}) : super(key: key);

  @override
  _ListComposantNoState createState() => _ListComposantNoState();
}

class _ListComposantNoState extends State<ListComposantNo> {
  List<Map<String, dynamic>> _composants = [];

  void _refreshFamily() async {
    final data = await StockDB.instance.ListComposantNoRetourne();
    setState(() {
      _composants = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFamily();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Composant Non retourné'),
      ),
      body: ListView.builder(
        itemCount: _composants.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(
                "Composant :" +
                    _composants[index]['nom'] +
                    "\nL'emprunteur :" +
                    _composants[index]['prenom'] +
                    "\nTéléphone :" +
                    (_composants[index]['tel']).toString() +
                    " ",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              trailing: SizedBox(
                width: 100,
              )),
        ),
      ),
    );
  }
}
