import 'package:boletas_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor),
              child: buildAppBar(),
              padding: EdgeInsets.only(top: 60),
            ),
            ...buildDrawerItems(buildItems()),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: buildHeader(),
            ),
            Expanded(
              flex: 2,
              child: buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, IconData> buildItems() {
    return Map.of(
      {
        "Diccionarios": Icons.collections_bookmark_rounded,
        "Equipos": Icons.group,
        "Clusters": Icons.account_tree_rounded,
        "Encuestas": Icons.assignment_rounded,
        "Dashboard": Icons.show_chart,
        "Sync": Icons.sync,
      },
    );
  }

  List<Widget> buildDrawerItems(Map<String, IconData> data) {
    return data
        .map(
          (key, value) => MapEntry(
              key,
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed("/${key.toLowerCase()}"),
                child: ListTile(
                  leading: Icon(value),
                  title: Text(key),
                ),
              )),
        )
        .values
        .toList();
  }

  List<Widget> buildGridItems(Map<String, IconData> data) {
    return data
        .map(
          (key, value) => MapEntry(
            key,
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed("/${key.toLowerCase()}"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    value,
                    color: Colors.black,
                  ),
                  Text(
                    key,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  Widget buildAppBar() {
    return ListTile(
      leading: Text(
        "{...}",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.white,
          fontSize: 40,
        ),
      ),
      title: Text(
        "FERNANDO HERRERA",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        "DEVELOPER",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Center(
        child: ListTile(
          leading: FittedBox(
            fit: BoxFit.fill,
            child: DigestycLogo(),
          ),
          title: Text(
            "DIGESTYC",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          subtitle: Text(
            "Direccion General de Estadisticas y Censos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      children: buildGridItems(buildItems()),
    );
  }
}
