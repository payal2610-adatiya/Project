import 'package:flutter/material.dart';
import '../api_services/api_services.dart';
import '../app_colors/app_colors.dart';
import '../models/category.dart';

class AddTransactionScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onTransactionAdded;

  const AddTransactionScreen({required this.userId, required this.onTransactionAdded});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  List<Category> categories = [];
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final response = await ApiService.viewCategories(widget.userId);
    setState(() {
      categories = response.map<Category>((c) => Category.fromJson(c)).toList();
      if (categories.isNotEmpty) selectedCategory = categories[0];
    });
  }

  Future<void> _addTransaction() async {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      setState(() => isLoading = true);
      final response = await ApiService.addTransaction(
        widget.userId,
        selectedCategory!.id,
        double.parse(amountController.text),
        noteController.text,
        "${selectedDate.toIso8601String().split('T')[0]}",
      );
      setState(() => isLoading = false);

      if (response['status'] == 'success') {
        widget.onTransactionAdded();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Error adding transaction')));
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) => value == null || value.isEmpty ? 'Enter amount' : null,
              ),
              TextFormField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Note (optional)'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                  TextButton(onPressed: _pickDate, child: Text("Pick Date")),
                ],
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator() else ElevatedButton(
                onPressed: _addTransaction,
                child: Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: AppColors.bottomNavSelected,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
