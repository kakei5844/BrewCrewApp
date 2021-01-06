import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/screens/home/clearButton.dart';
import 'package:brewcrew/screens/home/settings.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brewcrew/screens/home/brew_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Future _showBottomSheet() {
      return showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
          child: SettingForm(),
        );
      });
    }

    User user = Provider.of<User>(context);

    return StreamProvider<List<Brew>>.value(
        initialData: List(),
      value: DatabaseService().brew,
      child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            backgroundColor: Colors.brown[400],
            title: Text("Brew Crew"),
            actions: [
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Sign out"),
              ),
              FlatButton.icon(
                onPressed: _showBottomSheet,
                icon: Icon(Icons.settings),
                label: Text("Setting"),
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/coffee_bg.png'), fit:BoxFit.cover,)
            ), 
              child: BrewList()
          ),
        floatingActionButton: ClearButton(),
        ),
      );
  }
}
