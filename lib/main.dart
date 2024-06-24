import 'package:BeaBubs/data/CarWashOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'data/wishlist_provider.dart';
import 'data/cart_provider.dart';
import 'data/color_provider.dart';
import 'main_page.dart'; // Ganti dengan nama file yang sesuai
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/profile_page.dart'; // Import the ProfilePage class
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => CarWashOrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorProvider = context.watch<ColorProvider>();

    return MaterialApp(
      title: 'Beans & Bubbles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'CircularStd',
        colorScheme: ColorScheme.fromSeed(seedColor: colorProvider.currentColor),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          headlineSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
          displayLarge: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/splash', // Tentukan halaman awal
      routes: {
        '/splash': (context) => SplashScreen(),
        '/main': (context) => LoginApp(),
        // Tambahkan rute untuk halaman lain di sini
      },
    );
  }
}
