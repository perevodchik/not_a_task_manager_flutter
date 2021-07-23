import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DayCalendarTile extends StatelessWidget {
  final DateTime date;
  final int tasks;
  final double width;
  final bool isCurrentMonth;
  final Function onTap;
  DayCalendarTile(this.date, this.tasks, this.width, this.isCurrentMonth, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: width,
      height: width,
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onTap.call(),
          child: Container(
              decoration: BoxDecoration(
                  color: isCurrentMonth ? Colors.grey.withOpacity(.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Stack(
                children: [
                  Center(
                      child: Text("${date.day}", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))
                  ),
                  if(tasks > 0)
                    Positioned(
                      right: 5, top: 5,
                      child: Text("$tasks", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold))
                    )
                ]
              )
          )
      )
    );
  }
}