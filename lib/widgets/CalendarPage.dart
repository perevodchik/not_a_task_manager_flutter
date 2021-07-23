import 'package:flutter/cupertino.dart';

class CalendarPage extends StatelessWidget {
  final DateTime date;
  final Widget child;
  CalendarPage(this.date, this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}