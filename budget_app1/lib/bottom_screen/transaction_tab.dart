// transaction_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/app_colors/app_colors.dart';
import 'package:budget_app/screens/add_transaction_dialog.dart';

class TransactionsTab extends StatefulWidget {
  final String userId;
  const TransactionsTab({super.key, required this.userId});
  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  List<dynamic> transactions = [];
  Map<String, dynamic>? reports;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final r = await ApiService.getReports(widget.userId);
    final t = await ApiService.viewTransactions(widget.userId);
    setState(() {
      reports = r['reports'] ?? r['data'] ?? {};
      transactions = t['transactions'] ?? [];
      loading = false;
    });
  }

  Future<void> _deleteTransaction(String id) async {
    final conf = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete'), content: const Text('Delete this transaction?'), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')), TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Yes'))]));
    if (conf != true) return;

    final res = await ApiService.deleteTransaction(id);
    final msg = res['message'] ?? 'Failed';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    if (res['code'] == 200 || res['data']?['success'] == true) _load();
  }

  void _openAddDialog() => showDialog(context: context, builder: (_) => AddTransactionDialog(userId: widget.userId, onTransactionAdded: _load));

  double get totalBalance {
    final inc = double.tryParse(reports?['income']?.toString() ?? '0') ?? 0;
    final exp = double.tryParse(reports?['expense']?.toString() ?? '0') ?? 0;
    return inc - exp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(onPressed: _openAddDialog, backgroundColor: AppColors.bottomNavSelected, child: const Icon(Icons.add)),
      body: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])), child: SafeArea(child: Column(children: [const Text('Total Balance', style: TextStyle(color: Colors.white70)), const SizedBox(height: 6), Text('\$${totalBalance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ _summaryItem('Income', reports?['income'] ?? '0', Colors.green), _summaryItem('Expense', reports?['expense'] ?? '0', Colors.red)])]))),
        Expanded(child: loading ? const Center(child: CircularProgressIndicator()) : transactions.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long, size: 60, color: Colors.grey[400]), const SizedBox(height: 8), const Text('No transactions yet'), const SizedBox(height: 8), ElevatedButton(onPressed: _openAddDialog, child: const Text('Add your first transaction'))])) : RefreshIndicator(onRefresh: _load, child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: transactions.length, itemBuilder: (c, i) {
          final tx = transactions[i];
          final amount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
          final isIncome = (tx['category_type']?.toString() ?? '').toLowerCase() == 'income';
          final date = DateTime.tryParse(tx['date'] ?? '') ?? DateTime.now();
          return Dismissible(key: Key(tx['id'].toString()), direction: DismissDirection.endToStart, background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)), confirmDismiss: (_) async {
            final res = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete'), content: const Text('Delete this transaction?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes'))]));
            if (res == true) await _deleteTransaction(tx['id'].toString());
            return false;
          }, child: Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: CircleAvatar(backgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2), child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red)), title: Text(tx['note'] ?? 'No description'), subtitle: Text('${tx['category_name'] ?? 'Uncategorized'} • ${DateFormat('MMM dd, yyyy').format(date)}'), trailing: Text('${isIncome ? '+' : '-'} \$${amount.toStringAsFixed(2)}', style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),));
          })))
      ]),
    );
  }

  Widget _summaryItem(String title, dynamic value, Color color) {
    final amount = double.tryParse(value?.toString() ?? '0') ?? 0;
    return Column(children: [Text(title, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 6), Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: color, fontWeight: FontWeight.bold))]);
  }
}
