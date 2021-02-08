import 'package:expense_app/models/transaction.dart' as trx;
import 'package:expense_app/widgets/new_transaction.dart';
import 'package:expense_app/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/widgets/chart.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              ),
              button: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class TransactionStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("path.............." + path);
    return File('$path/sample.json');
  }

  Future<List<trx.Transaction>> getTransaction() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      final List<trx.Transaction> trxs = trx.transactionFromJson(contents);

      return trxs;
    } catch (e) {
      return List<trx.Transaction>();
    }
  }

  Future<File> writeTransaction(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<trx.Transaction> _userTransaction = [];
  int days;
  int noOfBars = 7;
  CarouselController buttonCarouselController = CarouselController();
  bool _showChart = false;
  int _currPage = 3;
  @override
  void initState() {
    super.initState();
    TransactionStorage().getTransaction().then((trxs) {
      setState(() {
        _userTransaction.addAll(trxs);
      });
    });
  }

  void _addTransaction(
      String title, String amount, DateTime choosenDate) async {
    final newTx = trx.Transaction(
        title: title,
        amount: amount,
        date: choosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransaction.insert(0, newTx);
      String transact = trx.transactionToJson(_userTransaction);
      TransactionStorage().writeTransaction(transact);
      print("transact............." + transact);
    });
  }

  void _deleteTransaction(trx.Transaction transaction) async {
    setState(() {
      _userTransaction.remove(transaction);
      TransactionStorage()
          .writeTransaction(trx.transactionToJson(_userTransaction));
    });
  }

  void _startNewTransaction(BuildContext context) {
    print(_userTransaction);
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: NewTransaction(_addTransaction),
                behavior: HitTestBehavior.opaque,
              ),
            ],
          );
        });
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show Chart'),
        Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            }),
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
          enableInfiniteScroll: false,
          onPageChanged: (int page, CarouselPageChangedReason i) {
            setState(() {
              _currPage = page;
            });
          },
          reverse: true,
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 0.98,
          aspectRatio: 1.0,
          initialPage: _currPage,
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? MediaQuery.of(context).size.height * 0.75
              : MediaQuery.of(context).size.height * 0.615),
      items: [
        DateTime.now()
            .difference(
              DateTime(DateTime.now().year, 1, 0),
            )
            .inDays,
        DateTime.now()
            .difference(
              DateTime(DateTime.now().year, DateTime.now().month, 0),
            )
            .inDays,
        7,
        1
      ].map((i) {
        return Column(children: [
          Builder(
            builder: (BuildContext context) {
              return TransactionList(
                _userTransaction,
                _deleteTransaction,
                i,
                DateTime.now(),
              );
            },
          ),
        ]);
      }).toList(),
    );
  }

  Widget _buildPortraitContent(AppBar appBar) {
    return Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                8) *
            0.8,
        child: Chart(_userTransaction, noOfBars));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_circle,
            ),
            onPressed: () => _startNewTransaction(context)),
      ],
    );

    final timeWidget = LayoutBuilder(builder: (context, constraints) {
      Widget _buildTimeButton(String text, int day, int page) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.01,
          ),
          width: constraints.maxWidth * 0.22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: FlatButton(
            color: _currPage == page
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                _currPage = page;
                days = day;
                buttonCarouselController.animateToPage(_currPage,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn);
              });
            },
            child: Text(
              text,
              style: TextStyle(
                  color: _currPage == page ? Colors.white : Colors.black,
                  fontSize: 12),
            ),
          ),
        );
      }

      return Row(
        children: <Widget>[
          _buildTimeButton('Daily', 1, 3),
          _buildTimeButton("Weekly", 7, 2),
          _buildTimeButton(
              'Monthly',
              days = DateTime.now()
                  .difference(
                    DateTime(DateTime.now().year, DateTime.now().month, 0),
                  )
                  .inDays,
              1),
          _buildTimeButton(
              'Yearly',
              days = DateTime.now()
                  .difference(
                    DateTime(DateTime.now().year, 1, 0),
                  )
                  .inDays,
              0),
        ],
      );
    });

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top -
              0) *
          0.9,
      child: _buildCarousel(),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              _buildLandscapeContent(),
            MediaQuery.of(context).orientation == Orientation.landscape
                ? _showChart
                    ? _buildPortraitContent(appBar)
                    : Column(
                        children: [timeWidget, txListWidget],
                      )
                : Column(
                    children: <Widget>[
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(_userTransaction, noOfBars),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.04,
                        child: timeWidget,
                      ),
                      _buildCarousel(),
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startNewTransaction(context)),
    );
  }
}
