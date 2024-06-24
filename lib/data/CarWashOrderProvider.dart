import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_wash_order.dart';

class CarWashOrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CarWashOrder> _carWashOrders = [];

  List<CarWashOrder> get carWashOrders => _carWashOrders;

  Future<void> getData(String phoneNo) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(phoneNo)
          .collection('carwash_orders')
          .get();

      _carWashOrders = snapshot.docs
          .map((doc) => CarWashOrder.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error getting carwash orders: $e');
    }
  }
}
