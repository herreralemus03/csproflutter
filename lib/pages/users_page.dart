import 'package:boletas_app/pages/user_details_page.dart';
import 'package:boletas_app/providers/users_provider.dart';
import 'package:boletas_app/widgets/error_page.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersProvider usersProvider = UsersProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUPERVISORES"),
      ),
      body: Container(
        child: FutureBuilder<Map<String, dynamic>>(
          future: usersProvider.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorPage(
                message: "${snapshot.error}",
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data["content"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      child: Text(
                          "${snapshot.data["content"][index]["person"]["firstName"]}"
                              .substring(0, 1)),
                    ),
                    trailing: Icon(Icons.admin_panel_settings_sharp),
                    title: Text(
                        "${snapshot.data["content"][index]["person"]["firstName"]} ${snapshot.data["content"][index]["person"]["lastName"]}"),
                    subtitle:
                        Text("${snapshot.data["content"][index]["username"]}"),
                    onTap: () => goToDetailsPage(
                        uuid: "${snapshot.data["content"][index]["uuid"]}"),
                  );
                },
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void goToDetailsPage({@required String uuid}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(
          provider: usersProvider,
          uuid: uuid,
        ),
      ),
    );
  }
}
