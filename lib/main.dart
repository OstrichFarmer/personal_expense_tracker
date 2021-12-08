import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/widgets/chart.dart';
import 'package:personal_expense_tracker/widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter app',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            caption: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white)),
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
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
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

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expense Tracker',
              style: AppBarTheme.of(context).toolbarTextStyle,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
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
          );

    final txListWidget = Container(
      height: (mediaquery.size.height -
              appbar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = ListView(
      children: [
        if (isLandscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show Chart'),
              Switch.adaptive(
                value: _showChart,
                onChanged: (bool value) {
                  setState(() {
                    _showChart = value;
                  });
                },
              )
            ],
          ),
        if (!isLandscape)
          Container(
            height: (mediaquery.size.height -
                    appbar.preferredSize.height -
                    mediaquery.padding.top) *
                0.3,
            child: Chart(_recentTransactions),
          ),
        if (!isLandscape) txListWidget,
        if (isLandscape)
          _showChart
              ? Container(
                  height: (mediaquery.size.height -
                          appbar.preferredSize.height -
                          mediaquery.padding.top) *
                      0.7,
                  child: Chart(_recentTransactions),
                )
              : txListWidget,
      ],
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Platform.isIOS
          ? CupertinoPageScaffold(
              child: pageBody,
              navigationBar: appbar,
            )
          : Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      onPressed: () => _startAddNewTransaction(context),
                      child: Icon(Icons.add),
                    ),
              appBar: appbar,
              body: pageBody),
    );
  }
}
