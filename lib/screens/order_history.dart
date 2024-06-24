import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../data/cart_provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../models/order_model.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class OrderItem extends StatelessWidget {
  final OrderModel order;
  const OrderItem(this.order, {Key? key}) : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Order ID: ${order.id}', style: textStyle.titleMedium),
            subtitle: Text(
              'Total: IDR ${order.amount.toStringAsFixed(2).replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match match) => '${match[1]}.',
                  )}',
            ),
            trailing:
                Text(DateFormat('yyyy-MM-dd – kk:mm').format(order.dateTime)),
          ),
          ExpansionTile(
            title: Text('View Items (${order.items.length})'),
            children: order.items.map((item) {
              return ListTile(
                title: Text(item['name']),
                subtitle: Text('Quantity: ${item['quantity']}'),
                trailing: Text(
                    'IDR ${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this order?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );
                if (confirm) {
                  cartProvider.deleteOrder(order);
                }
              },
              child: const Text('Delete Order'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderModel> _orders = [];
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('User UID: ${user?.uid}'); // Log the user's UID

      if (user != null) {
        final ordersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('dateTime',
                descending: true) // Order by dateTime descending
            .get();

        print('Orders Snapshot: $ordersSnapshot'); // Log the snapshot

        setState(() {
          _orders = ordersSnapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
          _isLoading = false;
        });
      } else {
        print('No user logged in');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching orders: $error');
      // TODO: Show a SnackBar with an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;
    final cart = Provider.of<CartProvider>(context);

    Widget buildOrderItem(OrderModel order) {
      return Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(10.0),
        child: ExpansionTile(
          title: Text('Order ID: ${order.id}', style: textStyle.titleMedium),
          subtitle: Text(
            'Total: IDR ${order.amount.toStringAsFixed(2).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match match) => '${match[1]}.',
                )}',
          ),
          trailing:
              Text(DateFormat('yyyy-MM-dd – kk:mm').format(order.dateTime)),
          children: order.items.map((item) {
            return ListTile(
              title: Text(item['name']), // Access name as item['name']
              subtitle: Text(
                  'Quantity: ${item['quantity']}'), // Access quantity as item['quantity']
              trailing: Text(
                  'IDR ${(item['price'] * item['quantity']).toStringAsFixed(2)}'), // Calculate and display total price
            );
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceVariant,
        title: Center(
          child: Text(
            'Order History',
            style: textStyle.titleLarge!.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        // Add FutureBuilder for order updates
        future: cart.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<OrderModel> orders = snapshot.data ?? [];
            return orders.isEmpty
                ? Center(
                    child: Text(
                      "You have not ordered anything yet",
                      style: textStyle.titleMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orders[
                        i]), // Use OrderItem here instead of buildOrderItem
                  );
          }
        },
      ),
    );
  }
}