// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import './transaction.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter app',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    Transaction(
        id: 'order1', title: 'Shoes', amount: 90.21, date: DateTime.now()),
    Transaction(
        id: 'order2', title: 'Clothes', amount: 34.21, date: DateTime.now()),
  ];

  String titleInput;

  String amountInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Card(
              color: Colors.blue,
              child: Text(
                'CHART',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    onChanged: (val) {
                      titleInput = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    onChanged: (val) {
                      amountInput = val;
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        print(titleInput);
                        print(amountInput);
                      },
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(color: Colors.purpleAccent),
                      ))
                ],
              ),
            ),
          ),
          Column(
            children: transactions.map((tx) {
              return Card(
                elevation: 3,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.purpleAccent, width: 2)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        '\$${tx.amount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.purpleAccent),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(tx.date),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
