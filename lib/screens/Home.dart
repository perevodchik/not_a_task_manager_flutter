import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_a_task_manager/cubits/task/TaskBloc.dart';
import 'package:not_a_task_manager/repository/AppDatabase.dart';
import 'package:not_a_task_manager/screens/DayScreen.dart';
import 'package:not_a_task_manager/utils/Utils.dart';
import 'package:intl/intl.dart';
import 'package:not_a_task_manager/widgets/CalendarPage.dart';
import 'package:not_a_task_manager/widgets/DayCalendarTile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Home> {

  DateTime selectedDate = DateTime.now().firstDay();
  DateFormat format = DateFormat("dd-MM-yyyy");
  DateFormat headerFormat = DateFormat("MMMM yyyy");
  List<String> dayNames = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
  List<CalendarPage> calendarPages = [];
  // PageController? pageController = null;
  // int currentPage = 3;

  @override
  initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_)  async {
      onPageChanged(selectedDate);
      // var pageWidget = generatePage(selectedDate);
      // CalendarPage page  = CalendarPage(selectedDate, pageWidget);
      // calendarPages.add(page);
      // DateTime prev = selectedDate;
      // for(var c = 0; c < 3; c++) {
      //   prev = prev.subtract(Duration(days: 1));
      //   prev = prev.firstDay();
      //   pageWidget = generatePage(prev);
      //   CalendarPage page  = CalendarPage(prev, pageWidget);
      //   calendarPages.insert(0, page);
      // }
      // DateTime next = selectedDate;
      // for(var c = 0; c < 3; c++) {
      //   var days = DateUtils.getDaysInMonth(next.year, next.month);
      //   next = next.add(Duration(days: days));
      //   pageWidget = generatePage(prev);
      //   CalendarPage page = CalendarPage(next, pageWidget);
      //   calendarPages.add(page);
      // }
      // calendarPages.sort((i0, i1) => i0.date.millisecondsSinceEpoch.compareTo(i1.date.millisecondsSinceEpoch));

      // pageController = PageController(initialPage: 3);
      // pageController/.jumpToPage(pageController?.page + 1 ?? cP);
      // setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    // pageController?.dispose();
    super.dispose();
  }

  Widget generatePage(DateTime date) {
    var size = MediaQuery.of(context).size;
    var rows = _createRows(date, size);
    var col = Column(children: rows);
    return col;
  }

  Future<void> prevMonth() async {
    selectedDate = selectedDate.subtract(Duration(days: 1));
    selectedDate = selectedDate.firstDay();
    onPageChanged(selectedDate);
    setState(() {});
    // pageController?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
  }

  Future<void> nextMonth() async {
    var days = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
    selectedDate = selectedDate.add(Duration(days: days + 2)).firstDay();
    onPageChanged(selectedDate);
    setState(() {});
    // pageController?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
  }

  Future<void> onPageChanged(DateTime newDate) async {
    var from = newDate;
    var days = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
    var to = newDate.add(Duration(days: days));
    var tasks = await AppDatabase.db?.getTasksByRange(from, to) ?? {};
    BlocProvider.of<TaskBloc>(context).add(EventTaskLoadedMultipleDate(newDate, tasks));
  }

  List<Widget> _createRows(DateTime date, Size size) {
    var rowsData = <Map<int, DateTime>> [];
    var days = DateUtils.getDaysInMonth(date.year, date.month);
    var d = date.firstDay();
    var currentMap = <int, DateTime> {};
    for(var c = 0; c < days; c++) {
      d = date.add(Duration(days: c));
      currentMap[d.weekday] = d;
      if(d.weekday % 7 == 0) {
        rowsData.add(currentMap);
        currentMap = <int, DateTime> {};
      }
    }
    if(currentMap.isNotEmpty)
      rowsData.add(currentMap);
    var minElementInFirstWeek = 7;
    var maxElementInLastWeek = 0;

    for(var d in rowsData.first.entries) {
      if(d.key < minElementInFirstWeek)
        minElementInFirstWeek = d.key;
    }
    while(minElementInFirstWeek > 1) {
      var d = date.firstDay().subtract(Duration(days: --minElementInFirstWeek));
      rowsData.first[d.weekday] = d;
    }

    for(var d in rowsData.last.entries) {
      if(d.key > maxElementInLastWeek)
        maxElementInLastWeek = d.key;
    }
    while(maxElementInLastWeek < 7) {
      var days = DateUtils.getDaysInMonth(date.year, date.month);
      var d = date.firstDay().add(Duration(days: days + 7 - (++maxElementInLastWeek)));
      rowsData.last[d.weekday] = d;
    }
    var rows = <Widget> [];
    for(var set in rowsData) {
      var rowWidgets = <Widget> [];
      for(var c = 1; c < 8; c++) {
        var _date = set[c];
        if(_date == null) {
          rowWidgets.add(
              Container(
                  width: size.width / 7,
                  child: Text("", textAlign: TextAlign.center)
              )
          );
        } else {
          rowWidgets.add(
              BlocBuilder<TaskBloc, TaskState>(
                builder: (_, state) {
                  var tasks = 0;
                  if(state is StateTaskLoaded) {
                    tasks = state.data[_date]?.length ?? 0;
                  }
                  return DayCalendarTile(_date, tasks, size.width / 7, _date.month == date.month, () {
                    Navigator.push(context, CupertinoPageRoute(builder: (_) => DayScreen(_date)));
                  });
                }
              )
          );
        }
      }
      rows.add(Row(children: rowWidgets));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: null
        ),
        body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          child: Icon(Icons.arrow_back_ios),
                          onTap: () => prevMonth()
                      ),
                      Container(
                        width: size.width * .5,
                        child: Text(headerFormat.format(selectedDate), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                      ),
                      GestureDetector(
                          child: Icon(Icons.arrow_forward_ios),
                          onTap: () => nextMonth()
                      )
                    ]
                )
              ),
              Row(
                children: dayNames.map<Widget>((d) => SizedBox(
                  height: 20,
                  width: size.width / 7,
                  child: Text(d, textAlign: TextAlign.center)
                )).toList()
              ),
              Container(
                width: size.width,
                height: size.height * .5,
                child: Column(
                  children: [
                    ..._createRows(selectedDate, size)
                  ]
                )
    // PageView(
    //                 controller: pageController,
    //                 onPageChanged: (p) {
                      // print("to $p from $currentPage");
                      // var prevDate = selectedDate;
                      // selectedDate = calendarPages[p].date;
                      // if (p == calendarPages.length - 1) {
                      //   print("$p page, add page to end");
                      //   var date = calendarPages.last.date;
                      //   var days = DateUtils.getDaysInMonth(date.year, date.month);
                      //   date = date.add(Duration(days: days + 1)).firstDay();
                      //   var w = _createRows(date, size);
                      //   var calendarPage = CalendarPage(date, Column(children: [...w, Text("$date")]));
                      //   calendarPages.add(calendarPage);
                      //   setState(() {});
                      // }
                      // if (p == 1) {
                      //   print("$p page, add page to start");
                      //
                      //   var date = calendarPages.first.date;
                      //   date = date.subtract(Duration(days: 1)).firstDay();
                      //   var w = _createRows(date, size);
                      //   var calendarPage = CalendarPage(date, Column(children: [...w, Text("$date")]));
                      //   calendarPages = [calendarPage, ...calendarPages];
                      //   var prevPageIndex = calendarPages.indexWhere((p) => p.date == prevDate);
                      //   print("prevPageIndex  $prevPageIndex");
                      //   pageController?.jumpTo(prevPageIndex + .0);
                      // }
                      // setState(() {});
                      // currentPage = p;
                    // },
                    // children: calendarPages.map<Widget>((e) => e).toList()
                // )
              )
            ]
        )
    );
  }
}