import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DatoSociosPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String userEmail;

  DatoSociosPage({Key key, 
                    this.value,
                    this.nombre,
                    this.imagen,
                    this.tipoDocumentoIdentidad,
                    this.numeroDocumentoIdentidad,
                    this.userEmail}): super(key: key);

  @override
  _DatoSociosPageState createState() => _DatoSociosPageState();
}

class _DatoSociosPageState extends State<DatoSociosPage> {

  
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
                  builder: (BuildContext context ) => DatoClientesPage(
                    value: idSocio,
                    nombre: nombre,
                    imagen: imagen,
                  )
                )
              );},
      
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.0),
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
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
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
                                                      builder: (BuildContext context ) => DatoClientesPage(
                                                        value: idSocio,
                                                        nombre: nombre,
                                                        imagen: imagen,
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
  String tipoidentificador = "";
  String identificador = '';
  String email = '';

  int cantSocios = 0;

  bool codes;
  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlDato/sociosTodos/${widget.value}?api_token="+apiToken;
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
        
        this.tipoidentificador = empresaSeleccionada['tipoDocumentoIdentidad'];

        this.identificador = "${empresaSeleccionada['personaNumeroIdentificacion']}";
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
    // TODO: implement initState
    if(widget.nombre != null){
      nombreEmpresa = widget.nombre;
      imagenEmpresa = widget.imagen;
      tipoidentificador = widget.tipoDocumentoIdentidad;
      identificador  = widget.numeroDocumentoIdentidad;
      email = widget.userEmail;

    }
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
        title: new Text('Datos'),
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
              height: 80.0,
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
                          for(var cont =0; cont<cantSocios; cont++ )
                            buidEstListSocios(data[cont]['personaImagen'], 
                                              data[cont]['personaNombre'], 
                                              data[cont]['tipoDocumentoIdentidad'], 
                                              "${data[cont]['personaNumeroIdentificacion']}", 
                                              data[cont]['userEmail'], 'Socio', 
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