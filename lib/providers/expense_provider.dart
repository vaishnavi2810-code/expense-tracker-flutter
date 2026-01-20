import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  // Instance of ExpenseService to interact with database
  final ExpenseService _expenseService = ExpenseService();

  // Private list to store expenses
  List<Expense> _expenses = [];

  // Selected category filter (null means show all)
  String? _selectedCategory;

  // Date range filter
  DateTime? _startDate;
  DateTime? _endDate;

  // Public getter - UI can read but not modify directly
  List<Expense> get expenses {
    // Apply filters
    List<Expense> filtered = _expenses;

    // Filter by category if selected
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered
          .where((expense) => expense.category == _selectedCategory)
          .toList();
    }

    // Filter by date range if set
    if (_startDate != null && _endDate != null) {
      filtered = filtered
          .where((expense) =>
      expense.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(_endDate!.add(const Duration(days: 1))))
          .toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  }

  // Getters for filters
  String? get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Get total spending (considering filters)
  double get totalSpending {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get spending by category (considering filters)
  Map<String, double> get spendingByCategory {
    Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryTotals;
  }

  // INITIALIZATION - Load expenses from database when app starts
  Future<void> loadExpenses() async {
    _expenses = _expenseService.getAllExpenses();
    notifyListeners(); // Tell UI to rebuild
  }

  // CREATE - Add new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseService.addExpense(expense);
    await loadExpenses(); // Reload from database
    notifyListeners(); // Tell UI to rebuild
  }

  // UPDATE - Edit existing expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseService.updateExpense(expense.id, expense);
    await loadExpenses();
    notifyListeners(); // Tell UI to rebuild
  }

  // DELETE - Remove expense
  Future<void> deleteExpense(Expense expense) async {
    await _expenseService.deleteExpense(expense);
    await loadExpenses(); // Reload from database
    notifyListeners(); // Tell UI to rebuild
  }

  // FILTER - Set category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners(); // Tell UI to rebuild with filtered data
  }

  // FILTER - Set date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners(); // Tell UI to rebuild with filtered data
  }

  // FILTER - Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    notifyListeners(); // Tell UI to rebuild
  }

  // UTILITY - Clear all expenses (for testing)
  Future<void> clearAllExpenses() async {
    await _expenseService.clearAll();
    await loadExpenses();
    notifyListeners();
  }
}