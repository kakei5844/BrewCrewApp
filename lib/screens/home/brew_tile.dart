import 'package:flutter/material.dart';
import 'package:brewcrew/models/brew.dart';

class BrewTile extends StatefulWidget {
  final Brew brew;
  BrewTile({this.brew});

  @override
  _BrewTileState createState() => _BrewTileState();
}

class _BrewTileState extends State<BrewTile> {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/coffee_icon.png'),
          backgroundColor: Colors.brown[widget.brew.strength],
          radius: 25.0,
        ),
        title: Text(widget.brew.name),
        subtitle: Text("Take ${widget.brew.sugars} sugar(s)"),
        trailing: Text("${widget.brew.cups}"),
      ),
    );
  }
}
