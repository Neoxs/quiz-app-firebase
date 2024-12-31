// lib/screens/quiz/add_question_screen.dart
import 'package:flutter/material.dart';
import 'package:quiz_app_firebase/services/auth_service.dart';
import 'package:quiz_app_firebase/widgets/user_avatar.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../models/question.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  
  String questionText = '';
  bool isCorrect = false;
  File? imageFile;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => imageFile = File(image.path));
    }
  }

  Future<void> _submitQuestion() async {
    if (_formKey.currentState!.validate() && imageFile != null) {
      setState(() => isLoading = true);
      try {
        String imageUrl = await _storageService.uploadImage(
          imageFile!,
          DateTime.now().toString(),
        );
        
        Question question = Question(
          questionText: questionText,
          isCorrect: isCorrect,
          imageUrl: imageUrl,
        );
        
        await _firestoreService.addQuestion(question);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding question: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Question', style: TextStyle(color: Colors.lightBlue[50])),
        actions: [
          UserAvatar(
            avatarUrl: _authService.currentUser?.photoURL,
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.lightBlue[50]),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        backgroundColor: Colors.indigo[800],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Question Text',
                                  labelStyle: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFF64B5F6)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFF64B5F6).withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFF64B5F6), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (val) => val!.isEmpty ? 'Please enter question text' : null,
                                onChanged: (val) => setState(() => questionText = val),
                                maxLines: 3,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFF64B5F6).withOpacity(0.5)),
                                ),
                                child: SwitchListTile(
                                  title: Text(
                                    'Correct Answer',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  value: isCorrect,
                                  onChanged: (bool value) => setState(() => isCorrect = value),
                                  activeColor: Color(0xFF64B5F6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                      onPressed: _pickImage,
                    ),
                    if (imageFile != null) ...[
                      SizedBox(height: 10),
                      Image.file(
                        imageFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.indigo[800],
                      ),
                      child: Text('Submit Question', style: TextStyle(color: Colors.white)),
                      onPressed: _submitQuestion,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}