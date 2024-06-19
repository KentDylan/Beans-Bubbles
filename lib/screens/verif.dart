import 'package:flutter/material.dart';
import '../widgets/verif_widget.dart';

void main() {
  runApp(VerificationCodeApp());
}

class VerificationCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verification Code Page',
      home: VerificationCodePage(),
    );
  }
}

class VerificationCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600; 
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 116, 4, 1.0), // Set background color to orange
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 116, 4, 1.0),
        automaticallyImplyLeading: true, // Tampilkan ikon back secara otomatis
        leading: IconButton( // Tambahkan ikon back di sini
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Widget lain di atas VerificationWidget
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(40, isSmallScreen ? 50 : 70, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verification Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 25 : 35,
                      fontFamily: 'Morgenlicht',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'We\'ve send the code to your email address!',
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

          // VerificationWidget berada di bagian bawah
          VerificationWidget(
            // Panggil verification widget dan teruskan fungsi onLogin
            onLogin: (code) { // Menggunakan satu argumen saja
              // Tambahkan logika verifikasi di sini
              print('Verification Code: $code');
            },
            defaultVerificationCode: '', // Atur nilai default kode verifikasi di sini
          ),
        ],
      ),
    );
  }
}
