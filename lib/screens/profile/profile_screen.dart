// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storage = StorageService();
  File? _newAvatarImage;

  Future<void> _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    
    if (image != null) {
      setState(() => _newAvatarImage = File(image.path));
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserProvider>();
      
      try {
        String avatarUrl = await _storage.uploadAvatar(
          _newAvatarImage!,
          authProvider.user!.uid,
        );
        
        // Update the user's profile with the new avatar URL
        await authProvider.user?.updatePhotoURL(avatarUrl);

        // Update Firestore user document
        await userProvider.updateProfile(avatarUrl: avatarUrl);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, _) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final user = authProvider.user;
          final userModel = userProvider.userModel;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  color: Colors.indigo[800],
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: _newAvatarImage != null 
                                  ? FileImage(_newAvatarImage!)
                                  : (userModel?.avatarUrl != null 
                                    ? NetworkImage(userModel!.avatarUrl!) as ImageProvider
                                    : null),
                                child: userModel?.avatarUrl == null && _newAvatarImage == null
                                  ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                                  : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.indigo[800]!, width: 2),
                                ),
                                child: InkWell(
                                  onTap: _updateProfileImage,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.indigo[800],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          userModel?.email ?? user?.email ?? 'No Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // User Info Card
                Container(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildInfoRow(
                            icon: Icons.email,
                            label: 'Email',
                            value: user?.email ?? 'Not available',
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: 'Member Since',
                            value: user?.metadata.creationTime?.toString().split(' ')[0] ?? 
                                  'Not available',
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.star,
                            label: 'High Score',
                            value: '${userModel?.highScore ?? 0} points',
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.palette,
                            label: 'Preferred Theme',
                            value: userModel?.preferredTheme?.capitalize() ?? 'General',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.indigo[800],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 24,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}