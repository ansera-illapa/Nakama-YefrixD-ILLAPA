import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/estadisticas/estadisticaEsp.dart';
import 'package:illapa/pages/estadisticas/estadisticaFree/estFreeFiltroMayor.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EstFreeClientesPage extends StatefulWidget {
  final int value;
  EstFreeClientesPage({Key key, this.value}) : super(key: key);

  @override
  _EstFreeClientesPageState createState() => _EstFreeClientesPageState();
}

class _EstFreeClientesPageState extends State<EstFreeClientesPage> {


  
  Widget _buildEstListClientes(String imagen, String nombre, String tipo, var identif, String correo, String usuario, int idCliente){
    String tipoIden = tipo;
    
    
    if(correo == null){
      correo = "-";
    }
    return 
    
      GestureDetector(
        onTap: (){Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => EstadisticaEspPage(
                      value: idCliente,
                      imagenCliente: imagen,
                      nombreCliente: nombre,
                      identificacion: '$tipoIden $identif',


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
                          backgroundImage: new NetworkImage(urlImagenes+imagen),
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
                                    '$tipoIden $identif',
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
                                                        builder: (BuildContext context ) => EstadisticaEspPage(
                                                          value: idCliente
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
  String nombreGestorFree = '';
  String tipoidentificador = "";
  var identificador;
  String email = '';
  int sectorId;

  int cantClientes = 0;
  bool codes;

  _getClientes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlEstFree/clientesTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag-estadisticas-estadisticasFree-estFreeClientes${widget.value}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();
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
    _getClientes();
    _getVariables();
  }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario = '';
  String nombreUsuario;

  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pag-estadisticas-estadisticasFree-estFreeClientes${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final socioSeleccionado = map["sectorista"];
        final listClientes = map["result"];
        final load = map["load"];
        // print(socioSeleccionado['nombre']);
        print(code);
        setState(() {
          _isLoading = load;
          this.nombreGestorFree = socioSeleccionado['personaNombre'];

          this.tipoidentificador = socioSeleccionado['personaTipoIdentificacion'];

          this.identificador = socioSeleccionado['personaNumeroIdentificacion'];
          this.email = socioSeleccionado['userEmail'];
          this.sectorId = socioSeleccionado['sectorId'];


          this.data = listClientes;
          this.codes = code;
          if(codes){
            cantClientes = this.data.length;
          }else{
            cantClientes = 0;
          }
          
        });
          
      }catch(error){
        print(error);
      
      }

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
                      backgroundImage: new NetworkImage(imagenUsuario),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nombreGestorFree,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              ),
                              identificador == null
                                ?Text(
                                    '',
                                    style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  )
                                :Text(
                                    '$tipoidentificador $identificador',
                                    style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                              Text(
                                email,
                                style: new TextStyle(color:AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              // Text(
                              //   'FREE',
                              //   style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              // ),
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                              onPressed: () => Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => EstadisticasEspFiltroMayorPage(
                                                      value: sectorId,
                                                      nombreGestor: nombreGestorFree,
                                                      imagenGestor: imagenUsuario,
                                                      tipoIdentificacion: tipoidentificador,
                                                      identificacion: "$identificador",
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
            Padding(
              padding: EdgeInsets.only(top: 2.0),
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
                      color: Color(0xff070D59),
                      // color: Colors.black,
                      child: Column(
                        children: <Widget>[

                          for(var cont =0; cont<cantClientes; cont++ )
                            _buildEstListClientes(data[cont]['personaImagen'], data[cont]['personaNombre'], data[cont]['personaTipoIdentificacion'], data[cont]['personaNumeroIdentificacion'], data[cont]['userEmail'], 'Cliente', data[cont]['clienteId'] ),
                          
                          
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

