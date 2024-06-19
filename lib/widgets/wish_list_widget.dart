import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../screens/menu_details.dart';
import 'menu_card.dart';
import '../data/wishlist_provider.dart';
import 'package:provider/provider.dart';

class WishListWidget extends StatelessWidget {
  const WishListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium!,
        ),
        elevation: 2,
      ),
      body: const WishListBody(),
    );
  }
}

class WishListBody extends StatelessWidget {
  const WishListBody({super.key});
  final maxCharacters = 25;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = context.watch<WishListProvider>();

    if (wishListProvider.wishListItems.isEmpty) {
      return const Center(
        child: Text('Wishlist is empty.'),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wishListProvider.wishListItems.length,
              itemBuilder: (context, index) {
                final item = wishListProvider.wishListItems[index];

                return WishListItem(
                  item: item,
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

class WishListItem extends StatelessWidget {
  const WishListItem({super.key, required this.item});

  final MenuModel item;
  final maxCharacters = 25;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = context.watch<WishListProvider>();
    final formattedName = item.name.length > maxCharacters
        ? '${item.name.substring(0, maxCharacters)}...'
        : item.name;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MenuDetails(item: item),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WishListImage(item: item),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedName),
                  ItemPrice(item: item),
                  IconButton(
                      onPressed: () {
                        wishListProvider.removeItem(item);
                      },
                      icon: const Icon(Icons.favorite)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WishListImage extends StatelessWidget {
  const WishListImage({
    super.key,
    required this.item,
  });

  final MenuModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(item.imageUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
