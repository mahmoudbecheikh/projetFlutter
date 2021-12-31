import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_projet/widgets/drawer_widget.dart';

class HomePage extends StatelessWidget {
  Material myItems(IconData icon, String title, String route, int color,
      BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, route);
                        },
                        child: new Text(
                          title,
                          style: TextStyle(
                              fontSize: 20,
                              color: new Color(color),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                      )),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          myItems(
              Icons.border_all, "Familles", "/famille", 0xffff6E40, context),
          myItems(Icons.workspaces_filled, "Composants ", "/composant",
              0xff6a1b9a, context),
          myItems(
              Icons.event_note, "Emprunts", "/emprunt", 0xff00e676, context),
          myItems(Icons.web_asset_off, "Non retourne", "/composantNoRetourne",
              0xfff50057, context),
          myItems(Icons.wifi_protected_setup, "Retour", "/retour", 0xff0091ea,
              context),
          myItems(Icons.person, "Membres", "/membre", 0xff006064, context)
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 110.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(2, 130.0),
        ],
      ),
      drawer: Mydrawer(),
    );
  }
}
