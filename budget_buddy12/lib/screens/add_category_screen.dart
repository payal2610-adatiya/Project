import 'package:flutter/material.dart';

import '../api_services/api_services.dart';
import '../app_colors/app_colors.dart';

class AddCategoryScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onCategoryAdded;

  const AddCategoryScreen({required this.userId, required this.onCategoryAdded});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String type = 'income';
  bool isLoading = false;

  Future<void> _addCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final response = await ApiService.addCategory(widget.userId, nameController.text, type);
      setState(() => isLoading = false);

      if (response['status'] == 'success') {
        widget.onCategoryAdded();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Error adding category')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Category')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter category name' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                items: ['income', 'expense'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => type = val!),
                decoration: InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _addCategory,
                child: Text('Add Category'),
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
