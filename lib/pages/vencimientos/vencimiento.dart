

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/cal/scrolling_years_calendar.dart';
import 'package:illapa/extras/cal/year_view.dart';
import 'package:illapa/pages/vencimientos/vencMes.dart';
import 'package:illapa/widgets.dart';
import 'dart:async';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VencimientoPage extends StatefulWidget {
  final int id;
  final String url;
 
  
  VencimientoPage({
                  Key key, 
                  this.id, 
                  this.url, 
                  }) : super(key: key);

  @override
  _VencimientoPageState createState() => _VencimientoPageState();
}

class _VencimientoPageState extends State<VencimientoPage> {

  
  int cantFechas = 0;
  var listFechas;
  List<DateTime> fechas = [null];

  _getFechas() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    
    final url =
        "$urlVencimiento/${widget.url}/fechas/${widget.id}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {

      final map = json.decode(response.body);
      final code = map["code"];
      final listFechas = map["result"];
      final load = map["load"];

      setState(() {

        if(code == true){
          this.listFechas = listFechas;
          this.cantFechas = this.listFechas.length;
          
          for(var cont =0; cont < this.cantFechas; cont++ ){
            this.fechas[cont] = DateTime.parse(this.listFechas[cont]['documentosVencimiento']);
            if(cont == cantFechas-1 ){
              
            }else{
              fechas.add(null);
            }
            
            
          }
          print(fechas);

          
        }


      });

      // print("Fechaaa: "+listFechas[1]['documentosVencimiento']);
      // print("Fechaaa: "+"${documentosVencimientos[0]}");
        
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVariables();
    _getFechas();
  }
  
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;

  _getVariables() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
        
        setState(() {
          nombreUsuario = prefs.getString('nombre');
        }); 
      final directory = await getApplicationDocumentsDirectory();
      final tipoUsuarioFile = File('${directory.path}/tipo.txt');
      final idUsuarioFile = File('${directory.path}/id.txt');
      final imagenUsuarioFile = File('${directory.path}/imagen.txt');

      String tipoUsuarioInt = await tipoUsuarioFile.readAsString();                   
      String idUsuarioInt = await idUsuarioFile.readAsString(); 
      String imagenUsuarioString = await imagenUsuarioFile.readAsString(); 
      setState(() {
        tipoUsuario = int.parse(tipoUsuarioInt);
        idUsuario = int.parse(idUsuarioInt);
        imagenUsuario = imagenUsuarioString;  
      });
      
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");
      print("IMAGEN: $imagenUsuario");

  }

  @override
  Widget build(BuildContext context) {
     

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Vencimientos'),
        backgroundColor: Color(0xFF070D59),
      ),
      // backgroundColor: Color(0xFF5893D4),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF070D59),
          ),
          child: Sidebar(
            tipousuario: tipoUsuario,
            idusuario: idUsuario,
            imagenUsuario: imagenUsuario,
            nombre : nombreUsuario
          )
        ),
      body: 
        Stack(
          children: [

              Container(
                child: Center(
                  child: YearView(
                    context: context,
                    year: 2019,
                    documentosVencimiento: fechas,
                    monthNames: const <String>[
                      'Enero',
                      'Febrero',
                      'Marzo',
                      'Abril',
                      'Mayo',
                      'Junio',
                      'Julio',
                      'Agosto',
                      'Septiembre',
                      'Octubre',
                      'Noviembre',
                      'Diciembre',
                    ],

                    onMonthTap: (int year, int month) => 
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context ) => VencMesPage(ano: year, mes: month, id: widget.id , url: '${widget.url}', )
                        )
                      ),

                  )
                ),
              ),
          ],
        )
    );
  }
}