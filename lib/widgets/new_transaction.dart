import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx;
  NewTransaction(this.addtx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  final focus = FocusNode();
  bool _validate = false;

  void _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text;
    if (enteredTitle.isEmpty ||
        int.parse(_amountController.text) <= 0 ||
        _selectedDate == null) {
      setState(() {
        _validate = true;
      });

      return;
    }

    widget.addtx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    setState(() {
      _validate = false;
    });

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 10,
        child: Container(
          margin: EdgeInsets.all(4),
          height: MediaQuery.of(context).viewInsets.bottom + 260,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _validate
                  ? Text(
                      'Please Enter Valid Values.',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: Colors.red),
                    )
                  : Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus);
                },
              ),
              TextFormField(
                  focusNode: focus,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _presentDatePicker();
                  }),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : DateFormat.yMMMd().format(_selectedDate),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: _presentDatePicker,
                      child: Text('Choose Date'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: _submitData,
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
