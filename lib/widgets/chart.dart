import 'package:expense_app/models/transaction.dart';
import 'package:expense_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final int noOfBars;
  Chart(this.recentTransactions, this.noOfBars);
  static int ind = 0;
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(noOfBars, (ind) {
      final weekDay = DateTime.now().subtract(
        Duration(days: ind),
      );
      int totalSum = 0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += int.parse(recentTransactions[i].amount);
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'date': DateFormat.MMMd().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            reverse: true,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: groupedTransactionValues.map((data) {
                    return Container(
                      width: (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).padding.horizontal) *
                          0.125,
                      color: Theme.of(context).accentColor,
                      child: ChartBar(
                          data['day'],
                          data['date'],
                          data['amount'],
                          totalSpending == 0.0
                              ? 0.0
                              : (data['amount'] as int) / totalSpending),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}
