import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projet/db/database.dart';
import 'package:flutter_projet/models/Composant.dart';
import 'package:flutter_projet/models/Famille.dart';
import 'package:google_fonts/google_fonts.dart';

class ListComposant extends StatefulWidget {
  const ListComposant({Key key}) : super(key: key);

  @override
  _ListComposantState createState() => _ListComposantState();
}

class _ListComposantState extends State<ListComposant> {
  List<Map<String, dynamic>> _composants = [];
  List<Famille> _familles = [];
  File _image;
  String _imageName;
  var valueFamille;
  bool showSearchBar = false;
  String searchValue;

  void _loop() async {
    List<Famille> familles = await StockDB.instance.ListFam();
    for (var item in familles) {
      _familles.add(item);
    }
  }

  Future getImageFromGallery() async {
    final myFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (myFile != null) {
        _image = File(myFile.path);
      }
    });
    uplaodImage();
  }

  Future uplaodImage() async {
    String base64 = base64Encode(_image.readAsBytesSync());
    setState(() {
      _imageName = base64;
    });
  }

  Image imageFromBase64String(String image) {
    return Image.memory(
      base64Decode(image),
      height: 60,
      width: 50,
    );
  }

  String convert(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void _refreshComposants() async {
    var data;
    if (searchValue != null) {
      data = await StockDB.instance.search(searchValue);
    } else {
      data = await StockDB.instance.ListComposant();
    }

    setState(() {
      _composants = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshComposants();
    _loop();
  }

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showForm(int id) async {
    if (id != null) {
      final existingComposant =
          _composants.firstWhere((element) => element['id'] == id);
      _nomController.text = existingComposant['nom'];
      _quantityController.text = (existingComposant['quantite']).toString();
      _imageController.text = existingComposant['image'];
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
                      decoration: const InputDecoration(hintText: 'nom'),
                    ),
                    TextField(
                        controller: _quantityController,
                        decoration: const InputDecoration(hintText: 'quantite'),
                        keyboardType: TextInputType.number),
                    DropdownButtonFormField(
                      value: this.valueFamille,
                      hint: Text(
                        'choose a famille',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          this.valueFamille = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          this.valueFamille = value;
                        });
                      },
                      validator: (value) {
                        if (value.nom.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: _familles.map((Famille val) {
                        return DropdownMenuItem(
                          value: val.nom,
                          child: Text(val.nom),
                        );
                      }).toList(),
                    ),
                    CupertinoActionSheetAction(
                      child: Text('Photo Gallery'),
                      onPressed: () {
                        getImageFromGallery();
                      },
                    ),
                    Container(
                        child: (_image == null)
                            ? Text("Image not selected")
                            : Image.file(_image)),
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

                        _imageController.text = '';
                        _nomController.text = '';
                        _quantityController.text = '0';

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
    int id_com = await StockDB.instance.getFamilleByName(valueFamille);

    Composant composant = new Composant(_nomController.text, _imageName,
        int.parse(_quantityController.text), id_com, 1, date);
    StockDB.instance.insertComposant(composant);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a composant !'),
    ));
    _refreshComposants();
  }

  Future<void> _updateItem(int id) async {
    int id_com = await StockDB.instance.getFamilleByName(valueFamille);
    String date = convert(DateTime.now());
    StockDB.instance.modifierComposant(id, _nomController.text, _imageName,
        int.parse(_quantityController.text), id_com, 1, date);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated a composant !'),
    ));
    _refreshComposants();
  }

  void _deleteItem(int id) async {
    StockDB.instance.supprimerComposant(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a composant !'),
    ));
    _refreshComposants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.showSearchBar
          ? null
          : AppBar(
              title: Text("Composants"),
              actions: <Widget>[
                IconButton(
                  tooltip: "Search",
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.showSearchBar = true;
                    });
                  },
                ),
              ],
            ),
      body: this.showSearchBar
          ? getSearchView()
          : ListView.builder(
              itemCount: _composants.length,
              itemBuilder: (context, index) => Card(
                color: Colors.blue[100],
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ListTile(
                    title: Container(
                      child: Row(
                        children: [
                          imageFromBase64String(_composants[index]['image']),
                          Text(
                            " " +
                                _composants[index]['nom'] +
                                "\n Quantite :" +
                                _composants[index]['quantite'].toString() +
                                "\n famille : " +
                                (_composants[index]['id_famille']).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(_composants[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_composants[index]['id']),
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

  Widget getSearchView({type}) {
    return Center(
      child: Container(
          child: Column(children: <Widget>[
        SizedBox(height: 30.0),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(children: <Widget>[
              Expanded(
                  child: TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search_off_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              )),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _refreshComposants();
                      this.showSearchBar = false;
                    });
                  }),
            ])),
      ])),
    );
  }
}
