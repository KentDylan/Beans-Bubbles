import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';

class Deals extends StatefulWidget {
  const Deals({Key? key}) : super(key: key);

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final List<String> categories = ['Deals'];
  int selectedTabIndex = 0;
  int selectedBottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: categories.length, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: colorScheme.surfaceTint,
          title: Center(
            child: Text(
              'Discounted Items',
              style: textStyle.displayMedium!.copyWith(
                color: colorScheme.onInverseSurface,
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              return MenuCard(
                category: category,
                quantityNotifier: ValueNotifier<int>(0),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
