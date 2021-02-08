// import 'package:expense_app/main.dart';
// import 'package:flutter/material.dart';

// class TimesWidget extends StatefulWidget {
//   @override
//   _TimesWidgetState createState() => _TimesWidgetState();
// }

// class _TimesWidgetState extends State<TimesWidget> {
//   int days = 1;
//   getdays(int days) {
//     setState(() {
//       MyHomePage(days);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return Row(
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.symmetric(
//               horizontal: constraints.maxWidth * 0.01,
//             ),
//             width: constraints.maxWidth * 0.22,
//             child: RaisedButton(
//               color: Theme.of(context).accentColor,
//               onPressed: () {
//                 setState(() {
//                   getdays(1);
//                 });
//               },
//               child: Text('Today'),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(
//               horizontal: constraints.maxWidth * 0.01,
//             ),
//             width: constraints.maxWidth * 0.22,
//             child: RaisedButton(
//               color: Theme.of(context).accentColor,
//               onPressed: () {
//                 setState(() {
//                   getdays(7);
//                 });
//               },
//               child: Text('Last 7 days'),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(
//               horizontal: constraints.maxWidth * 0.01,
//             ),
//             width: constraints.maxWidth * 0.22,
//             child: RaisedButton(
//               color: Theme.of(context).accentColor,
//               onPressed: () {
//                 setState(() {
//                   getdays(30);
//                 });
//               },
//               child: Text('Last 30 days'),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(
//               horizontal: constraints.maxWidth * 0.01,
//             ),
//             width: constraints.maxWidth * 0.22,
//             child: RaisedButton(
//               color: Theme.of(context).accentColor,
//               onPressed: () {
//                 setState(() {
//                   getdays(365);
//                 });
//               },
//               child: Text('Last 365 days'),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
