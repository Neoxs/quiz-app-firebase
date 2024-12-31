// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: Text('Sign in', style: TextStyle(color: Colors.lightBlue[50])),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) => setState(() => email = val),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => password = val),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.indigo[800],
                ),
                child: Text('Sign In', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await _auth.signIn(email, password);
                    if (result == null) {
                      setState(() => error = 'Invalid credentials');
                    } else {
                      Navigator.pushReplacementNamed(context, '/quiz');
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
              TextButton(
                child: Text('Need an account? Register'),
                onPressed: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}