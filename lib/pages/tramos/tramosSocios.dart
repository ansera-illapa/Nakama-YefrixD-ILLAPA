import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';

import 'package:illapa/pages/tramos/tramosMostrar.dart';

import 'package:illapa/widgets.dart';



import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TramosSociosPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final String userEmail;

  TramosSociosPage({Key key, this.value, 
                              this.nombre,
                              this.imagen,
                              this.userEmail}) : super(key: key);
  @override
  _TramosSociosPageState createState() => _TramosSociosPageState();
}

class _TramosSociosPageState extends State<TramosSociosPage> {
  bool _buscar = false;
  bool ordenAZ = false;
  String textoBusqueda = '' ;
  
Widget _buildListSocios(String imagen, 
                          String nombre, 
                          int tipo, 
                          String identif, 
                          String correo, 
                          String usuario, 
                          int idSocio ){
    return 
    GestureDetector(
      onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => TramosMostrarPage(
                    value: idSocio,
                    nombre: nombre,
                    correo: correo,
                    imagen: imagen


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
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                ),
                                
                                Text(
                                  '$usuario',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  'Socio',
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
                                                      builder: (BuildContext context ) => TramosMostrarPage(
                                                        value: idSocio,
                                                        nombre: nombre,
                                                        correo: correo,
                                                        imagen: imagen
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
  String emailEmpresa = '';
  String tipoidentificador = "";
  int identificador = 0;
  String email = '';

  int cantSocios = 0;

  bool codes;
  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlTramo/sociosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag-tramos-tramosSocios${widget.value}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();
    }
  }

  int orderAZ(var a,var b){
    return a.compareTo(b);
  }

  int orderZA(var a,var b){
    return b.compareTo(a);
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
      nombreEmpresa = widget.nombre;
      imagenEmpresa = widget.imagen;
      emailEmpresa = widget.userEmail;
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
      
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag-tramos-tramosSocios${widget.value}.json');

        // GET SOCIOS
        try{
          print(await fileData.readAsString());
          final map = json.decode(await fileData.readAsString());
          final code = map["code"];
          final empresaSeleccionada = map["empresa"];
          final listSocios = map["result"];
          final load = map["load"];
          // print(empresaSeleccionada['nombre']);
          print(code);
          setState(() {
            _isLoading = load;
            this.nombreEmpresa = empresaSeleccionada['personaNombre'];
            this.imagenEmpresa = empresaSeleccionada['personaImagen'];
            this.emailEmpresa = empresaSeleccionada['userEmail'];
            if(empresaSeleccionada['personaTipoIdentificacion'] == 1){
              this.tipoidentificador = "DNI";
            }else{
              this.tipoidentificador = "RUC";
            }

            this.identificador = empresaSeleccionada['personaNumeroIdentificacion'];
            this.email = empresaSeleccionada['userEmail'];
            
            this.data = listSocios;
            this.codes = code;
            if(codes){
              cantSocios = this.data.length;
            }else{
              cantSocios = 0;
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
        title: new Text('Tramos'),
        backgroundColor: Color(0xFF070D59),
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
              // padding: EdgeInsets.all(5.0),
              color: Color(0xff1f3c88),
              // height: 90.0,
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
                                emailEmpresa,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                "Empresa",
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(Icons.ac_unit, color: Colors.white,),
                        //       onPressed: () => Navigator.push(
                        //                           context, 
                        //                           MaterialPageRoute(
                        //                             builder: (BuildContext context ) => TramosMostrarPage()
                        //                           )
                        //                         ),
                        //     )
                      ],
                    ),
                  ),
                ],
              ),
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
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[

                          for(var cont =0; cont<cantSocios; cont++ )
                          if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                            _buildListSocios(data[cont]['personaImagen'], 
                                             data[cont]['personaNombre'], 
                                             data[cont]['personaTipoIdentificacion'], 
                                             "${data[cont]['personaNumeroIdentificacion']}", 
                                             data[cont]['userEmail'], 
                                             data[cont]['userEmail'], 
                                             data[cont]['socioId']),
                          
                          
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
              ordenAZ
              ?IconButton(
                icon: Icon(
                  FontAwesomeIcons.sortAlphaUp, 
                  color: Colors.white,
                ), 
                onPressed: () {
                  setState(() {
                    ordenAZ = false;
                  });
                  data.sort((a, b) {
                    return orderZA(a['personaNombre'],b['personaNombre']);
                  });
                },
              )
              :IconButton(
                icon: Icon(
                  FontAwesomeIcons.sortAlphaDown, 
                  color: Colors.white,
                ), 
                onPressed: () {
                  setState(() {
                    ordenAZ = true;
                  });
                  data.sort((a, b) {
                    return orderAZ(a['personaNombre'],b['personaNombre']);
                  });
                },
              )
            ],
          ),
        ),
    );
    
  }
}