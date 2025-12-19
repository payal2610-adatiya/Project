// home_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class HomeTab extends StatefulWidget {
  final String userId;
  const HomeTab({super.key, required this.userId});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map<String, dynamic>? reports;
  List<dynamic> transactions = [];
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

  double get totalBalance {
    final inc = double.tryParse(reports?['income']?.toString() ?? '0') ?? 0;
    final exp = double.tryParse(reports?['expense']?.toString() ?? '0') ?? 0;
    return inc - exp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              //-- HEADER --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Budget App',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              //-- TOTAL BALANCE CARD --
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientStart,
                      AppColors.gradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${totalBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _smallStat(
                          "Income",
                          reports?['income'] ?? '0',
                          Colors.green,
                        ),
                        _smallStat(
                          "Expense",
                          reports?['expense'] ?? '0',
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //-- RECENT TRANSACTIONS --
              const Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              transactions.isEmpty
                  ? Column(
                children: [
                  Icon(Icons.receipt_long,
                      size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  const Text("No transactions yet"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: _load,
                      child: const Text("Refresh")),
                ],
              )
                  : Column(
                children: transactions.take(5).map((tx) {
                  final amount =
                      double.tryParse(tx['amount']?.toString() ?? '0') ??
                          0;

                  final isIncome =
                      (tx['category_type']?.toString() ?? '')
                          .toLowerCase() ==
                          'income';

                  final date =
                      DateTime.tryParse(tx['date'] ?? "") ??
                          DateTime.now();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                          isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(tx['note'] ?? "No description"),
                      subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(date)),
                      trailing: Text(
                        "₹${amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: isIncome
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //-- INCOME / EXPENSE SMALL STAT --
  Widget _smallStat(String title, dynamic value, Color color) {
    final amount = double.tryParse(value?.toString() ?? '0') ?? 0;

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
