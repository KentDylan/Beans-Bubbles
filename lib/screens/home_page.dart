import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:Beans_and_Bubbles/screens/menu_list.dart';
import '../widgets/wish_list_widget.dart';
import 'package:provider/provider.dart';
import '../data/color_provider.dart';
import 'carwash.dart';
import 'carwash_dupe.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600; // Determine if the screen is small

    // Define text styles
    var textStyle = isSmallScreen
        ? Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.orange,
              fontSize: 20,
            )
        : Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.orange,
              fontSize: 24,
            );

    var morgenStyle = isSmallScreen
        ? Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.orange,
              fontFamily: 'Morgenlicht',
              fontSize: 20,
            )
        : Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.orange,
              fontSize: 24,
              fontFamily: 'Morgenlicht',
            );

    // Define container width and height
    var containerWidth = isSmallScreen ? 160.0 : 180.0;
    var containerHeight = isSmallScreen ? 70.0 : 80.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('Enjoy your coffee break', style: morgenStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('while we clean your car.', style: morgenStyle),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarWashPageDupe()),
                      );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Clean Your Car', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                                Container(
                width: containerWidth,
                height: containerHeight,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuList()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Grab Your Order', style: TextStyle(color: Colors.white)),
                ),
              ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: isSmallScreen ? 340.0 : 380.0,
                  height: 50.0,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Add search logic here
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Text(
                  'Appointment',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: isSmallScreen ? 340 : 380,
                  height: isSmallScreen ? 160 : 200,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/img/bg_blue1.png'), // Ganti dengan path gambar Anda
                    fit: BoxFit.cover, // Sesuaikan dengan kebutuhan
                  ),
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You Don\'t Have Any Appointment',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: isSmallScreen ? 5 : 10),
                      ElevatedButton(
                        onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarWashPageDupe()),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Book Now'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 15 : 20),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Text(
                  'Today\'s Offers',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent, // Menangkap interaksi tap di area transparan
                  onTap: () {
                    // Tambahkan logika atau fungsi yang ingin Anda jalankan saat button ditekan
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Informasi'),
                        content: Text('Silahkan masukkan kode diskon \n\'Devressed\'\n pada pembayaran.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog saat tombol ditekan
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: isSmallScreen ? 340 : 380,
                    height: isSmallScreen ? 160 : 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/disc_orang.png'), // Ganti dengan path gambar Anda
                        fit: BoxFit.cover, // Sesuaikan dengan kebutuhan
                      ),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add this to make space at the bottom
              // Add other widgets here
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent, // Menangkap interaksi tap di area transparan
                  onTap: () {
                    // Tambahkan logika atau fungsi yang ingin Anda jalankan saat button ditekan
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Informasi'),
                        content: Text('Silahkan masukkan kode diskon \n\'Devressed\'\n pada menu carwash.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog saat tombol ditekan
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: isSmallScreen ? 340 : 380,
                    height: isSmallScreen ? 160 : 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/disc_blue.png'), // Ganti dengan path gambar Anda
                        fit: BoxFit.cover, // Sesuaikan dengan kebutuhan
                      ),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
