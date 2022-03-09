import '/exp_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Explanation Navigation Bar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
      bottomNavigationBar: ExpNavigationBar(
        onPress: (index) {},
        items: const [
          ExpNavigationItem(
            icon: Icons.home,
            exp: 'Home',
          ),
          ExpNavigationItem(
            icon: Icons.add,
            exp: 'Add',
          ),
          ExpNavigationItem(
            icon: Icons.notifications,
            badge: true,
            badgeCount: 3,
            exp: 'Notifications',
          ),
          ExpNavigationItem(
            icon: Icons.person,
            exp: 'Profile',
          ),
        ],
      ),
    );
  }
}
