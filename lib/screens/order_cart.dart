import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/plus_minus_button.dart';
import '../widgets/subtotal_widget.dart';
import '../data/cart_provider.dart';
import '../models/cart_model.dart'; // Assuming Cart model is defined here

class OrderCart extends StatefulWidget {
  const OrderCart({super.key});

  @override
  State<OrderCart> createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surfaceVariant,
          title: Center(
            child: Text(
              'Order Cart',
              style: textStyle.displayMedium!.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (BuildContext context, provider, widget) {
                  if (provider.cart.isEmpty) {
                    return Center(
                      child: Text(
                        'Your cart is empty',
                        style: textStyle.labelMedium,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  height: 100,
                                  width: 150,
                                  image:
                                      AssetImage(provider.cart[index].image),
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: 'Menu: ',
                                          style:
                                              textStyle.headlineSmall!.copyWith(
                                            color: Colors.blueGrey.shade800,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${provider.cart[index].name}\n',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: 'Price/each: ' r"IDR ",
                                          style:
                                              textStyle.headlineSmall!.copyWith(
                                            color: Colors.blueGrey.shade800,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${provider.cart[index].price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}\n',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable:
                                      provider.cart[index].quantity,
                                  builder: (context, val, child) {
                                    return PlusMinusButtons(
                                      addQuantity: () {
                                        setState(() {
                                          cart.addQuantity(
                                              provider.cart[index].id);
                                        });
                                      },
                                      deleteQuantity: () {
                                        setState(() {
                                          cart.deleteQuantity(
                                              provider.cart[index].id);
                                        });
                                      },
                                      text: val.toString(),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 260,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          provider.removeItem(
                                              provider.cart[index].id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              colorScheme.surfaceTint,
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Delete Menu',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.cart.isEmpty) {
                  return Container();
                } else {
                  final ValueNotifier<double?> totalPrice = ValueNotifier(null);
                  for (var element in value.cart) {
                    totalPrice.value =
                        (element.price * element.quantity.value) +
                            (totalPrice.value ?? 0);
                  }
                  return SubTotalWidget(totalPrice: totalPrice);
                }
              },
            ),
            if (cart.cart.isNotEmpty)
              SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: () {
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addOrder(); // Call addOrder without arguments

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thank You!'),
                          content: const Text('Your order has been placed.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Order Now!',
                    style: textStyle.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}