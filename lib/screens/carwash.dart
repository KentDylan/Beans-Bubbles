import 'package:flutter/material.dart';
import '../widgets/carwash_widget.dart'; // Import carwash widget


class CarWashPage extends StatelessWidget {
  const CarWashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600; // Determine if the screen is small
    return Scaffold(
      backgroundColor: Colors.blue,
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Widget lain di atas CarWashWidget
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 40.0),
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
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
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
              ],
            ),
          ),

          // CarWashWidget berada di bagian bawah
          const CarWashWidget(), // Call carwash widget
        ],
      ),
    );
  }
}
