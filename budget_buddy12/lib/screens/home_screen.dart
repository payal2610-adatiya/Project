import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animations_budget_app/custom_animations.dart';
import '../animations_budget_app/pie_chart_animations.dart';

import '../api_services/api_services.dart';
import '../app_colors/app_colors.dart';

import '../models/transactions.dart';
import 'add_category_screen.dart';
import 'add_transaction_screen.dart';
import 'profile_screen.dart';
import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<Category> categories = [];
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    final catResponse = await ApiService.viewCategories(widget.userId);
    categories = catResponse.map((c) => Category.fromJson(c)).toList();
    final txResponse = await ApiService.viewTransactions(widget.userId);
    transactions = txResponse.map((t) => TransactionModel.fromJson(t)).toList();
    setState(() => isLoading = false);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildHomeTab() {
    if (isLoading) return Center(child: CircularProgressIndicator());

    double totalIncome = transactions
        .where((t) => categories.firstWhere((c) => c.id == t.categoryId).type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    double totalExpense = transactions
        .where((t) => categories.firstWhere((c) => c.id == t.categoryId).type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            OverviewChart(income: totalIncome, expense: totalExpense),
            AnimatedCards(categories: categories, transactions: transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return AddCategoryScreen(userId: widget.userId, onCategoryAdded: _fetchData);
  }

  Widget _buildProfileTab() {
    return ProfileScreen(userId: widget.userId, onProfileUpdated: _fetchData, logoutCallback: _logout);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_buildHomeTab(), _buildCategoriesTab(), _buildProfileTab()];

    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Buddy"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.bottomNavSelected,
        unselectedItemColor: AppColors.bottomNavUnselected,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: AppColors.fabBackground,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(userId: widget.userId, onTransactionAdded: _fetchData),
            ),
          );
        },
      )
          : null,
    );
  }
}
