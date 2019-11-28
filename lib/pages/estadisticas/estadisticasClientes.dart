import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/estadisticas/estadisticaEsp.dart';
import 'package:illapa/pages/estadisticas/estadisticasFMSocio.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EstadisticasClientesPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String userEmail;


  EstadisticasClientesPage({Key key, 
                            this.value,
                            this.nombre,
                            this.imagen,
                            this.tipoDocumentoIdentidad,
                            this.numeroDocumentoIdentidad,
                            this.userEmail}): super(key: key);

  @override
  _EstadisticasClientesPageState createState() => _EstadisticasClientesPageState();
}

class _EstadisticasClientesPageState extends State<EstadisticasClientesPage> {
  bool _buscar = false;
  String textoBusqueda = '' ;
  bool ordenAZ = true;
  bool ordenZA = false;

  Widget _buidEstListEmpresas(String imagen, 
                              String nombre, 
                              String tipoDocumentoIdentidad, 
                              String numeroDocumentoIdentidad, 
                              String correo, 
                              String usuario, 
                              int idCliente){
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
                      identificacion: "$tipoDocumentoIdentidad"+" "+"$numeroDocumentoIdentidad",
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
                                                        builder: (BuildContext context ) => EstadisticaEspPage(
                                                          value: idCliente,
                                                          imagenCliente: imagen,
                                                          nombreCliente: nombre,
                                                          identificacion: "$tipoDocumentoIdentidad"+"$numeroDocumentoIdentidad",
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
  String nombreSocio = '';
  String imagenSocio = '';

  String tipoidentificador = "";
  String identificador = '';
  String email = '';

  int cantClientes = 0;
  bool codes;

  _getClientes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlEstadistica/clientesTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagEstadisticasEstadisticasClientes${widget.value}.json');
      await fileData.writeAsString("${response.body}");
      _getVariables();
    }
  }
  int orderAZ(var a,var b){
    return a.compareTo(b);
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

    if(widget.nombre != null){
      setState(() {
        nombreSocio = widget.nombre;  
        imagenSocio = widget.imagen;
        tipoidentificador = widget.tipoDocumentoIdentidad;
        identificador = widget.numeroDocumentoIdentidad;
        email = widget.userEmail;
      });
      
    }
    // TODO: implement initState
    super.initState();
    _getClientes();
    _getVariables();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;

  _getVariables() async {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagEstadisticasEstadisticasClientes${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final socioSeleccionado = map["socio"];
        final listClientes = map["result"];
        final load = map["load"];
        // print(socioSeleccionado['nombre']);
        print(code);
        setState(() {
          _isLoading = load;
          this.nombreSocio = socioSeleccionado['personaNombre'];
          this.imagenSocio = socioSeleccionado['personaImagen'];

          this.tipoidentificador = socioSeleccionado['personaTipoIdentificacion'];

          this.identificador = "${socioSeleccionado['personaNumeroIdentificacion']}";
          this.email = socioSeleccionado['userEmail'];

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
                      backgroundImage: new NetworkImage(imagenSocio),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nombreSocio,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              ),
                              Text(
                                '$tipoidentificador $identificador',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                email,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Socio',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                              onPressed: () => Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => EstadisticaFMSocioPage(
                                                      value: widget.value,
                                                      imagenSocio: imagenSocio,
                                                      nombreSocio: nombreSocio,
                                                      tipoIdentificacion: tipoidentificador,
                                                      identificacion: identificador,
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
            if(_buscar)
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5.0),
                  child: TextField(
                    
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Buscar'
                    ),
                    onChanged: (text){
                      setState(() {
                          textoBusqueda = text;
                          print(textoBusqueda);
                      });
                    },
                  ),
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
                      color: Color(0xff070D59),
                      // color: Colors.black,
                      child: Column(
                        children: <Widget>[

                          for(var cont =0; cont<cantClientes; cont++ )
                          if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                          _buidEstListEmpresas( data[cont]['personaImagen'], 
                                                data[cont]['personaNombre'], 
                                                data[cont]['personaTipoIdentificacion'], 
                                                "${data[cont]['personaNumeroIdentificacion']}", 
                                                data[cont]['userEmail'], 'Cliente', 
                                                data[cont]['clienteId'] ),
                          
                          
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
      bottomNavigationBar: BottomAppBar(
          color: Color(0xff1f3c88),
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
               _buscar
                ?IconButton(
                  icon: Icon(
                    FontAwesomeIcons.timesCircle, 
                    
                    color: Colors.white,
                    ), 
                  onPressed: () {
                    setState(() {
                      _buscar = false;
                    });
                  },)
                :IconButton(
                  icon: Icon(
                    Icons.search, 
                    color: Colors.white,
                    ), 
                  onPressed: () {
                    setState(() {
                      _buscar = true;
                    });
                  },),
              if(ordenAZ)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortAlphaUp, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      ordenAZ = false;
                      ordenZA = true;
                    });
                    data.sort((a, b) {
                      return orderAZ(b['personaNombre'],a['personaNombre']);
                    });
                  },
                  tooltip: "Ordenar de la A a la Z",
                ),
              if(ordenZA)
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.sortAlphaDown, 
                  color: Colors.white,
                ), 
                onPressed: () {
                  setState(() {
                    ordenZA = false;
                    ordenAZ = true;
                  });
                  data.sort((a, b) {
                    return orderAZ(a['personaNombre'],b['personaNombre']);
                  });
                },
                tooltip: "Ordenar de la Z a la A",
              ),
            ],
          ),
        ),
    );
  }
}

