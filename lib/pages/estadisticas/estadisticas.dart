import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/estadisticas/estadisticasFMAdministrador.dart';
import 'package:illapa/pages/estadisticas/estadisticasSocios.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EstadisticaPage extends StatefulWidget {
  @override
  _EstadisticaPageState createState() => _EstadisticaPageState();
}

class _EstadisticaPageState extends State<EstadisticaPage> {


  var moneyType = new NumberFormat("#,##0.00", "en_US");
  Widget _buildListGestionEmpresas(String imagen, 
                                    String nombreEmpresa, 
                                    int numeroDocumentos,
                                    String sumaImportesDocumentos, 
                                    int numeroDocumentosVencidos, 
                                    String sumaImportesDocumentosVencidos, 
                                    int idEmpresa,
                                    String tipoDocumentoIdentidad,
                                    String numeroDocumentoIdentidad,
                                    String userEmail,){
    return 
    GestureDetector(
      onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => EstadisticasSociosPage(
                    value: idEmpresa,
                    nombre: nombreEmpresa,
                    imagen: imagen,
                    tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                    numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                    userEmail: userEmail,
                  )
                )
              );},
      child: Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Container(
                color: Color(0xff5893d4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: new CircleAvatar(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey,
                        backgroundImage: new NetworkImage(imagen),
                      ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  nombreEmpresa,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0),
                                ),
                                Text(
                                  '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))} ',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos registros por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))} ',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  'Empresa',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                onPressed: () => Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => EstadisticasSociosPage(
                                                        value: idEmpresa,
                                                        nombre: nombreEmpresa,
                                                        imagen: imagen,
                                                        tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                                                        numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                                                        userEmail: userEmail,
                                                      )
                                                    )
                                                  ),
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      )
    );
  }

  var data;
  int cantEmpresas = 0;
  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    final url =
        "$urlEstadistica/empresasTodas?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final users = map["result"];
      final load = map["load"];
      final code = map["code"];
      final numeroDocumentos = map["numeroDocumentos"];
      final sumaImporteDocumentos = map["sumaImportesDocumentos"];
      final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
      final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];

      setState(() {
        this.numeroDocumentos = numeroDocumentos;
        this.sumaImporteDocumentos = sumaImporteDocumentos;
        this.numeroDocumentosVencidos = numeroDocumentosVencidos;
        this.sumaImportesDocumentosVencidos = sumaImportesDocumentosVencidos;
        _isLoading = load;
        this.data = users;
        
        if(code){
          cantEmpresas = this.data.length;
        }
        
      });
    }
  }

  bool _isLoading = false;
  Widget _loading(){
      barrierDismissible: true;

      return Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                ),
              );
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _getVariables();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario = '';
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
                      backgroundImage: new NetworkImage(imagenAdmin),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Illapa',
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImporteDocumentos))}',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Administrador',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                              onPressed: (){
                                Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (BuildContext context ) => EstadisticasFMAdministradorPage(
                                              value: idUsuario,
                                              imagenAdm: imagenAdmin,
                                              nombreAdm: 'Illapa',
                                              tipoIdentificacion: '-',
                                              identificacion: '-',
                                            )
                                          )
                                        );
                              }
                            )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if(!_isLoading)
              _loading(),
            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    width: 5.0,
                    // height: MediaQuery.of(context).size.height,
                    color: Color(0xfff7b633),
                    
                  
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          for(var cont =0; cont<cantEmpresas; cont++ )
                          _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                    data[cont]['empresaNombre'], 
                                                    data[cont]['numeroDocumentos'], 
                                                    data[cont]['sumaImportesDocumentos'], 
                                                    data[cont]['numeroDocumentosVencidos'], 
                                                    data[cont]['sumaImportesDocumentosVencidos'], 
                                                    data[cont]['empresaId'],
                                                    data[cont]['tipoDocumentoIdentidad'],
                                                    "${data[cont]['numeroDocumentoIdentidad']}",
                                                    data[cont]['userEmail'],
                                                    ),
                          
                          
                        ],
                      ),
                      
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: (){},
              tooltip: 'FiltroEstadisticas',
              child: Icon(FontAwesomeIcons.ellipsisH),
            ),
    );
  }
}

