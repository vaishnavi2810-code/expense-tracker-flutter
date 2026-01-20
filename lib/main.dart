import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/expense.dart';
import 'providers/expense_provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the ExpenseAdapter with Hive
  Hive.registerAdapter(ExpenseAdapter());

  // Open the expenses box
  await Hive.openBox<Expense>('expenses');

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider()..loadExpenses(),
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const TestScreen(),
      ),
    );
  }
}

// Temporary test screen to verify everything works
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker - Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Expenses: ${provider.expenses.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Spending: \$${provider.totalSpending.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _addTestExpense(context),
                  child: const Text('Add Test Expense'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _clearAllExpenses(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear All'),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: provider.expenses.isEmpty
                      ? const Text('No expenses yet. Add some!')
                      : ListView.builder(
                    itemCount: provider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = provider.expenses[index];
                      return ListTile(
                        title: Text(expense.title),
                        subtitle: Text(expense.category),
                        trailing: Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addTestExpense(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    // Create a random test expense
    final testExpenses = [
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Lunch at Restaurant',
        amount: 25.50,
        category: 'Food',
        date: DateTime.now(),
        notes: 'Test expense',
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Bus Fare',
        amount: 5.00,
        category: 'Transport',
        date: DateTime.now(),
        notes: 'Test expense',
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Movie Ticket',
        amount: 15.00,
        category: 'Entertainment',
        date: DateTime.now(),
        notes: 'Test expense',
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Grocery Shopping',
        amount: 85.75,
        category: 'Shopping',
        date: DateTime.now(),
        notes: 'Test expense',
      ),
    ];

    // Pick a random expense
    final randomExpense = testExpenses[DateTime.now().second % testExpenses.length];

    provider.addExpense(randomExpense);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added: ${randomExpense.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _clearAllExpenses(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    provider.clearAllExpenses();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All expenses cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}