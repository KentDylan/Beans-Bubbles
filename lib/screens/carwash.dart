import 'package:flutter/material.dart';
import '../widgets/carwash_widget.dart'; // Import carwash widget

class CarWashPage extends StatelessWidget {
  const CarWashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600; // Determine if the screen is small
    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: true, // Adjust behavior when keyboard appears

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Widget lain di atas CarWashWidget
            SizedBox(height: isSmallScreen ? 30 : 100), // Space added to move the white box up
            Container(
              padding: EdgeInsets.fromLTRB(40, isSmallScreen ? 50 : 70, 0, 0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Beans & Bubbles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, // This will dynamically change based on screen size
                  fontFamily: 'Morgenlicht',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0), // Adjusted padding to add space
              alignment: Alignment.centerLeft,
              child: const Text(
                'Clean Car, Fresh Brew!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // This will dynamically change based on screen size
                  fontFamily: 'Morgenlicht',
                ),
              ),
            ),

            // Space added between text and CarWashWidget
            SizedBox(height: 30),

            // CarWashWidget berada di bagian bawah
            const CarWashWidget(), // Call carwash widget
          ],
        ),
      ),
    );
  }
}
