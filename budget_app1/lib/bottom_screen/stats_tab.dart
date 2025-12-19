// stats_tab.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:intl/intl.dart';

class StatsTab extends StatefulWidget {
  final String userId;
  const StatsTab({super.key, required this.userId});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
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

  @override
  Widget build(BuildContext context) {
    final inc = double.tryParse(reports?['income']?.toString() ?? '0') ?? 0;
    final exp = double.tryParse(reports?['expense']?.toString() ?? '0') ?? 0;

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
              const Text(
                "Statistics",
                style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Income & Expense Cards
              Row(
                children: [
                  Expanded(
                      child: _statCard(
                          "Total Income", inc, Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(
                      child:
                      _statCard("Total Expense", exp, Colors.red)),
                ],
              ),
              const SizedBox(height: 12),

              _statCard("Net Balance", inc - exp, Colors.blue),

              const SizedBox(height: 20),
              const Text("Income vs Expense",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, meta) {
                            if (v.toInt() == 1) {
                              return const Text("Income");
                            } else if (v.toInt() == 2) {
                              return const Text("Expense");
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: inc,
                            width: 26,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: exp,
                            width: 26,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              const Text("Recent Transactions",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              ...transactions.take(5).map((t) {
                final amount =
                    double.tryParse(t['amount']?.toString() ?? '0') ?? 0;
                final date = DateTime.tryParse(t['date'] ?? "") ??
                    DateTime.now();
                final isIncome = (t['category_type'] ?? '')
                    .toLowerCase() ==
                    'income';

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        isIncome
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color:
                        isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title:
                    Text(t['note'] ?? "No Description"),
                    subtitle: Text(
                      "${t['category_name'] ?? 'Unknown'} • ${DateFormat('MMM dd, yyyy').format(date)}",
                    ),
                    trailing: Text(
                      "₹${amount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color:
                          isIncome ? Colors.green : Colors.red),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, double value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              "₹${value.toStringAsFixed(2)}",
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
