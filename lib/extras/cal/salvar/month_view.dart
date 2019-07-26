import 'package:flutter/material.dart';
import 'package:illapa/extras/cal/day_number.dart';
import 'package:illapa/extras/cal/month_title.dart';
import 'package:illapa/extras/cal/utils/dates.dart';
import 'package:illapa/extras/cal/utils/screen_sizes.dart';


class MonthView extends StatelessWidget {
  const MonthView({
    @required this.context,
    @required this.year,
    @required this.month,
    @required this.padding,
    this.todayColor,
    this.monthNames,
    this.onMonthTap,
  });

  final BuildContext context;
  final int year;
  final int month;
  final double padding;
  final Color todayColor;
  final List<String> monthNames;
  final Function onMonthTap;

  Widget buildMonthDays(BuildContext context) {
    final List<Row> dayRows = <Row>[];
    final List<DayNumber> dayRowChildren = <DayNumber>[];

    final int daysInMonth = getDaysInMonth(year, month);
    final int firstWeekdayOfMonth = DateTime(year, month, 1).weekday;

    for (int day = 2 - firstWeekdayOfMonth; day <= daysInMonth; day++) {
      final bool isToday = dateIsToday(DateTime(year, month, day));
      final bool isTodays = dateIsToday(DateTime(year, month, day));
      bool pintar;
      // String dateUno = '2019-05-02 00:00:00.000';
      DateTime dateuno = new DateTime(2018, 5, 2);
      DateTime datedos = DateTime(2019, 2, 15);
      DateTime datetres = DateTime(2019, 10, 25);
      DateTime datecuatro = DateTime(2019, 12, 4);

      DateTime actual = new DateTime(year, month, day);
      
        if(actual == dateuno || actual == datedos || actual == datetres || actual == datecuatro ){
          pintar = true;
        }else{
          pintar = false;
        }
      

      
      dayRowChildren.add(
        DayNumber(
          day: day,
          isToday: pintar,
          todayColor: todayColor,
        ),
      );

      if ((day - 1 + firstWeekdayOfMonth) % DateTime.daysPerWeek == 0 ||
          day == daysInMonth) {
        dayRows.add(
          Row(
            children: List<DayNumber>.from(dayRowChildren),
          ),
        );
        dayRowChildren.clear();
      }
    }
    // final  isTodaysa = Date(2019, 06, 05);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(2019, 5, 2);
    // final bool isTodays = dateIsToday(DateTime(year, month, 05));
    int years = now.year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        // Text('$date'),
        Column(
          children: dayRows
        )
      ],
      
    );
  }

  Widget buildMonthView(BuildContext context) {
    return Container(
      width: 7 * getDayNumberSize(context),
      margin: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MonthTitle(
            month: month,
            monthNames: monthNames,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: buildMonthDays(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return onMonthTap == null
        ? Container(
            child: buildMonthView(context),
          )
        : FlatButton(
            onPressed: () => this.onMonthTap(year, month),
            padding: const EdgeInsets.all(0.0),
            child: buildMonthView(context),
          );
  }
}
