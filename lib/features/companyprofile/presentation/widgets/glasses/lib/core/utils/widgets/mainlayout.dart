
import 'package:flutter/material.dart';
import 'package:glasses/core/utils/widgets/custom_button_navigation.dart';
import 'package:glasses/features/home/presentation/pages/home_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الفئات Screen', style: TextStyle(fontSize: 24)));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('السلة Screen', style: TextStyle(fontSize: 24)));
  }
}
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('PRODUCT Screen', style: TextStyle(fontSize: 24)));
  }
}
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('حسابي Screen', style: TextStyle(fontSize: 24)));
  }
}


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 4; // Initial index for 'الرئيسية' (Home) to be active

  final List<Widget> _screens = [
    const AccountScreen(),  // Index 0: حسابي
    const CartScreen(), 
    const ProductScreen(),     // Index 1: السلة
    const CategoriesScreen(), // Index 2: الفئات
       
    const HomeScreen(),     
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body will display the currently selected screen
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
