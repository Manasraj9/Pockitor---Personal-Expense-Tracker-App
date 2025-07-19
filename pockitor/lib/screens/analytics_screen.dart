import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  Map<String, double> calculateCategoryData(Box<Expense> box) {
    Map<String, double> data = {};
    for (var expense in box.values) {
      data[expense.category] = (data[expense.category] ?? 0) + expense.amount;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Expense>('expenses');
    final categoryData = calculateCategoryData(box);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: categoryData.isEmpty
            ? const Center(child: Text("No data to show."))
            : PieChart(
                PieChartData(
                  sections: categoryData.entries.map((entry) {
                    return PieChartSectionData(
                      color: Colors.primaries[
                          categoryData.keys.toList().indexOf(entry.key) %
                              Colors.primaries.length],
                      value: entry.value,
                      title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
                      radius: 80,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontSize: 14),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
