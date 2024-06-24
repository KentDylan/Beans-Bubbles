import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final DateTime dateTime;
  final List<Map<String, dynamic>> items; // Store cart items as Map

  OrderModel({
    required this.id,
    required this.dateTime,
    required this.items,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      items: List<Map<String, dynamic>>.from(
          data['items']), // Directly use the Map
    );
  }

  double get amount =>
      items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  Map<String, dynamic> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'items': items, // Store as a list of Maps
    };
  }
}