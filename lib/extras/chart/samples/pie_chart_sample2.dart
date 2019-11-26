import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:illapa/extras/chart/samples/indicator.dart';
import 'package:intl/intl.dart';


class PieChartSample2 extends StatelessWidget {
  final double porcentajeVencido; 
  final double porcentajeVigente; 
  final double porcentajePagado; 
  
  final double vencido; 
  final double vigente; 
  final double pagado; 

  final String tipoEstadistica;
  final double total;

  

  

  PieChartSample2({Key key ,
                    this.porcentajeVencido, 
                    this.porcentajeVigente, 
                    this.porcentajePagado, 
                    
                    this.vencido,
                    this.vigente,
                    this.pagado,
                    this.total,

                    this.tipoEstadistica
                    }) : super(key: key );


  
  
  var moneyType = new NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        
        color: Color(0xFF070D59),
        // shape: StadiumBorder(side: BorderSide()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          
          
        ),

        child: Column(
          children: <Widget>[
            
            Text('$tipoEstadistica ( ${moneyType.format(total)} )', style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),),
            
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1, //Espacio entre porcentajes
                      centerSpaceRadius: 50, //ESPACIO DEL MEDIO
                      sections: [

                        PieChartSectionData(
                          color: Color(0xfff5893d4),
                          value: porcentajeVigente,
                          title: "$porcentajeVigente% (${moneyType.format(vigente)}) ",
                          radius: 20,
                          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                        ),
                        PieChartSectionData(
                          color: Color(0xffff7b633),
                          value: porcentajePagado,
                          title: "$porcentajePagado% (${moneyType.format(pagado)})",
                          radius: 20,
                          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                        ),
                        PieChartSectionData(
                          color: Color(0xff1f3c88),
                          value: porcentajeVencido,
                          title: "$porcentajeVencido% (${moneyType.format(vencido)})",
                          radius: 20,
                          
                          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                        ),

                      ]
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                    children: <Widget>[
                      Indicator(color: Color(0xff070d59), text: "1. Vencido", isSquare: true,),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(color: Color(0xfff5893d4), text: "2. Vigente", isSquare: true,),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(color: Color(0xffff7b633), text: "3. Pagado", isSquare: true,),
                      SizedBox(
                        height: 4,
                      ),
                      
                    ],
                  ),
                )
              ),
            ),
            
          ],
        ),
      ),
    );
  }

}