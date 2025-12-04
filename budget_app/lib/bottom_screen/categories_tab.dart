// categories_tab.dart
import 'package:flutter/material.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class CategoriesTab extends StatefulWidget {
  final String userId;
  const CategoriesTab({super.key, required this.userId});
  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<dynamic> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final resp = await ApiService.viewCategories(widget.userId);
    setState(() {
      categories = resp['categories'] ?? [];
      loading = false;
    });
  }

  Future<void> _addOrUpdate({String? id, String? name, String? type}) async {
    final nameCtrl = TextEditingController(text: name ?? '');
    String? sel = type;
    await showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(id == null ? 'New Category' : 'Edit Category'), content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
      const SizedBox(height: 8),
      DropdownButton<String>(value: sel, isExpanded: true, items: const [DropdownMenuItem(value: 'Income', child: Text('Income')), DropdownMenuItem(value: 'Expense', child: Text('Expense'))], onChanged: (v) => sel = v),
    ]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () async {
      final n = nameCtrl.text.trim();
      if (n.isEmpty) return;
      Navigator.pop(ctx);
      if (id == null) {
        final res = await ApiService.addCategory(userId: widget.userId, name: n, type: sel ?? 'Expense');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Added')));
      } else {
        final res = await ApiService.updateCategory(id: id, name: n, type: sel ?? 'Expense');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Updated')));
      }
      _load();
    }, child: const Text('Save'))]));
  }

  Future<void> _delete(String id) async {
    final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete'), content: const Text('Delete this category? This will not remove transactions.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes'))]));
    if (confirm != true) return;
    final res = await ApiService.deleteCategory(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Delete')));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: const [Expanded(child: Center(child: Text('Categories', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))), Icon(Icons.notifications_none, color: Colors.white)])),
        const SizedBox(height: 10),
        Expanded(child: Container(decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))), padding: const EdgeInsets.all(20), child: loading ? const Center(child: CircularProgressIndicator()) : GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, childAspectRatio: 0.82), itemCount: categories.length + 1, itemBuilder: (c, i) {
          if (i == categories.length) {
            return GestureDetector(onTap: () => _addOrUpdate(), child: Container(decoration: BoxDecoration(color: const Color(0xFFE8FFF3), borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.add, size: 36))));
          }
          final cat = categories[i];
          final type = (cat['type']?.toString() ?? 'expense').toLowerCase();
          final isIncome = type.contains('inc');
          return GestureDetector(onTap: () => _addOrUpdate(id: cat['id']?.toString(), name: cat['name']?.toString(), type: isIncome ? 'Income' : 'Expense'), child: Container(decoration: BoxDecoration(color: isIncome ? const Color(0xFFD1F5E0) : const Color(0xFFFDE1E1), borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.all(8), child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red, size: 28), Flexible(child: Text(cat['name']?.toString() ?? '', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _delete(cat['id']?.toString() ?? ''))]))); }))),
      ])),
    );
  }
}
