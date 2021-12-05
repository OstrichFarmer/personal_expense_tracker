import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTx;
  final List<Transaction> transactions;
  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: [
              Text(
                'No transactions added',
                style: AppBarTheme.of(context).toolbarTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ))
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text('\$${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transactions[index].id),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
