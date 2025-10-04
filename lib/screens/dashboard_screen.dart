
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../providers/theme_provider.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Expense>>(
        stream: firestoreService.getExpenses(),
        builder: (context, expenseSnapshot) {
          if (!expenseSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final expenses = expenseSnapshot.data!;

          return StreamBuilder<Budget?>(
            stream: firestoreService.getBudget(),
            builder: (context, budgetSnapshot) {
              final budget = budgetSnapshot.data;

              return StreamBuilder<List<Category>>(
                stream: firestoreService.getCategories(),
                builder: (context, categorySnapshot) {
                  if (!categorySnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final categories = categorySnapshot.data!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBudgetSummary(context, expenses, budget),
                        SizedBox(height: 20),
                        _buildCategorySpending(context, expenses, categories),
                        SizedBox(height: 20),
                        _buildRecentExpenses(context, expenses, categories),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add_expense');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetSummary(BuildContext context, List<Expense> expenses, Budget? budget) {
    final totalSpending = expenses.fold(0.0, (sum, item) => sum + item.amount);
    final remainingBudget = (budget?.amount ?? 0) - totalSpending;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Spending this month', style: Theme.of(context).textTheme.headline6),
            Text('\$${totalSpending.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 10),
            if (budget != null) ...[
              LinearProgressIndicator(
                value: totalSpending / budget.amount,
                minHeight: 10,
              ),
              SizedBox(height: 10),
              Text('Remaining: \$${remainingBudget.toStringAsFixed(2)}'),
            ],
            ElevatedButton(
              onPressed: () {
                context.go('/budget');
              },
              child: Text(budget == null ? 'Set Budget' : 'Update Budget'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySpending(BuildContext context, List<Expense> expenses, List<Category> categories) {
    final categorySpending = <String, double>{};
    for (var expense in expenses) {
      categorySpending.update(expense.categoryId, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Spending by Category', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categorySpending.entries.map((entry) {
                    final category = categories.firstWhere((cat) => cat.id == entry.key, orElse: () => Category(id: '', name: 'Unknown', colorValue: Colors.grey.value));
                    return PieChartSectionData(
                      color: category.color,
                      value: entry.value,
                      title: category.name,
                      radius: 50,
                    );
                  }).toList(),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/add_category');
              },
              child: Text('Manage Categories'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentExpenses(BuildContext context, List<Expense> expenses, List<Category> categories) {
    final recentExpenses = expenses.take(5).toList();

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Recent Expenses', style: Theme.of(context).textTheme.headline6),
            trailing: TextButton(
              onPressed: () {
                context.go('/expense_history');
              },
              child: Text('View All'),
            ),
          ),
          ...recentExpenses.map((expense) {
            final category = categories.firstWhere((cat) => cat.id == expense.categoryId, orElse: () => Category(id: '', name: 'Unknown', colorValue: Colors.grey.value));
            return ListTile(
              leading: CircleAvatar(backgroundColor: category.color),
              title: Text(expense.description),
              subtitle: Text(category.name),
              trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
              onTap: () {
                context.go('/add_expense', extra: expense);
              },
            );
          }),
        ],
      ),
    );
  }
}
