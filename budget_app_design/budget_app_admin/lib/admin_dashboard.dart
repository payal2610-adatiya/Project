import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalUsers = 0;
  List<Map<String, dynamic>> categories = [];
  TextEditingController nameController = TextEditingController();
  String type = 'Income';
  final String baseUrl = 'http://10.0.2.2/budget_app/';

  @override
  void initState() {
    super.initState();
    fetchTotalUsers();
    fetchCategories();
  }

  Future<void> fetchTotalUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'total_users.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalUsers = data['total_users'];
        });
      }
    } catch (e) {
      print("Total users fetch error: $e");
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'view_category.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data['categories']);
        });
      }
    } catch (e) {
      print("Categories fetch error: $e");
    }
  }

  Future<void> addCategoryDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: type,
              items: ['Income', 'Expense'].map((e) =>
                  DropdownMenuItem(child: Text(e), value: e)
              ).toList(),
              onChanged: (val) {
                setState(() {
                  type = val!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              addCategory();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> addCategory() async {
    if (nameController.text.isEmpty) return;

    try {
      final response = await http.post(Uri.parse(baseUrl + 'add_category.php'), body: {
        'name': nameController.text,
        'type': type,
      });
      if (response.statusCode == 200) {
        fetchCategories();
        nameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category added successfully'))
        );
      }
    } catch (e) {
      print("Add category error: $e");
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.post(Uri.parse(baseUrl + 'delete_category.php'), body: {
        'id': id,
      });
      if (response.statusCode == 200) fetchCategories();
    } catch (e) {
      print("Delete category error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
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
              // Total Users Card (centered)
              Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        const Text("Total Users", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text("$totalUsers", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // View Categories
              Expanded(
                child: categories.isEmpty
                    ? const Center(child: Text("No categories", style: TextStyle(color: Colors.black54)))
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text(cat['name']),
                        subtitle: Text(cat['type']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCategory(cat['id'].toString()),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: addCategoryDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
