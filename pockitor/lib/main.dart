import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');
  
  runApp(const PockitorApp());
}

class PockitorApp extends StatelessWidget {
  const PockitorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pockitor',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
