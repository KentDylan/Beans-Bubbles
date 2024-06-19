import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'package:provider/provider.dart';
import '../data/cart_provider.dart';
import '../data/db_helper.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(order.id),
        subtitle: Text(
          'IDR. ${order.amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}',
        ),
        trailing: Text('${order.dateTime}'),
      ),
    );
  }
}

class _OrderHistoryState extends State<OrderHistory>
    with SingleTickerProviderStateMixin {
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  int selectedBottomNavIndex = 4;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surfaceVariant,
          title: Center(
            child: Text(
              'Order History',
              style: textStyle.displayMedium!.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        body: Consumer<CartProvider>(
          builder: (ctx, orderData, child) => orderData.orders.isEmpty
              ? Center(
                  child: Text(
                  "You have not ordered anything yet",
                  style: textStyle.labelMedium,
                ))
              : ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
        ));
  }
}
