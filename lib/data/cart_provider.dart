import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart' as OrderModel;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/menu_model.dart';

class CartProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add authentication
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Cart> _cart = [];
  List<Cart> get cart => _cart;

  int _counter = 0;
  int get counter => _counter;
  double get totalPrice => _cart.fold(
      0.0, (sum, item) => sum + item.totalPrice); // Calculate on the fly

  final List<OrderModel.OrderModel> _orders = [];
  List<OrderModel.OrderModel> get orders => [..._orders];

  Future<void> getData() async {
    // Get the authenticated user's ID
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot cartSnapshot = await firestore
          .collection('users')
          .doc(user.uid) // Use the user's UID
          .collection('cart')
          .get();

      List<Cart> newCart = cartSnapshot.docs.map((cartDoc) {
        Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
        return Cart.fromFirestore(
            cartData, cartDoc.id); // No need to fetch from menu_items
      }).toList();

      _cart = newCart;
      _calculateCounters();
      notifyListeners();
    }
  }

  Future<void> addToCart(MenuModel item, int quantity) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Check if the item is already in the cart
        int existingIndex =
            _cart.indexWhere((cartItem) => cartItem.itemId == item.id);

        if (existingIndex != -1) {
          // If item exists, update its quantity
          _cart[existingIndex].quantity.value += quantity;
          await firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(_cart[existingIndex].id)
              .update({'quantity': _cart[existingIndex].quantity.value});
        } else {
          // If item doesn't exist, add it to the cart
          DocumentReference cartItemRef = await firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .add(Cart(
                id: '', // Firestore will generate an ID
                itemId: item.id,
                name: item.name,
                quantity: ValueNotifier(quantity),
                price: item.price.toDouble(),
                image: item.imageUrl,
              ).toMap());

          // Update the local cart with the generated ID
          _cart.add(Cart(
            id: cartItemRef.id, // Set the ID after adding
            itemId: item.id,
            name: item.name,
            quantity: ValueNotifier(quantity),
            price: item.price.toDouble(),
            image: item.imageUrl,
          ));
        }

        _calculateCounters();
        notifyListeners();
      } catch (error) {
        // Handle errors (e.g., show a SnackBar or log the error)
        print('Error adding to cart: $error');
      }
    } else {
      // Handle the case where the user is not authenticated
      print('User not authenticated. Cannot add to cart.');
    }
  }

  // ... (addOrder, clearCart, _setPrefsItems, and _getPrefsItems remain the same)

  void _calculateCounters() {
    _counter = _cart.fold(0, (sum, item) => sum + item.quantity.value);
    _setPrefsItems();
    notifyListeners();
  }

  // ... (The rest of the code - addQuantity, removeItem, and deleteQuantity) are updated to use itemId instead of menuId.
  void addQuantity(String id) {
    final index = _cart.indexWhere((element) => element.id == id);
    _cart[index].quantity.value++;
    firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .doc(id)
        .update({'quantity': _cart[index].quantity.value});
    _calculateCounters();
    notifyListeners();
  }

  void deleteQuantity(String id) {
    final index = _cart.indexWhere((element) => element.id == id);
    if (_cart[index].quantity.value > 1) {
      _cart[index].quantity.value--;
      firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(id)
          .update({'quantity': _cart[index].quantity.value});
      _calculateCounters();
    }
    notifyListeners();
  }

  void removeItem(String id) {
    final index = _cart.indexWhere((element) => element.id == id);
    if (index != -1) {
      _counter -= _cart[index].quantity.value;
      _cart.removeAt(index);
      firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(id)
          .delete();
      _calculateCounters();
      notifyListeners();
    }
  }

  // void _calculateTotalPrice() {
  //   _totalPrice = _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  //   notifyListeners();
  // }

  void clearCart() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Delete all cart items from Firestore
        QuerySnapshot cartSnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

        for (var cartDoc in cartSnapshot.docs) {
          await cartDoc.reference.delete();
        }

        _cart.clear();
        _counter = 0;
        _setPrefsItems();
        notifyListeners();
      } catch (error) {
        // Handle errors (e.g., show a SnackBar or log the error)
        print('Error clearing cart: $error');
      }
    } else {
      // Handle the case where the user is not authenticated
      print('User not authenticated. Cannot clear cart.');
    }
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    // No need to store totalPrice anymore, as it's calculated
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    // No need to retrieve totalPrice, as it's calculated
  }

  void addOrder() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final orderData = OrderModel.OrderModel(
          id: '', // No need for orderId here
          dateTime: DateTime.now(),
          items:
              cart.map((item) => item.toMap()).toList(), // Convert Cart to Map
        );

        // Add the order to Firestore (let Firestore generate the ID)
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .add(orderData.toMap());

        // Clear the local cart after the order is placed
        clearCart();
      } catch (error) {
        print('Error adding order: $error');
      }
    } else {
      print('User not authenticated. Cannot add order.');
    }
  }

  Future<List<OrderModel.OrderModel>> fetchOrders() async {
    try {
      final user = _auth.currentUser;
      print('User UID: ${user?.uid}'); // Log the user's UID

      if (user != null) {
        final ordersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('dateTime', descending: true) // Order by dateTime descending
            .get();

        print('Orders Snapshot: $ordersSnapshot'); // Log the snapshot

        List<OrderModel.OrderModel> orders = ordersSnapshot.docs
            .map((doc) => OrderModel.OrderModel.fromFirestore(doc))
            .toList();
        return orders;
      }
      return []; // If there is no logged-in user
    } catch (error) {
      print('Error fetching orders: $error');
      return [];
    }
  }


  Future<void> deleteOrder(OrderModel.OrderModel order) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Delete the order from Firestore
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(order.id)
            .delete();

        // Remove the order from the local list
        _orders.removeWhere((o) => o.id == order.id);
        notifyListeners();
      } catch (error) {
        print('Error deleting order: $error');
        // TODO: Show a SnackBar with an error message
      }
    }
  }
}