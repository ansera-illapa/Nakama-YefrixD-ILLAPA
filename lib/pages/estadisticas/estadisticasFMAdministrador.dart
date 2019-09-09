import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/chart/samples/pie_chart_documentos.dart';
import 'package:illapa/extras/chart/samples/pie_chart_sample2.dart';
import 'package:illapa/pages/estadisticas/estadisticas.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EstadisticasFMAdministradorPage extends StatefulWidget {
  final int value;
  final String imagenAdm;
  final String nombreAdm;
  final String tipoIdentificacion;
  final String identificacion;

  EstadisticasFMAdministradorPage({Key key, 
                      this.value,
                      this.imagenAdm,
                      this.nombreAdm,
                      this.tipoIdentificacion,
                      this.identificacion}) : super(key: key);

  @override
  _EstadisticasFMAdministradorPageState createState() => _EstadisticasFMAdministradorPageState();
}

class _EstadisticasFMAdministradorPageState extends State<EstadisticasFMAdministradorPage> {
  
  Widget _buildListTramos(int cont, int desde, int hasta, int documentos, String importes ){

    if(documentos == null){
      setState(() {
       documentos = 0; 
      });
    }
    if(importes == "null"){
      setState(() {
       importes ='0.00'; 
      });
    }
    return 
    
      Container(
        color: Color(0xff5893d4),
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                    '$cont. De $desde a $hasta', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                  ),
                
            ),
            Expanded(
              child: Center(
                child:  
                  Text(
                    '$documentos', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                  ),
              ),
            ),
            Expanded(
              child: Center(
                child:  
                  Text(
                    '$importes', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                  ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildTotalTramos(int totalDocumentos, String totalImportes){
    return Container(
        color: Color(0xffF7B633),
        padding: EdgeInsets.only(top: 2.0, left: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                    'Pagado', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.black),
                  ),
                
            ),
            Expanded(
              child: Center(
                child:  
                  Text(
                    '$totalDocumentos', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.black),
                  ),
              ),
            ),
            Expanded(
              child: Center(
                child:  
                  Text(
                    '$totalImportes', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.black),
                  ),
              ),
            ),
          ],
        ),
      );
  }



  var data;
  String nombreCliente = '';
  String imagenAdministrador = '';
  String tipoidentificador = "";
  var identificador;
  String identificacion = '';
  String tipoIdentificacion = '';
  String email = '';

  String porcentajeVencido;
  String porcentajeVigente;
  String porcentajePagado ;
  

  double dporcentajeImporteVencido = 0;
  double dporcentajeImporteVigente = 0;
  double dporcentajeImportePagado = 0;
  double dImporteVencido = 0;
  double dImporteVigente = 0;
  double dImportePagado = 0;



  double cantPagados = 0;
  double cantVigente = 0;
  double cantVencido = 0;
  double cantTotal = 0;
  
  
  String importePagados ;

  double dporcentajeVencido = 0;
  double dporcentajeVigente = 0;
  double dporcentajePagado = 0;
  double dimportePagados = 0;

  double importeTotal = 0;
  int cantTramos = 0;

  bool codes;
  _getCliente() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlEstadistica/empresasTodas/filtroMayor?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final porcentajeDocumentos = map["porcentaje"];
      final porcentajeImporteDocumentos = map["porcentajeImportes"];

      final tramosSocio = map["tramos"];
      
      print(code);
      setState(() {

        

        this.porcentajeVencido = porcentajeDocumentos['vencido'];
        this.porcentajeVigente = porcentajeDocumentos['vigente'];
        this.porcentajePagado = porcentajeDocumentos['pagado'];

        this.cantPagados = double.parse(porcentajeDocumentos['cantPagados']);
        this.cantVigente = double.parse(porcentajeDocumentos['cantVigentes']);
        this.cantVencido = double.parse(porcentajeDocumentos['cantVencidos']);
        this.cantTotal = double.parse(porcentajeDocumentos['cantTotal']);

        this.importePagados = porcentajeDocumentos['importePagados'];

        this.dporcentajeVencido = double.parse(porcentajeVencido); 
        this.dporcentajeVigente = double.parse(porcentajeVigente); 
        this.dporcentajePagado = double.parse(porcentajePagado); 

        this.dimportePagados = double.parse(importePagados); 



        this.dporcentajeImporteVencido = double.parse(porcentajeImporteDocumentos['vencido']); 
        this.dporcentajeImporteVigente = double.parse(porcentajeImporteDocumentos['vigente']); 
        this.dporcentajeImportePagado = double.parse(porcentajeImporteDocumentos['pagado']);

        this.dImporteVencido = double.parse(porcentajeImporteDocumentos['importeVencido']);
        this.dImporteVigente = double.parse(porcentajeImporteDocumentos['importeVigente']);
        this.dImportePagado  = double.parse(porcentajeImporteDocumentos['importePagado']);

        this.importeTotal = double.parse(porcentajeImporteDocumentos['importeTotal']);

        this.data = tramosSocio;
        
        
        
        this.codes = code;
        if(codes){
          cantTramos = this.data.length;
        }else{
          cantTramos = 0;
        }
        
        
        
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    if(widget.nombreAdm != null){
      nombreCliente = widget.nombreAdm;
      tipoIdentificacion = widget.tipoIdentificacion;
      identificacion = widget.identificacion;
      imagenAdministrador = widget.imagenAdm;

    }

    super.initState();
    _getCliente();
    _getVariables();
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
      tipoUsuario = int.parse(tipoUsuarioInt);
      idUsuario = int.parse(idUsuarioInt);
      imagenUsuario = imagenUsuarioString;
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");
      print("IMAGEN: $imagenUsuario");

  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Estadísticas'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowCircleLeft,
                color: Colors.grey
                
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          
        ],
        backgroundColor: Color(0xFF070D59),
      ),
      backgroundColor: Color(0xFF070D59),
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
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
            children: <Widget>[
              Container(
                  color: Color(0xff1f3c88),
                  // height: 80.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: new CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          backgroundImage: new NetworkImage(imagenAdministrador),
                        ),
                        title: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    nombreCliente,
                                    style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                  ),
                                  Text(
                                    '$tipoIdentificacion $identificacion',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                  // Text(
                                  //   email,
                                  //   style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  // ),
                                  Text(
                                    'Administrador',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                ],
                              ),
                            ),
                            // new IconButton(
                            //       icon: Icon(FontAwesomeIcons.chartLine, color: Colors.white,),
                            //       onPressed: (){}
                            //     )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    PieChartDocumentos(
                      porcentajeVigente: dporcentajeVigente,
                      porcentajePagado: dporcentajePagado,
                      porcentajeVencido: dporcentajeVencido,
                      
                      vencido: cantVencido.round(),
                      vigente: cantVigente.round(),
                      pagado: cantPagados.round(),
                      total: cantTotal.round(),


                      tipoEstadistica: 'Documentos'
                    ),
                    PieChartSample2(
                      porcentajeVigente: dporcentajeImporteVigente,
                      porcentajePagado: dporcentajeImportePagado,
                      porcentajeVencido: dporcentajeImporteVencido,

                      vencido: dImporteVencido,
                      vigente: dImporteVigente,
                      pagado: dImportePagado,
                      total: importeTotal,
                      tipoEstadistica: 'importeTotal'
                      
                    ),
                    
                  ],
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                child: Column(
                  children: <Widget>[

                    for(var cont =0; cont<cantTramos; cont++ ) //miomio

                    _buildListTramos(cont+1,  data[cont]['desde'],
                                              data[cont]['hasta'], 
                                              data[cont]['documentos'], 
                                             "${data[cont]['importe']}"),
                    
                    _buildTotalTramos(cantPagados.round(), importePagados),
                  ],
                ),
              )
            ],
          ),
        )
      
    );
  }
}