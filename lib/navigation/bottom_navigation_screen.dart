import 'package:flutter/material.dart';
import 'package:food_ordering_app/view/favourite_screen.dart';
import 'package:food_ordering_app/view/home_screen.dart';
import 'package:food_ordering_app/view/order_screen.dart';
import 'package:food_ordering_app/view/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavouriteScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: _currentIndex,

          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: "Orders",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
