import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brewcrew/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  // Constructor
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';  // error message below the button

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Sign in to Brew Crew"),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggleView();
            }
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                decoration: TextFormFieldDecoration.copyWith(hintText: 'Email'),
                onChanged: (val) {
                  email = val;
                },
                validator: (val) => val.contains('@')? null : 'Please enter a valid email',
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: TextFormFieldDecoration.copyWith(hintText: 'Password'),
                onChanged: (val) {
                  password = val;
                },
                obscureText: true,
                validator: (val) => val.length >= 6 ? null : 'Password should contain 6 or more chars',
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                  color: Colors.pink[400],
                child: Text("Sign in",
                style: TextStyle(color: Colors.white,),),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = _auth.signInWithEmailPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Error signing in';
                        loading = false;
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0,)
                ,)
            ],),
        ),
      ),
    );
  }
}
