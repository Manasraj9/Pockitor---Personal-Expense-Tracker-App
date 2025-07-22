import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetController = TextEditingController();

  double _monthlyBudget = 0;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    _monthlyBudget = box.get('monthlyBudget', defaultValue: 0.0);
    _budgetController.text = _monthlyBudget.toStringAsFixed(2);
  }

  void _saveBudget() {
    final box = Hive.box('settings');
    final entered = double.tryParse(_budgetController.text);
    if (entered != null && entered >= 0) {
      box.put('monthlyBudget', entered);
      setState(() {
        _monthlyBudget = entered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Hive.box<Expense>('expenses')
        .values
        .where((e) => e.date.month == DateTime.now().month)
        .toList();

    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final remaining = _monthlyBudget - totalSpent;

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Set Monthly Budget'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveBudget,
              child: const Text('Save Budget'),
            ),
            const SizedBox(height: 20),
            Text('Total Spent: ₹${totalSpent.toStringAsFixed(2)}'),
            Text('Remaining: ₹${remaining.toStringAsFixed(2)}',
                style: TextStyle(
                    color: remaining < 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
