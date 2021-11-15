import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/widgets/chart.dart';
import 'package:personal_expense_tracker/widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter app',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          toolbarTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 'order1', title: 'Shoes', amount: 90.21, date: DateTime.now()),
    // Transaction(
    //     id: 'order2', title: 'Clothes', amount: 34.21, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: DateTime.now());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            'Expense Tracker',
            style: AppBarTheme.of(context).toolbarTextStyle,
          ),
          actions: [
            IconButton(
              onPressed: () => _startAddNewTransaction(context),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: ListView(
          children: [
            Chart(_recentTransactions),
            TransactionList(_userTransactions),
          ],
        ),
      ),
    );
  }
}
