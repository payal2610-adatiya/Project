import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../app_colors/app_colors.dart';

class OverviewChart extends StatelessWidget {
  final double income;
  final double expense;

  const OverviewChart({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    double total = income + expense;
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(16),
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Income vs Expense", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 12),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: income,
                      color: AppColors.incomeCircle,
                      title: "Income\n${income.toStringAsFixed(0)}",
                      radius: 60,
                      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: expense,
                      color: AppColors.expenseCircle,
                      title: "Expense\n${expense.toStringAsFixed(0)}",
                      radius: 60,
                      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
