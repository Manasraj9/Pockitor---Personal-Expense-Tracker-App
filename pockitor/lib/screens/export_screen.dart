import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({Key? key}) : super(key: key);

  Future<void> _exportData(BuildContext context) async {
    final expenseBox = Hive.box<Expense>('expenses');
    final expenses = expenseBox.values.toList();

    final List<List<String>> csvData = [
      ['Title', 'Amount', 'Category', 'Date'],
      ...expenses.map((e) => [
        e.title,
        e.amount.toStringAsFixed(2),
        e.category,
        e.date.toIso8601String(),
      ])
    ];

    final csv = const ListToCsvConverter().convert(csvData);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pockitor_expenses.csv');

    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(file.path)], text: 'My Expense Data from Pockitor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Expenses')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.file_download),
          label: const Text('Export as CSV & Share'),
          onPressed: () => _exportData(context),
        ),
      ),
    );
  }
}
