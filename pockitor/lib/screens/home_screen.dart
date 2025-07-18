import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final expenseBox = Hive.box<Expense>('expenses');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pockitor'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No expenses added yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final expense = box.getAt(index);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    expense!.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${expense.category} • ${formatDate(expense.date)}',
                  ),
                  trailing: Text(
                    '₹${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // Delete on long press
                    expense.delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
