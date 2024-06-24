import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:BeaBubs/screens/menu_list.dart';
import '../widgets/wish_list_widget.dart';
import 'package:provider/provider.dart';
import '../data/color_provider.dart';
import 'carwash.dart';
import 'carwash_dupe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_wash_order.dart'; // Adjust the import path accordingly
import '../auth/auth_service.dart'; // Adjust the import path accordingly
import 'car_wash_order_detail_page.dart'; // Adjust the import path accordingly
import 'package:intl/intl.dart'; // Add this import

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CarWashOrder> _todayCarWashOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodayAppointments();
  }

  Future<void> _fetchTodayAppointments() async {
    try {
      String userId = AuthService().getCurrentUserId();
      String todayDate = DateFormat('MMM dd, yyyy').format(DateTime.now()); // Format today's date

      print("Fetching appointments for user: $userId on date: $todayDate");

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('carwash_orders')
          .where('date', isEqualTo: todayDate)
          .get();

      setState(() {
        _todayCarWashOrders = snapshot.docs
            .map((doc) => CarWashOrder.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        _loading = false;
      });

      print("Fetched ${_todayCarWashOrders.length} appointments for today.");
      _todayCarWashOrders.forEach((order) {
        print("Order: ${order.id}, Date: ${order.date}, Time: ${order.time}");
      });
    } catch (e) {
      print('Error fetching today\'s car wash orders: $e');
      setState(() {
        _loading = false;
      });
    }
  }

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
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
                      : _todayCarWashOrders.isEmpty
                          ? Column(
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
                            )
                            :ListView.builder(
                              itemCount: _todayCarWashOrders.length,
                              itemBuilder: (context, index) {
                                CarWashOrder order = _todayCarWashOrders[index];
                                return ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Order ID: ${order.id}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 15), // SizedBox added here
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${order.date}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Time: ${order.time}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Car Type: ${order.carType}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Wash Type: ${order.washType}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Total Cost: IDR ${order.totalCost}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CarWashOrderDetailPage(order: order),
                                      ),
                                    );
                                  },
                                );
                              },
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
