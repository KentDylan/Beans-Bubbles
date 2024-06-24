import 'package:flutter/foundation.dart';

class Cart {
  final String id;
  final int itemId;  // Renamed for consistency
  final String name;
  final ValueNotifier<int> quantity;
  final double price;
  final String image;

  Cart({
    required this.id,
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory Cart.fromFirestore(Map<String, dynamic> data, String docId) {
    return Cart(
      id: docId,
      itemId: data['menu_id'],
      name: data['name'],
      quantity: ValueNotifier(data['quantity']),
      price: data['price'],
      image: data['image'],
    );
  }

  double get totalPrice => price * quantity.value; 

  Map<String, dynamic> toMap() {
    return {
      'menu_id': itemId,
      'name': name,
      'quantity': quantity.value,
      'price': price,
      'image': image,  // Consider using Firebase Storage for images
    };
  }
}