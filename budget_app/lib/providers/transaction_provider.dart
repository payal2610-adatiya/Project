import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';
import '../data/services/api_service.dart';
import '../data/services/local_storage.dart';
import '../data/services/sync_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    await LocalStorage.init();
    _transactions = LocalStorage.getTransactions();
    notifyListeners();
  }

  Future<void> fetchTransactions(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final transactions = await ApiService.getTransactions(userId);
      if (transactions.isNotEmpty) {
        _transactions = transactions;
        await LocalStorage.saveTransactions(transactions);
        _errorMessage = '';
      } else {
        // Load from local storage if API returns empty
        final localTransactions = LocalStorage.getTransactions();
        _transactions = localTransactions;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch transactions';
      // Load from local storage on error
      final localTransactions = LocalStorage.getTransactions();
      _transactions = localTransactions;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTransaction({
    required String userId,
    required String categoryId,
    required String amount,
    required String date,
    String note = '',
    required String categoryName,
    required String categoryType, // Add this parameter
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.addTransaction(
        userId: userId,
        categoryId: categoryId,
        amount: amount,
        date: date,
        note: note,
        categoryName: categoryName,
        categoryType: categoryType, // Pass to API
      );

      if (result['success'] == true) {
        // Create new transaction with correct category type
        final newTransaction = Transaction(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          userId: userId,
          categoryId: categoryId,
          categoryName: categoryName,
          categoryType: categoryType, // Use the passed category type
          amount: double.parse(amount),
          date: DateTime.parse(date),
          note: note,
          createdAt: DateTime.now(),
        );

        _transactions.add(newTransaction);
        await LocalStorage.saveTransactions(_transactions);

        // Refresh from server to get complete data
        await fetchTransactions(userId);
        await SyncService.syncPendingOperations();
        return true;
      } else {
        // Save locally for offline support with correct category type
        _errorMessage = result['message'] ?? 'Failed to add transaction';

        final newTransaction = Transaction(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          userId: userId,
          categoryId: categoryId,
          categoryName: categoryName,
          categoryType: categoryType, // Use the passed category type
          amount: double.parse(amount),
          date: DateTime.parse(date),
          note: note,
          createdAt: DateTime.now(),
        );

        await LocalStorage.addPendingTransaction(newTransaction);
        _transactions.add(newTransaction);
        await LocalStorage.saveTransactions(_transactions);

        return true;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';

      // Save locally for offline support with correct category type
      final newTransaction = Transaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: userId,
        categoryId: categoryId,
        categoryName: categoryName,
        categoryType: categoryType, // Use the passed category type
        amount: double.parse(amount),
        date: DateTime.parse(date),
        note: note,
        createdAt: DateTime.now(),
      );

      await LocalStorage.addPendingTransaction(newTransaction);
      _transactions.add(newTransaction);
      await LocalStorage.saveTransactions(_transactions);

      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.deleteTransaction(transactionId);

      if (result['success'] == true) {
        _transactions.removeWhere((t) => t.id == transactionId);
        await LocalStorage.saveTransactions(_transactions);
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Failed to delete transaction';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Transaction> getRecentTransactions({int count = 5}) {
    try {
      _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return _transactions.take(count).toList();
    } catch (e) {
      return [];
    }
  }

  List<Transaction> getTransactionsByCategory(String categoryId) {
    try {
      return _transactions.where((t) => t.categoryId == categoryId).toList();
    } catch (e) {
      return [];
    }
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    try {
      return _transactions.where((t) {
        return t.date.isAfter(start) && t.date.isBefore(end);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  List<Transaction> getTransactionsByType(String type) {
    try {
      return _transactions.where((t) => t.categoryType.toLowerCase() == type.toLowerCase()).toList();
    } catch (e) {
      return [];
    }
  }

  List<Transaction> getExpenses() {
    try {
      return _transactions.where((t) => t.isExpense).toList();
    } catch (e) {
      return [];
    }
  }

  List<Transaction> getIncome() {
    try {
      return _transactions.where((t) => t.isIncome).toList();
    } catch (e) {
      return [];
    }
  }

  double getTotalExpenses() {
    try {
      return getExpenses().fold(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  double getTotalIncome() {
    try {
      return getIncome().fold(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  double getBalance() {
    try {
      return getTotalIncome() - getTotalExpenses();
    } catch (e) {
      return 0.0;
    }
  }

  // Get total for a specific category
  double getTotalForCategory(String categoryId) {
    try {
      final categoryTransactions = getTransactionsByCategory(categoryId);
      return categoryTransactions.fold(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  // Get total for a specific category type (income/expense)
  double getTotalForCategoryType(String type) {
    try {
      final typeTransactions = getTransactionsByType(type);
      return typeTransactions.fold(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  // Get monthly totals
  Map<String, double> getMonthlyExpenses() {
    try {
      final Map<String, double> monthlyExpenses = {};
      final expenses = getExpenses();

      for (var expense in expenses) {
        final monthKey = "${expense.date.year}-${expense.date.month}";
        monthlyExpenses.update(
          monthKey,
              (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }

      return monthlyExpenses;
    } catch (e) {
      return {};
    }
  }

  // Get monthly income
  Map<String, double> getMonthlyIncome() {
    try {
      final Map<String, double> monthlyIncome = {};
      final income = getIncome();

      for (var inc in income) {
        final monthKey = "${inc.date.year}-${inc.date.month}";
        monthlyIncome.update(
          monthKey,
              (value) => value + inc.amount,
          ifAbsent: () => inc.amount,
        );
      }

      return monthlyIncome;
    } catch (e) {
      return {};
    }
  }

  // Filter transactions by month
  List<Transaction> getTransactionsByMonth(int year, int month) {
    try {
      return _transactions.where((t) {
        return t.date.year == year && t.date.month == month;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Add a helper method to update transaction category info
  void updateTransactionCategoryInfo(String transactionId, String categoryName, String categoryType) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        categoryName: categoryName,
        categoryType: categoryType,
      );
      notifyListeners();
      // Save to local storage
      LocalStorage.saveTransactions(_transactions);
    }
  }
}