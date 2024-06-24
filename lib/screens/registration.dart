import 'package:flutter/material.dart';
import 'package:BeaBubs/widgets/regis_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';
import 'login_page.dart';

class RegistrationPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: isSmallScreen ? 50 : 100), // Space added to move the white box up
            Padding(
              padding: EdgeInsets.fromLTRB(40, isSmallScreen ? 50 : 70, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Beans & Bubbles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 25 : 35,
                    fontFamily: 'Morgenlicht',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Clean Car, Fresh Brew!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 15 : 18,
                    fontFamily: 'Morgenlicht',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            RegistrationWidget(
              onRegister: (fullName, email, phoneNo, password) {
                _handleRegistration(fullName, email, phoneNo, password, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegistration(String fullName, String email, String phoneNo, String password, BuildContext context) async {
    try {
      await _authService.registerUser(email, password, fullName, phoneNo);
      // Show registration success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful. You can now log in.'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate to login page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error registering user: $e');
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
