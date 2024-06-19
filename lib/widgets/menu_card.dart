import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/wishlist_provider.dart';
import '../models/menu_model.dart';
import '../screens/menu_details.dart';
import '../data/cart_provider.dart';
import '../data/db_helper.dart';
import '../models/cart_model.dart';

class MenuCard extends StatefulWidget {
  final String category;
  final ValueNotifier<int> quantityNotifier;

  const MenuCard({Key? key, required this.category, required this.quantityNotifier}) : super(key: key);

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  List<MenuModel> menu = listMenu;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    List<MenuModel> filteredMenu = menu.where((item) => item.category == widget.category).toList();

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: filteredMenu.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ItemCard(item: filteredMenu[index]),
              Divider(
                color: Colors.grey.shade300, // Color of the divider
                thickness: 1, // Thickness of the divider
              ),
            ],
          );
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final MenuModel item;
  final int maxCharacters = 17;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    final wishListProvider = context.watch<WishListProvider>();
    final cart = Provider.of<CartProvider>(context, listen: false);
    DBHelper dbHelper = DBHelper();

    IconData wishIcon;
    if (wishListProvider.contains(item)) {
      wishIcon = Icons.favorite;
    } else {
      wishIcon = Icons.favorite_border;
    }

    final formattedName = item.name.length > maxCharacters
        ? '${item.name.substring(0, maxCharacters)}...'
        : item.name;

    void addToCart() {
      dbHelper
          .insertOrUpdate(
        Cart(
          id: item.id,
          productId: item.id.toString(),
          productName: item.name,
          initialPrice: item.price,
          productPrice: item.price,
          quantity: ValueNotifier<int>(1),
          category: item.category,
          image: item.imageUrl,
        ),
      )
          .then((value) {
        cart.addTotalPrice(item.price.toDouble());
        cart.addCounter(1);
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
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
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

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MenuDetails(item: item);
        }));
      },
      child: Card(
        color: Colors.white, // Set card color to white
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0, // Remove shadow
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ItemImage(item: item),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ItemName(name: formattedName),
                        IconButton(
                          icon: Icon(wishIcon),
                          color: colorScheme.onPrimaryContainer,
                          onPressed: () {
                            wishListProvider.toggleWishList(item);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Per piece',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ItemPrice(item: item),
                        ElevatedButton(
                          onPressed: addToCart,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade700,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemName extends StatelessWidget {
  const ItemName({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

class ItemPrice extends StatelessWidget {
  const ItemPrice({super.key, required this.item});

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      child: Text(
        'IDR ${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}',
        style: textTheme.bodyText1!.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class ItemImage extends StatelessWidget {
  const ItemImage({super.key, required this.item});

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
