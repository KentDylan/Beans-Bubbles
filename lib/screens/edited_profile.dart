import 'package:flutter/material.dart';
import 'package:Beans_and_Bubbles/widgets/edited_profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';
import 'login_page.dart';

class EditedProfilePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 116, 4, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 116, 4, 1.0),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 25 : 35,
                      fontFamily: 'Morgenlicht',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // EditProfileWidget berada di bagian bawah
          EditProfileWidget(
            onUpdateProfile: (fullName, email, phoneNo, password) {
              _handleUpdateProfile(fullName, email, phoneNo, password, context);
            },
          ),
        ],
      ),
    );
  }

  void _handleUpdateProfile(String fullName, String email, String phoneNo, String password, BuildContext context) async {
    try {
      // Implement update profile logic here
      // For example, you can call a service to update user profile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate back to previous page after updating profile
      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile: $e');
      // Handle update profile errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
