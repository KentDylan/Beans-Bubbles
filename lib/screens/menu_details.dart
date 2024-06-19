import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_model.dart';
import '../data/db_helper.dart';
import '../data/cart_provider.dart';
import '../models/cart_model.dart';
import '../widgets/button.dart';

class MenuDetails extends StatefulWidget {
  final MenuModel item;

  const MenuDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  DBHelper dbHelper = DBHelper();

  int quantityCount = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;
    var item = widget.item;
    double screenWidth = MediaQuery.of(context).size.width;

    bool isBigScreen = screenWidth >= 600;

    void decrementQuantity() {
      if (quantityCount > 1) {
        setState(() {
          quantityCount--;
        });
      }
    }

    void incrementQuantity() {
      setState(() {
        quantityCount++;
      });
    }

    void addToCart() {
      dbHelper
          .insertOrUpdate(
        Cart(
          id: item.id,
          productId: item.id.toString(),
          productName: item.name,
          initialPrice: item.price * quantityCount,
          productPrice: item.price,
          quantity: ValueNotifier<int>(quantityCount),
          category: item.category,
          image: item.imageUrl,
        ),
      )
          .then((value) {
        cart.addTotalPrice(item.price.toDouble());
        cart.addCounter(quantityCount);
        print('Product Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });

      // Show the dialog
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60.0,
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Menu successfully added to Order Cart.",
                      style: textStyle.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                          Navigator.of(context)
                              .pop(); // Dismiss the MenuDetails screen
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white),
                        child: const Text("OK"),
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

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          'Details',
          style: textStyle.headlineMedium!.copyWith(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: isBigScreen
          ? ListView(
              children: [
                // listview of details
                BigItemDetails(item: item),

                // price + quantity + add to cart button
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: colorScheme.primary,
                  child: Column(
                    children: [
                      // quantity
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 5.0, 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // item quantity text
                            Text("Item Quantity",
                                style: textStyle.labelMedium!.copyWith(
                                  color: colorScheme.background,
                                )),

                            // plus and minus button
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      color: colorScheme.secondary,
                                      icon: const Icon(Icons.remove),
                                      onPressed: decrementQuantity,
                                    )),

                                // quantity
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      quantityCount.toString(),
                                      style: textStyle.labelMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // plus button
                                Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      color: colorScheme.secondary,
                                      icon: const Icon(Icons.add),
                                      onPressed: incrementQuantity,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),

                      // add to cart
                      MyButton(
                        text: "Add To Cart",
                        onTap: () {
                          addToCart();
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          : Column(
              children: [
                // listview of details
                Expanded(
                  child: ItemDetails(item: item),
                ),

                // price + quantity + add to cart button
                Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 150.0,
                  color: Colors.orange.shade700,
                  child: Column(
                    children: [
                      // quantity
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 5.0, 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // item quantity text
                            Text("Item Quantity",
                                style: textStyle.labelMedium!.copyWith(
                                  color: colorScheme.background,
                                )),

                            // plus and minus button
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      color: colorScheme.secondary,
                                      icon: const Icon(Icons.remove),
                                      onPressed: decrementQuantity,
                                    )),

                                // quantity
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      quantityCount.toString(),
                                      style: textStyle.labelMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // plus button
                                Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      color: colorScheme.secondary,
                                      icon: const Icon(Icons.add),
                                      onPressed: incrementQuantity,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),

                      // add to cart
                      MyButton(
                        text: "Add To Cart",
                        onTap: () {
                          addToCart();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({
    super.key,
    required this.item,
  });

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          // category
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              item.category,
              style: textStyle.displayLarge!.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(
            height: 15.0,
          ),
          // image
          Hero(
            tag: item.imageUrl,
            child: Image.asset(
              item.imageUrl,
              height: 220,
            ),
          ),

          const SizedBox(
            height: 25,
          ),
          // food name
          Text(
            item.name,
            style: textStyle.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          ),

          // food price
          Text(
              'IDR ${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}',
              style: textStyle.displayMedium!.copyWith(
                color: colorScheme.primary,
              )),

          const SizedBox(
            height: 25,
          ),
          // description
          Text(
            "Description",
            style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),

          Text(
            item.description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class BigItemDetails extends StatelessWidget {
  const BigItemDetails({
    super.key,
    required this.item,
  });

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // category
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              item.category,
              style: textStyle.displayLarge!.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(
            height: 15.0,
          ),
          // image
          Hero(
            tag: item.imageUrl,
            child: Image.asset(
              item.imageUrl,
              height: 220,
            ),
          ),

          const SizedBox(
            height: 25,
          ),
          // food name
          Text(
            item.name,
            style: textStyle.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          ),

          // food price
          Text(
              'IDR ${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}',
              style: textStyle.displayMedium!.copyWith(
                color: colorScheme.primary,
              )),

          const SizedBox(
            height: 25,
          ),
          // description
          Text(
            "Description",
            style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),

          Text(
            item.description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
