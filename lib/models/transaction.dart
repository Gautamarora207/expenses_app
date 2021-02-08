import 'package:flutter/foundation.dart';
import 'dart:convert';

List<Transaction> transactionFromJson(String str) => List<Transaction>.from(
    json.decode(str).map((x) => Transaction.fromJson(x)));

String transactionToJson(List<Transaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
  String id;
  String title;
  String amount;
  DateTime date;
  bool delete;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    this.delete = false,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        title: json["title"],
        amount: json["amount"],
        date: DateTime.parse(json["date"]),
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "date": date.toIso8601String(),
        "delete": delete,
      };
}
