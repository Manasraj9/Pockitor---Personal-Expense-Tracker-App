import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _clearAllExpenses(BuildContext context) async {
    final box = Hive.box<Expense>('expenses');
    await box.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All expenses cleared!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text("Clear All Expenses"),
              onTap: () => _clearAllExpenses(context),
            ),
          ],
        ),
      ),
    );
  }
}
