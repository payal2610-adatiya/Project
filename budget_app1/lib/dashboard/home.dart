// home.dart
import 'package:flutter/material.dart';
import 'package:budget_app/app_colors/app_colors.dart';
import 'package:budget_app/bottom_screen/home_tab.dart';
import 'package:budget_app/bottom_screen/transaction_tab.dart';
import 'package:budget_app/bottom_screen/stats_tab.dart';
import 'package:budget_app/bottom_screen/categories_tab.dart';
import 'package:budget_app/bottom_screen/profile_tab.dart';

class Home extends StatefulWidget {
  final String userId;
  const Home({super.key, required this.userId});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTab(userId: widget.userId),
      TransactionsTab(userId: widget.userId),
      StatsTab(userId: widget.userId),
      CategoriesTab(userId: widget.userId),
      ProfileTab(userId: widget.userId),
    ];
  }

  void _onTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])),
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.bottomNavSelected,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
