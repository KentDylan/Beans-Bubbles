import 'package:flutter/material.dart';
import 'package:BeaBubs/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  _navigateToMain() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromRGBO(248,116,4, 1.0),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    colorScheme.onInverseSurface,
                    BlendMode.modulate,
                  ),
                  child: Container(
                    height: 90,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icon/logo_tanpa_nama.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(20.0),
            child: Text(
              '@Devressed',
              style: textStyle.displayLarge!.copyWith(
                color: Colors.white,
                fontSize: 14, // Atur ukuran font di sini
                fontFamily: 'Morgenlicht', // Ganti dengan nama font family yang Anda inginkan
                fontWeight: FontWeight.normal, // Menjadikan teks tidak tebal
              ),
            ),
          ),
        ),
      ],
    );
  }
}
