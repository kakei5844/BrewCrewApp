import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final List<String> sugars = ['0','1','2','3','4'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // declare the current name, sugars and strength
  String _currentName;
  String _currentSugars;
  int _currentStrength;
  int _currentCups;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Update your brew settings", style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 15.0),
                  TextFormField(
                  initialValue: userData.name,
                    validator: (val) => val.isEmpty? 'Please input a name' : null,
                    decoration: TextFormFieldDecoration,
                    onChanged: (val) {
                      setState(() {
                        _currentName = val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: _currentSugars ?? userData.sugars,
                    decoration: TextFormFieldDecoration,
                    items: sugars.map((sugar) => DropdownMenuItem(value: sugar, child: Text("$sugar sugar(s)"),)).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentSugars = val;
                      });
                    },
                  ),
                  Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      activeColor: Colors.brown[_currentStrength ?? userData.strength],
                      inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                      value: (_currentStrength ?? userData.strength).toDouble(),
                      onChanged: (val) {setState(() {
                        _currentStrength = val.round();
                      });}
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          setState(() {
                            if (_currentCups != null) {
                              _currentCups++;
                            }
                            else {
                              _currentCups = userData.cups + 1;
                            }
                          });
                        },
                        child: new Icon(Icons.add, color: Colors.black,),
                        backgroundColor: Colors.white,),

                      new Text('${_currentCups ?? userData.cups}',
                          style: new TextStyle(fontSize: 16.0)),

                      new FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          setState(() {
                            if (_currentCups != null) {
                              if (_currentCups != 0)
                                _currentCups--;
                            }
                            else {
                              _currentCups = userData.cups - 1;
                            }
                          });
                        },
                        child: new Icon(
                            const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                            color: Colors.black),
                        backgroundColor: Colors.white,),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentName?? userData.name,
                            _currentSugars?? userData.sugars,
                            _currentStrength?? userData.strength,
                            _currentCups?? userData.cups,
                        );
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.pink,
                    child: Text("Update", style: TextStyle(color: Colors.white,),),
                  )
                ],),
            ),
          );
        }
          else {
            return Loading();
        }
      }
    );
      }
  }
