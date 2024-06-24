import 'package:BeaBubs/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'screens/menu_list.dart';
import 'screens/deals.dart';
import 'screens/order_cart.dart';
import 'screens/order_history.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/carwash.dart';
import 'screens/profile_page.dart';
import 'screens/CarWashOrderPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedIndex = _tabController.index;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // Switch case to change between pages
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Home();
        break;
      case 1:
        page = const MenuList();
        break;
      case 2:
        page = const CarWashPage();
        break;
      case 3:
        page = const OrderCart();
        break;
      case 4:
        page = const OrderHistory();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    // Style the page area and add animations
    var pageArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hi, Welcome!'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarWashOrderPage()),
    );
              },
            ),
IconButton(
  icon: Icon(Icons.account_circle),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  },
),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Home(),
          const MenuList(),
          const CarWashPage(),
          const OrderCart(),
          const OrderHistory(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        selectedItemColor: colorScheme.primary,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe_outlined),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Wash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
