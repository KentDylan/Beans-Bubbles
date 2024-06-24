// car_wash_order_detail_page.dart
import 'package:flutter/material.dart';
import '../models/car_wash_order.dart';

class CarWashOrderDetailPage extends StatelessWidget {
  final CarWashOrder order;

  CarWashOrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Date: ${order.date}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Time: ${order.time}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Car Type: ${order.carType}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Wash Type: ${order.washType}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Total Cost: IDR ${order.totalCost}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
