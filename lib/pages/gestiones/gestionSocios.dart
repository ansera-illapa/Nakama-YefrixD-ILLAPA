import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionFiltroMayor.dart';

import 'package:illapa/widgets.dart';




import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GestionSociosPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final int numeroDocumentos;
  final String sumaImportesDocumentos;
  final int numeroDocumentosVencidos;
  final String sumaImportesDocumentosVencidos;

  GestionSociosPage({Key key, this.value, 
                              this.nombre, 
                              this.imagen, 
                              this.numeroDocumentos, 
                              this.sumaImportesDocumentos,
                              this.numeroDocumentosVencidos,
                              this.sumaImportesDocumentosVencidos}) : super(key: key);
  
  @override
  _GestionSociosPageState createState() => _GestionSociosPageState();
}


class _GestionSociosPageState extends State<GestionSociosPage> {

  Widget _buildListGestionEmpresas(String imagen, 
                                  String nombre, 
                                  int numeroDocumentos, 
                                  String sumaImportesDocumentos, 
                                  int numeroDocumentosVencidos, 
                                  String sumaImportesDocumentosVencidos, 
                                  int idSocio){
    return 
    GestureDetector(
    onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => GestionClientesPage(
                    value: idSocio,
                    nombre: nombre,
                    imagen: imagen,
                    numeroDocumentos: numeroDocumentos,
                    sumaImportesDocumentos: sumaImportesDocumentos,
                    numeroDocumentosVencidos: numeroDocumentosVencidos,
                    sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,

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
                                  nombre,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white ,fontSize: 15.0 ),
                                ),
                                Text(
                                  '$numeroDocumentos registros por $sumaImportesDocumentos',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
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
                                                      builder: (BuildContext context ) => GestionClientesPage(
                                                        value: idSocio,
                                                        nombre: nombre,
                                                        imagen: imagen,
                                                        numeroDocumentos: numeroDocumentos,
                                                        sumaImportesDocumentos: sumaImportesDocumentos,
                                                        numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                        sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,
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
  String nombreEmpresa = '';
  String imagenEmpresa = '';
  int numeroDocumentos = 0;
  String sumaImportesDocumentos = '';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '';
  
  int cantSocios = 0;

  bool _isLoading = false;


  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/sociosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final empresaSeleccionada = map["empresa"];
      final empresaSeleccionadaVencidos= map["empresaVencida"];
      final listSocios = map["result"];
      final load = map["load"];
      
      print(code);
      setState(() {

        _isLoading = load;
        this.nombreEmpresa = empresaSeleccionada['nombre'];
        this.imagenEmpresa = empresaSeleccionada['personaImagen'];
        this.numeroDocumentos = empresaSeleccionada['numeroDocumentos'];
        this.sumaImportesDocumentos = empresaSeleccionada['sumaImportesDocumentos'];


        this.numeroDocumentosVencidos = empresaSeleccionadaVencidos['numeroDocumentosVencidos'];
        this.sumaImportesDocumentosVencidos = empresaSeleccionadaVencidos['sumaImportesDocumentosVencidos'];
        
        this.data = listSocios;
        
        if(code){
          cantSocios = this.data.length;
          
        }else{
          cantSocios = 0;
        }


      });
    }
  }

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
    if(widget.nombre != null){
      nombreEmpresa = widget.nombre;
      imagenEmpresa = widget.imagen;
      numeroDocumentos = widget.numeroDocumentos;
      sumaImportesDocumentos = widget.sumaImportesDocumentos;
      numeroDocumentosVencidos = widget.numeroDocumentosVencidos;
      sumaImportesDocumentosVencidos = widget.sumaImportesDocumentosVencidos;

    }
    
    // TODO: implement initState
    super.initState();
    _getVariables();
    _getSocios();
    
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
        title: new Text('Gestión'),
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
        ),
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
                      backgroundImage: new NetworkImage(imagenEmpresa),
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
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                '$numeroDocumentos registros por $sumaImportesDocumentos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                              onPressed: () => Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => GestionFMEmpPage(
                                                      value: widget.value,
                                                      nombre: nombreEmpresa,
                                                      imagen: imagenEmpresa,
                                                      numeroDocumentos: numeroDocumentos,
                                                      sumaImportesDocumentos: sumaImportesDocumentos,
                                                      numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                      sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,

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
                    color: Color(0xfff7b633),
                    
                  
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[

                          for(var cont =0; cont<cantSocios; cont++ )
                            _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                      data[cont]['personaNombre'], 
                                                      data[cont]['numeroDocumentos'], 
                                                      data[cont]['sumaImportesDocumentos'], 
                                                      data[cont]['numeroDocumentosVencidos'], 
                                                      data[cont]['sumaImportesDocumentosVencidos'], 
                                                      data[cont]['socioId'] ),
                          
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
        tooltip: '',
        
        child: Icon(FontAwesomeIcons.ellipsisH),
      ),

        // bottomNavigationBar: BottomAppBar(
        //   color: Color(0xff1f3c88),
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 2.0,
        //   child: new 
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       textDirection: TextDirection.rtl,
        //       children: [
        //         IconButton(icon: Icon(Icons.power_input, color: Colors.white,), onPressed: () {},),
        //       ],
        //     ),
        // ),
        
    );
    
  }
}

