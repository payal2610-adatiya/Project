import 'package:flutter/material.dart';
import '../app_colors/app_colors.dart';
import '../models/category.dart';
import '../models/transactions.dart';

class AnimatedCards extends StatelessWidget {
  final List<Category> categories;
  final List<TransactionModel> transactions;

  const AnimatedCards({required this.categories, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Categories", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final c = categories[index];
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500 + index * 100),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(16),
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.gradientStart, AppColors.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(c.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(c.type, style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text("Transactions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              final category = categories.firstWhere((c) => c.id == t.categoryId, orElse: () => Category(id: 0, userId: 0, name: "Unknown", type: "expense"));
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 400 + index * 50),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListTile(
                    title: Text("${category.name} - ${t.amount.toStringAsFixed(2)}"),
                    subtitle: Text(t.note ?? ""),
                    trailing: Text(t.date),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
