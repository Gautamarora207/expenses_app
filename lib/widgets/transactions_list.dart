import 'package:expense_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTrx;
  final int days;
  final DateTime date;

  TransactionList(
    this.transactions,
    this.deleteTrx,
    this.days,
    this.date,
  );

  int get sum {
    int totalSum = 0;
    List.generate(days, (index) {
      totalSum = 0;
      for (var i = 0; i < transactions.length; i++) {
        if (date
                    .difference(
                      transactions[i].date,
                    )
                    .inDays -
                1 <=
            days) {
          totalSum += int.parse(transactions[i].amount);
        }
      }

      return totalSum;
    });
    return totalSum;
  }

  String get dates {
    String str = '';
    String date1 = DateFormat.yMMMd().format(DateTime.now());
    String date2 = DateFormat.yMMMd()
        .format(DateTime.now().subtract(new Duration(days: days - 1)));
    (date1 == date2) ? str = date2 : str = '$date2 - $date1';
    return str;
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.length == 0) {
      return Column(
        children: <Widget>[
          Text(
            "Add a Transaction Below",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );
    }
    return Column(
      children: <Widget>[
        MediaQuery.of(context).orientation == Orientation.landscape
            ? Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Text(
                  '$dates',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  '$dates',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
        MediaQuery.of(context).orientation == Orientation.landscape
            ? Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Text(
                  'Total Expense : ₹${sum.toString()}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  'Total Expense : ₹${sum.toString()}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.47,
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (transactions[index].date.isAfter(
                    date.subtract(
                      Duration(days: days),
                    ),
                  )) {
                return TransactionItem(
                    transaction: transactions[index], deleteTrx: deleteTrx);
              } else {
                return Container();
              }
            },
            itemCount: transactions.length,
          ),
        ),
      ],
    );
  }
}
