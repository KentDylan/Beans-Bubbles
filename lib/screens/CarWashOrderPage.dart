import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_wash_order.dart';
import '../auth/auth_service.dart';
import 'car_wash_order_detail_page.dart'; // Import the detail page

class CarWashOrderPage extends StatefulWidget {
  const CarWashOrderPage({Key? key}) : super(key: key);

  @override
  _CarWashOrderPageState createState() => _CarWashOrderPageState();
}

class _CarWashOrderPageState extends State<CarWashOrderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CarWashOrder> _carWashOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchCarWashOrders();
  }

  Future<void> _fetchCarWashOrders() async {
    try {
      String userId = AuthService().getCurrentUserId(); // Dapatkan userId dari AuthService
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('carwash_orders')
          .orderBy('date', descending: false) // Urutkan berdasarkan tanggal (asc)
          .get();

      setState(() {
        _carWashOrders = snapshot.docs
            .map((doc) => CarWashOrder.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching car wash orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Wash Orders'),
      ),
      body: _carWashOrders.isEmpty
          ? Center(
              child: Text('No car wash orders found.'),
            )
          : ListView.builder(
              itemCount: _carWashOrders.length * 2 - 1, // Menambahkan spasi untuk divider
              itemBuilder: (context, index) {
                if (index.isOdd) return Divider(); // Membuat divider setelah setiap ListTile

                final carWashOrderIndex = index ~/ 2;
                final order = _carWashOrders[carWashOrderIndex];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${order.date}'), // Menambahkan tanggal order
                      SizedBox(height: 10), // SizedBox added here                      
                      Text('Order ID: ${order.id}'),
                    ],
                  ),
                  subtitle: Text('Total Cost: IDR ${order.totalCost.toString()}'),
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
    );
  }
}
