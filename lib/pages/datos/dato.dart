import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/datos/datosSocios.dart';
import 'package:illapa/widgets.dart';
import 'package:intl/intl.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class DatoPage extends StatefulWidget {
  @override
  _DatoPageState createState() => _DatoPageState();
}

class _DatoPageState extends State<DatoPage> {

  var moneyType = new NumberFormat("#,##0.00", "en_US");
Widget _buildListEmpresas(String imagen, 
                          String nombreEmpresa, 
                          int numeroDocumentos, 
                          String sumaImportesDocumentos, 
                          int numeroDocumentosVencidos, 
                          String sumaImportesDocumentosVencidos, 
                          int idEmpresa,
                          String tipoDocumentoIdentidad,
                          String numeroDocumentoIdentidad,
                          String userEmail,
                          ){
  return 
    GestureDetector(
      onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatoSociosPage(
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
                                  '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))}',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos registros por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))} ',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  'Empresa ',
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
                                                      builder: (BuildContext context ) => DatoSociosPage(
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

  _getDato() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    final url =
        "$urlDato/empresasTodas?api_token="+apiToken;
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
    _getDato();
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
        title: new Text('Datos'),
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
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Administrador',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(Icons.ac_unit, color: Colors.white,),
                        //       onPressed: () => Navigator.push(
                        //                           context, 
                        //                           MaterialPageRoute(
                        //                             builder: (BuildContext context ) => DatoClientesPage()
                        //                           )
                        //                         ),
                        //     )
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
                            _buildListEmpresas( data[cont]['personaImagen'], 
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
        tooltip: 'Por nombre alfabetico',
        
        child: Icon(FontAwesomeIcons.ellipsisH),
      ),

      // floatingActionButtonLocation: 
      //     FloatingActionButtonLocation.centerDocked,
      //     floatingActionButton: FloatingActionButton(
      //       backgroundColor: Color(0xff1f3c88),
      //       child: 
      //             const Icon(
      //                   FontAwesomeIcons.plus,
      //                   ), 
      //             onPressed: () {},
      //     ),

      //   bottomNavigationBar: BottomAppBar(
      //     color: Color(0xff1f3c88),
      //     shape: CircularNotchedRectangle(),
      //     notchMargin: 4.0,
      //     child: new Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: () {},),
      //         IconButton(icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white,), onPressed: () {},),
      //       ],
      //     ),
      //   ),

    );
    
  }
}