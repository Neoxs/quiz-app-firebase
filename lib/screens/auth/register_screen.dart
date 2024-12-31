// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';
  String error = '';
  File? avatarImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => avatarImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: Text('Sign up', style: TextStyle(color: Colors.lightBlue[50])),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: avatarImage != null ? FileImage(avatarImage!) : null,
                    child: avatarImage == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600])
                        : null,
                  ),
                ),
                SizedBox(height: 20.0),
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
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var result = await _auth.signUp(email, password);
                      if (result == null) {
                        setState(() => error = 'Please supply a valid email');
                      } else if (avatarImage != null) {
                        String avatarUrl = await _storage.uploadAvatar(
                          avatarImage!,
                          result.user!.uid,
                        );
                        // Update user profile with avatar URL
                        // ... Update Firestore user document
                        Navigator.pushReplacementNamed(context, '/quiz');
                      }
                    }
                  },
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                TextButton(
                  child: Text('Already have an account? Sign in'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}