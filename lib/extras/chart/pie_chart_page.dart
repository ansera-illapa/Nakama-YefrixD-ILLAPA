import 'package:flutter/material.dart';
import 'package:illapa/extras/chart/samples/pie_chart_sample2.dart';


class PieChartPage extends StatelessWidget {
  final Color barColor = Colors.white;
  final Color barBackgroundColor = Color(0xff72d8bf);
  final double width = 22;


  @override
  Widget build(BuildContext context) {
    return Container(
      
      // color: Color(0xffeceaeb),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                // child: Text(
                //   "Pie ChartS",
                //   style: TextStyle(
                //       color: Color(
                //         0xff333333,
                //       ),
                //       fontSize: 32,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            ),
            
            // SizedBox(
            //   height: 12,
            // ),
            PieChartSample2(),
            PieChartSample2(),
          ],
        ),
      ),
    );
  }
}
