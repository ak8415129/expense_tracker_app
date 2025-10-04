
import 'package:flutter/material.dart';

import '../models/budget_model.dart';
import '../services/firestore_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedPeriod = 'monthly';

  final FirestoreService _firestoreService = FirestoreService();
  Budget? _currentBudget;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  void _loadBudget() async {
    final budget = await _firestoreService.getBudget().first;
    if (budget != null) {
      setState(() {
        _currentBudget = budget;
        _amountController.text = budget.amount.toString();
        _selectedPeriod = budget.period;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Budget Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedPeriod,
                items: ['monthly', 'weekly'].map((period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period.capitalize()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriod = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Period'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBudget,
                child: Text('Save Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      final budget = Budget(
        id: _currentBudget?.id ?? _firestoreService.getCurrentUserId()!,
        userId: _firestoreService.getCurrentUserId()!,
        amount: double.parse(_amountController.text),
        period: _selectedPeriod,
      );

      await _firestoreService.setBudget(budget);

      Navigator.of(context).pop();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
