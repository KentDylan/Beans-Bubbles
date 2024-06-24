import 'package:cloud_firestore/cloud_firestore.dart';

class CarWashOrder {
  final String id;
  final String date;
  final String time;
  final String washType;
  final String carType;
  final int totalCost;

  CarWashOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.washType,
    required this.carType,
    required this.totalCost,
  });

  factory CarWashOrder.fromMap(Map<String, dynamic> map) {
    return CarWashOrder(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      washType: map['washType'],
      carType: map['carType'],
      totalCost: map['totalCost'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'washType': washType,
      'carType': carType,
      'totalCost': totalCost,
    };
  }

  factory CarWashOrder.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CarWashOrder(
      id: doc.id,
      date: data['date'],
      time: data['time'],
      washType: data['washType'],
      carType: data['carType'],
      totalCost: data['totalCost'],
    );
  }
}
