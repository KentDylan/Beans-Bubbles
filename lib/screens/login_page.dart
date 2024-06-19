import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Beans_and_Bubbles/widgets/login_widget.dart'; // Assuming this is your login widget
import '../auth/auth_service.dart';
import '../screens/profile_page.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 116, 4, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(248, 116, 4, 1.0),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                Container(
                  padding:
                      EdgeInsets.fromLTRB(40, isSmallScreen ? 50 : 70, 0, 0),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
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
              ],
            ),
          ),
          LoginWidget(
            onLogin: (email, password) {
              _handleLogin(email, password, context);
            },
          ),
        ],
      ),
    );
  }

  void _handleLogin(String email, String password, BuildContext context) async {
    User? user = await _authService.loginUser(email, password);
    if (user != null) {
      // Show login success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged in successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to ProfilePage after showing the SnackBar
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }
}
