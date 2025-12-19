import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedFilter = 'monthly';
  String _selectedChartType = 'incomevsexpense';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalIncome = transactionProvider.getTotalIncome();
    final totalExpenses = transactionProvider.getTotalExpenses();
    final balance = transactionProvider.getBalance();

    // Debug prints
    print('=== Reports Screen ===');
    print('Transactions: ${transactionProvider.transactions.length}');
    print('Income: ₹$totalIncome');
    print('Expenses: ₹$totalExpenses');
    print('Balance: ₹$balance');

    // Prepare data for income vs expense chart
    final incomeExpenseData = [
      ChartData('Income', totalIncome, AppColors.success),
      ChartData('Expense', totalExpenses, AppColors.error),
    ];

    // Prepare category data - FIXED: Use type property instead of isExpense
    List<ChartData> expenseCategoryData = [];
    List<ChartData> incomeCategoryData = [];
    final categories = categoryProvider.categories;

    print('Total categories: ${categories.length}');

    for (var category in categories) {
      final transactions = transactionProvider.getTransactionsByCategory(category.id);
      print('Category "${category.name}" (${category.id}): ${transactions.length} transactions');

      double total = 0.0;

      for (var transaction in transactions) {
        // Check if transaction matches the category type
        // Assuming category.type is 'expense' or 'income'
        if ((category.type == 'expense' && transaction.isExpense) ||
            (category.type == 'income' && !transaction.isExpense)) {
          total += transaction.amount;
        }
      }

      if (total > 0) {
        final chartData = ChartData(category.name, total, category.color);

        if (category.type == 'expense') {
          expenseCategoryData.add(chartData);
        } else if (category.type == 'income') {
          incomeCategoryData.add(chartData);
        }
      }
    }

    // Sort data
    expenseCategoryData.sort((a, b) => b.amount.compareTo(a.amount));
    incomeCategoryData.sort((a, b) => b.amount.compareTo(a.amount));

    // For category breakdown, use expense categories
    final categoryData = expenseCategoryData;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(totalIncome, totalExpenses, balance),
            const SizedBox(height: 24),

            // Filter Section
            _buildFilterSection(),
            const SizedBox(height: 24),

            // Chart Type Section
            if (categoryData.isNotEmpty || incomeCategoryData.isNotEmpty)
              _buildChartTypeSection(),
            if (categoryData.isNotEmpty || incomeCategoryData.isNotEmpty)
              const SizedBox(height: 24),

            // Chart Display
            _buildChartDisplay(categoryData, incomeCategoryData, incomeExpenseData),
            const SizedBox(height: 24),

            // Category Breakdown - Show expense breakdown
            if (categoryData.isNotEmpty)
              _buildCategoryBreakdown(categoryData, totalExpenses),

            // If no data at all
            if (totalIncome == 0 && totalExpenses == 0)
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double income, double expenses, double balance) {
    return Row(
      children: [
        _buildSummaryCard('Income', income, AppColors.success, Icons.arrow_downward),
        const SizedBox(width: 8),
        _buildSummaryCard('Expense', expenses, AppColors.error, Icons.arrow_upward),
        const SizedBox(width: 8),
        _buildSummaryCard('Balance', balance, AppColors.primary, Icons.account_balance_wallet),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
             // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'View by Period',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                .map((period) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(period),
                selected: _selectedFilter == period.toLowerCase(),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = period.toLowerCase();
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _selectedFilter == period.toLowerCase()
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChartTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chart Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildChartTypeButton('Pie Chart', 'pie'),
              const SizedBox(width: 8),
              _buildChartTypeButton('Bar Chart', 'bar'),
              const SizedBox(width: 8),
              _buildChartTypeButton('Income vs Expense', 'incomevsexpense'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartTypeButton(String label, String type) {
    final isSelected = _selectedChartType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedChartType = type;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }

  Widget _buildChartDisplay(
      List<ChartData> expenseCategoryData,
      List<ChartData> incomeCategoryData,
      List<ChartData> incomeExpenseData
      ) {
    // If no income or expenses at all
    if (incomeExpenseData[0].amount == 0 && incomeExpenseData[1].amount == 0) {
      return _buildNoDataCard();
    }

    // Show selected chart
    if (_selectedChartType == 'pie') {
      // For pie chart, show expense categories if available, otherwise show income categories
      if (expenseCategoryData.isNotEmpty) {
        return _buildPieChart(expenseCategoryData, 'Expense Categories');
      } else if (incomeCategoryData.isNotEmpty) {
        return _buildPieChart(incomeCategoryData, 'Income Categories');
      } else {
        return _buildIncomeExpenseChart(incomeExpenseData);
      }
    } else if (_selectedChartType == 'bar') {
      // For bar chart, show expense categories if available
      if (expenseCategoryData.isNotEmpty) {
        return _buildBarChart(expenseCategoryData);
      } else if (incomeCategoryData.isNotEmpty) {
        return _buildBarChart(incomeCategoryData);
      } else {
        return _buildIncomeExpenseChart(incomeExpenseData);
      }
    } else {
      // Default to income vs expense
      return _buildIncomeExpenseChart(incomeExpenseData);
    }
  }

  Widget _buildPieChart(List<ChartData> data, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 320,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SfCircularChart(
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.name,
                  yValueMapper: (ChartData data, _) => data.amount,
                  pointColorMapper: (ChartData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ],
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<ChartData> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.currency(symbol: '₹', decimalDigits: 0),
        ),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.name,
            yValueMapper: (ChartData data, _) => data.amount,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseChart(List<ChartData> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 300,
      child: Column(
        children: [
          const Text(
            'Income vs Expenses',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.currency(symbol: '₹', decimalDigits: 0),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.name,
                  yValueMapper: (ChartData data, _) => data.amount,
                  pointColorMapper: (ChartData data, _) => data.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart,
            color: Colors.grey[300],
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'No chart data available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add transactions to see charts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(List<ChartData> categoryData, double totalExpenses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expense Category Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...categoryData.map((item) {
          final percentage = totalExpenses > 0 ? (item.amount / totalExpenses * 100) : 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.name),
                    color: item.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 4,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(item.color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${percentage.toStringAsFixed(1)}% of expenses',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '₹${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: item.color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('food')) return Icons.restaurant;
    if (name.contains('transport')) return Icons.directions_car;
    if (name.contains('shop')) return Icons.shopping_bag;
    if (name.contains('bill') || name.contains('utility')) return Icons.receipt;
    if (name.contains('entertain')) return Icons.movie;
    if (name.contains('health')) return Icons.local_hospital;
    if (name.contains('educat')) return Icons.school;
    if (name.contains('house') || name.contains('rent')) return Icons.home;
    if (name.contains('income')) return Icons.arrow_upward;
    if (name.contains('salary')) return Icons.work;
    if (name.contains('investment')) return Icons.trending_up;
    return Icons.category;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart,
            color: Colors.grey[300],
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'No transaction data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add income and expense transactions to see reports',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-transaction');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Add First Transaction'),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String name;
  final double amount;
  final Color color;

  ChartData(this.name, this.amount, this.color);
}