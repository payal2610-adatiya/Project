// add_transaction_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class AddTransactionDialog extends StatefulWidget {
  final String userId;
  final VoidCallback onTransactionAdded;
  const AddTransactionDialog({super.key, required this.userId, required this.onTransactionAdded});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  String? _selectedCategoryId;
  List<dynamic> _categories = [];
  bool _loading = false;
  bool _categoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _categoriesLoading = true);
    final resp = await ApiService.viewCategories(widget.userId);
    setState(() {
      _categories = resp['categories'] ?? [];
      _categoriesLoading = false;
    });
  }

  String _normalizeCategoryType(String? raw) {
    if (raw == null) return 'expense';
    final s = raw.toString().toLowerCase();
    return s.contains('inc') ? 'income' : 'expense';
  }

  Future<void> _add() async {
    final raw = _amount.text.trim().replaceAll(',', '');
    final amount = double.tryParse(raw);
    if (_selectedCategoryId == null) return _show('Select a category');
    if (amount == null || amount <= 0) return _show('Enter a valid amount');

    setState(() => _loading = true);
    final resp = await ApiService.addTransaction(userId: widget.userId, categoryId: _selectedCategoryId!, amount: amount.toString(), date: DateFormat('yyyy-MM-dd').format(_date), note: _note.text.trim());
    setState(() => _loading = false);

    final message = resp['message'] ?? 'Failed';
    _show(message);
    if (resp['code'] == 200 || resp['data']?['success'] == true) {
      widget.onTransactionAdded();
      if (mounted) Navigator.pop(context);
    }
  }

  void _show(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Add Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      Align(alignment: Alignment.centerLeft, child: const Text('Category', style: TextStyle(fontWeight: FontWeight.w600))),
      const SizedBox(height: 8),
      _categoriesLoading ? const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())) : _categories.isEmpty ? const SizedBox(height: 60, child: Center(child: Text('No categories. Create one first.'))) : Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12), child: DropdownButton<String>(isExpanded: true, value: _selectedCategoryId, underline: const SizedBox(), hint: const Text('Select Category'), items: _categories.map((c) {
        final id = c['id']?.toString() ?? '';
        final name = c['name']?.toString() ?? 'Unknown';
        final type = _normalizeCategoryType(c['type']?.toString());
        return DropdownMenuItem(value: id, child: Text('$name (${type == 'income' ? 'Income' : 'Expense'})', style: TextStyle(color: type == 'income' ? Colors.green : Colors.red)));
      }).toList(), onChanged: (v) => setState(() => _selectedCategoryId = v))),
      const SizedBox(height: 12),
      ListTile(title: const Text('Date'), subtitle: Text(DateFormat('MMM dd, yyyy').format(_date)), trailing: const Icon(Icons.calendar_today), onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (picked != null) setState(() => _date = picked);
      }),
      const SizedBox(height: 8),
      TextField(controller: _note, maxLines: 2, decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: _loading ? null : () => Navigator.pop(context), child: const Text('Cancel'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(onPressed: (_loading || _categories.isEmpty) ? null : _add, style: ElevatedButton.styleFrom(backgroundColor: AppColors.bottomNavSelected), child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Add'))),
      ])
    ]))));
  }
}
