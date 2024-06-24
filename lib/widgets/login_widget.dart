import 'package:flutter/material.dart';
import '../screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';

class LoginWidget extends StatefulWidget {
  final Function(String, String) onLogin;

  LoginWidget({required this.onLogin});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late String email;
  late String password;
  bool rememberMe = false;
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;
    var padding = EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 25, vertical: 10);
    var buttonHeight = isSmallScreen ? 45.0 : 50.0;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Container(
        color: Colors.white,
        padding: padding,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: isSmallScreen ? 500 : 600,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: _obscurePassword,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = await _authService.loginUser(email, password);
                      if (user != null) {
                        widget.onLogin(email, password);
                      } else {
                        // Tampilkan pesan error jika login gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid email or password'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      minimumSize: Size(double.infinity, buttonHeight),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Text(
                      //     "or continue with",
                      //     style: TextStyle(color: Colors.grey[600]),
                      //   ),
                      // ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Add your Google login logic here
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.grey,
                  //     minimumSize: Size(double.infinity, buttonHeight),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       ImageIcon(
                  //         AssetImage("assets/icon/google_icon.png"),
                  //         color: Colors.white,
                  //         size: isSmallScreen ? 20.0 : 24.0,
                  //       ),
                  //       SizedBox(width: 8.0),
                  //       Text(
                  //         'Google',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Haven't sign up yet?",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrationPage()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
