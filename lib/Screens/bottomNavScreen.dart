import 'package:flutter/material.dart';
import 'package:nex_movies/Screens/AnimeScreen.dart';
import 'package:nex_movies/Screens/HomeScreen.dart';
import 'NewAddandCommingSoonScreen.dart';
import 'SerialHomeScreen.dart';

class BottomNavScreen extends StatefulWidget {
  BottomNavScreen({super.key});
  static const routeName = 'BottomNavScreen';
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  final List<Widget> _Screens = [
    NewAddandCommingSoonScreen(),
    const HomeScreen(),
    const SerialHomeScreen(),
    const AnimeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies_rounded), label: 'Web Series'),
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Anime',
          ),
        ],
      ),
    );
  }
}
