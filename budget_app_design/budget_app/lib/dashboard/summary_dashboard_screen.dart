import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final int userId;
  const Dashboard({super.key, required this.userId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> transactions = [];
  List<String> expenseCategories = [];
  List<String> incomeCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchTransactions();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2/budget_app/view_category.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          expenseCategories = List<String>.from(data['expense']);
          incomeCategories = List<String>.from(data['income']);
        });
      }
    } catch (e) {
      print("Category fetch error: $e");
    }
  }

  // Add category
  Future<void> addCategory(String name, String type) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/budget_app/add_category.php"),
        body: {'name': name, 'type': type},
      );
      if (response.statusCode == 200) fetchCategories();
    } catch (e) {
      print("Add category error: $e");
    }
  }

  // Delete category
  Future<void> deleteCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/budget_app/delete_category.php"),
        body: {'name': name},
      );
      if (response.statusCode == 200) fetchCategories();
    } catch (e) {
      print("Delete category error: $e");
    }
  }

  // Fetch transactions
  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2/budget_app/view_transactions.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          transactions = List<Map<String, dynamic>>.from(data['transactions']);
        });
      }
    } catch (e) {
      print("Transaction fetch error: $e");
    }
  }

  // Add transaction
  Future<void> addTransaction(Map<String, dynamic> tx) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/budget_app/add_transactions.php"),
        body: {
          "type": tx["type"],
          "title": tx["title"],
          "desc": tx["desc"],
          "amount": tx["amount"].toString(),
          "date": tx["date"].toString(),
          "category": tx["category"],
          "user_id": widget.userId.toString(),
        },
      );
      if (response.statusCode == 200) fetchTransactions();
    } catch (e) {
      print("Add transaction error: $e");
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/budget_app/delete_transaction.php"),
        body: {"id": id.toString()},
      );
      if (response.statusCode == 200) fetchTransactions();
    } catch (e) {
      print("Delete transaction error: $e");
    }
  }

  // Example getters for totals
  double get totalIncome => transactions
      .where((t) => t["type"] == "Income")
      .fold(0.0, (sum, t) => sum + double.parse(t["amount"].toString()));

  double get totalExpense => transactions
      .where((t) => t["type"] == "Expense")
      .fold(0.0, (sum, t) => sum + double.parse(t["amount"].toString()));

  double get balance => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Totals Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Income", style: TextStyle(color: Colors.green)),
                            SizedBox(height: 6),
                            Text("₹${totalIncome.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Expense", style: TextStyle(color: Colors.red)),
                            SizedBox(height: 6),
                            Text("₹${totalExpense.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Balance", style: TextStyle(color: Colors.blueAccent)),
                            SizedBox(height: 6),
                            Text("₹${balance.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Transaction List
              Expanded(
                child: transactions.isEmpty
                    ? Center(child: Text("No transactions", style: TextStyle(color: Colors.black54)))
                    : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx["type"] == "Income" ? Colors.green : Colors.red,
                          child: Icon(
                            tx["type"] == "Income" ? Icons.arrow_downward : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(tx["title"]),
                        subtitle: Text("${tx["category"]} • ${tx["date"]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${tx["type"] == "Income" ? "+" : "-"} ₹${tx["amount"]}",
                              style: TextStyle(
                                  color: tx["type"] == "Income" ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTransaction(int.parse(tx["id"].toString())),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "manageCategories",
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              // implement _manageCategories() using addCategory/deleteCategory API
            },
            child: Icon(Icons.category, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addTransaction",
            backgroundColor: Colors.pink.shade400,
            onPressed: () {
              // implement _addTransaction() using addTransaction API
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
