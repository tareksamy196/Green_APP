import 'package:cantu/ui/bag/BagScreen.dart';
import 'package:cantu/ui/favorite/FavoriteScreen.dart';
import 'package:cantu/ui/home/HomeScreen.dart';
import 'package:cantu/ui/profile/ProfileScreen.dart';
import 'package:cantu/ui/sellProducts/AddProduct.dart';
import 'package:flutter/material.dart';

class MainNavApp extends StatelessWidget {
  const MainNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    WishlistScreen(),
    AddProductScreen(),
    BagScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite),
            icon: Badge(
                isLabelVisible: false, child: Icon(Icons.favorite_border)),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.add_box_rounded),
            icon: Icon(Icons.add_box_outlined),
            label: 'Add item',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.shopping_bag),
            icon: Badge(
              isLabelVisible: false,
              label: Text('2'),
              child: Icon(Icons.shopping_bag_outlined),
            ),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Colors.green,
        selectedIconTheme: const IconThemeData(
          color: Colors.green,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white60,
        ),
        unselectedLabelStyle: const TextStyle(color: Colors.white60),
        selectedLabelStyle: const TextStyle(color: Colors.green),
        showUnselectedLabels: false,
      ),
    );
  }
}
