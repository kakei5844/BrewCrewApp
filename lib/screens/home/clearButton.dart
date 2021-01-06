import 'package:brewcrew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:brewcrew/models/brew.dart';
import 'package:provider/provider.dart';

class ClearButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>>(context);
    return FloatingActionButton(
      child: Text("CLEAR"),
      backgroundColor: Colors.pink,
      onPressed: () async {
        for (Brew brew in brews) {
          await DatabaseService(uid: brew.uid).updateUserData(
            brew.name,
            brew.sugars,
            brew.strength,
            0,
          );
        }
      },
    );
  }
}
