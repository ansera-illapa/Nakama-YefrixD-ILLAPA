import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/estadisticas/estadisticasClientes.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EstadisticasSociosPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String userEmail;


  EstadisticasSociosPage({Key key, this.value,
                                   this.nombre,
                                   this.imagen,
                                   this.tipoDocumentoIdentidad,
                                   this.numeroDocumentoIdentidad,
                                   this.userEmail
                                   }) : super(key: key);

  @override
  _EstadisticasSociosPageState createState() => _EstadisticasSociosPageState();
}

class _EstadisticasSociosPageState extends State<EstadisticasSociosPage> {


  
  Widget buidEstListSocios(String imagen, 
                            String nombre, 
                            String tipoDocumentoIdentidad, 
                            String numeroDocumentoIdentidad, 
                            String correo, 
                            String usuario, 
                            int idSocio){
    
    return 
      GestureDetector(
        onTap: (){Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => EstadisticasClientesPage(
                      value: idSocio,
                      nombre: nombre,
                      imagen: imagen,
                      tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                      numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                      userEmail: correo,
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
                                    style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                                  ),
                                  Text(
                                    '$tipoDocumentoIdentidad $numeroDocumentoIdentidad',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                  Text(
                                    '$correo',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                  Text(
                                    '$usuario',
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
                                                        builder: (BuildContext context ) => EstadisticasClientesPage(
                                                          value: idSocio,
                                                          nombre: nombre,
                                                          imagen: imagen,
                                                          tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                                                          numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                                                          userEmail: correo,
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
  String nombreEmpresa = 'Loading ...';
  String imagenEmpresa = "";
  String tipoidentificador = "Loading ...";
  String identificador = '';
  String email = 'Loading ...';

  int cantSocios = 0;

  bool codes;
  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlEstadistica/sociosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final empresaSeleccionada = map["empresa"];
      final listSocios = map["result"];
      final load = map["load"];
      // print(empresaSeleccionada['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreEmpresa = empresaSeleccionada['empresaNombre'];
        this.imagenEmpresa = empresaSeleccionada['personaImagen'];
        this.tipoidentificador = empresaSeleccionada['personaTipoIdentificacion'];
        
        this.identificador ="${empresaSeleccionada['personaNumeroIdentificacion']}";
        this.email = empresaSeleccionada['userEmail'];
        
        this.data = listSocios;
        this.codes = code;
        if(codes){
          cantSocios = this.data.length;
        }else{
          cantSocios = 0;
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
    if(widget.nombre != null ){
      setState(() {
        nombreEmpresa = widget.nombre;
        imagenEmpresa = widget.imagen;
        tipoidentificador = widget.tipoDocumentoIdentidad;
        identificador = widget.numeroDocumentoIdentidad;
        email = widget.userEmail;  
      });
      
    }
    // TODO: implement initState
    super.initState();
    _getSocios();
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
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              ),

                              Text(
                                '$tipoidentificador $identificador',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                email,
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Empresa',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(FontAwesomeIcons.chartLine, color: Colors.white,),
                        //       onPressed: () => Navigator.push(
                        //                           context, 
                        //                           MaterialPageRoute(
                        //                             builder: (BuildContext context ) => EstadisticasClientesPage()
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
                          for(var cont =0; cont<cantSocios; cont++ )
                          buidEstListSocios(data[cont]['personaImagen'], 
                                            data[cont]['personaNombre'], 
                                            data[cont]['personaTipoIdentificacion'], 
                                            "${data[cont]['personaNumeroIdentificacion']}", 
                                            data[cont]['userEmail'], 'Socios', 
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
    );
  }
}

