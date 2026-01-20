import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class ExpenseService {
  // Name of the Hive box (like a table name in SQL)
  static const String _boxName = 'expenses';

  // Get reference to the Hive box
  Box<Expense> _getBox() {
    return Hive.box<Expense>(_boxName);
  }

  // CREATE - Add a new expense to database
  Future<void> addExpense(Expense expense) async {
    final box = _getBox();
    await box.add(expense);
  }

  // READ - Get all expenses from database
  List<Expense> getAllExpenses() {
    final box = _getBox();
    return box.values.toList();
  }

  // READ - Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    final box = _getBox();
    return box.values
        .where((expense) => expense.category == category)
        .toList();
  }

  // READ - Get expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    final box = _getBox();
    return box.values
        .where((expense) =>
    expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // UPDATE - Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await expense.save(); // HiveObject provides save() method
  }

  // DELETE - Remove an expense from database
  Future<void> deleteExpense(Expense expense) async {
    await expense.delete(); // HiveObject provides delete() method
  }

  // DELETE - Remove expense by key
  Future<void> deleteExpenseByKey(dynamic key) async {
    final box = _getBox();
    await box.delete(key);
  }

  // UTILITY - Get total spending
  double getTotalSpending() {
    final box = _getBox();
    return box.values.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // UTILITY - Get spending by category
  Map<String, double> getSpendingByCategory() {
    final box = _getBox();
    Map<String, double> categoryTotals = {};

    for (var expense in box.values) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryTotals;
  }

  // UTILITY - Clear all expenses (useful for testing)
  Future<void> clearAll() async {
    final box = _getBox();
    await box.clear();
  }
}