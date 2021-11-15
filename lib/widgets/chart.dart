import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  // const Chart(List<Transaction> recentTransactions, {Key key, this.recentTransactions}) : super(key: key);

  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // print(DateFormat.E().format(weekDay).substring(0, 1));
      // print(totalSum);
      return {
        'days': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['days'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
