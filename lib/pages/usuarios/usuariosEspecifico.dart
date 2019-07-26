import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/usuarios/usuarioAgregarSector.dart';
import 'package:illapa/pages/usuarios/usuarioNuevo.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuariosEspecificoPage extends StatefulWidget {
  final int value;
  final int socioid;
  final String url;

  final String nombre ;
  final String identificacion;
  final String correo;
  final String cargo;
  final String imagen;
  
  
  
  UsuariosEspecificoPage({Key key, 
                                this.value, 
                                this.socioid,
                                this.url,
                                this.nombre, 
                                this.identificacion, 
                                this.correo, 
                                this.cargo,
                                this.imagen
                          }) : super(key: key);

  @override
  _UsuariosEspecificoPageState createState() => _UsuariosEspecificoPageState();
}

class _UsuariosEspecificoPageState extends State<UsuariosEspecificoPage> {

  
Widget _buidEstListEmpresas( String titulo, int idSector){
  
    return 
    GestureDetector(
      // onTap: (){Navigator.push(
      //           context, 
      //           MaterialPageRoute(
      //             builder: (BuildContext context ) => DatoClientesPage()
      //           )
      //         );},
      
      child: Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Container(
                color: Color(0xff5893d4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  titulo,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                ),
                                
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.timesCircle, color: Colors.white,),
                                onPressed: (){
                                  _selectSector(idSector);
                                },
                                
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



  
  int cantSectores = 0;
  var dataSectores;
  
  int cantSectoresSocio = 0;
  var dataSectoresSocio;


  _getSector() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    
    final url =
        "$urlUsuario/${widget.url}/sector/${widget.value}/${widget.socioid}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      
      final map = json.decode(response.body);
      final code = map["code"];
      final sector = map["sectoresSeleccionados"];
      final sectoresSocio = map["sectores"];
      final load = map["load"];

      setState(() {
        
        _isLoading = load;
        if(code == true){

          this.dataSectores = sector;
          this.cantSectores = this.dataSectores.length;

          this.dataSectoresSocio = sectoresSocio;
          this.cantSectoresSocio = this.dataSectoresSocio.length;

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
    _getSector();
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

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Usuarios'),
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
              // padding: EdgeInsets.all(5.0),
              color: Color(0xff1f3c88),
              height: 90.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: new CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: new NetworkImage(widget.imagen),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.nombre,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                widget.identificacion,
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.correo,
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.cargo,
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
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
                          
                          for(var cont =0; cont < cantSectores; cont++ )
                          _buidEstListEmpresas(dataSectores[cont]['sectoresDescripcion'], dataSectores[cont]['sectorId']),
                          
                          
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
      floatingActionButton: 
      cantSectores == 0 && _isLoading == true
      ?FloatingActionButton(
        onPressed: (){},
        tooltip: 'Agregar sector',
        
        child: Icon(FontAwesomeIcons.plus),
      )
      :null
    );
    
  }

  Future<void> cargandoCambiarSector() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Creando documento'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                          ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // FlatButton(
            //   child: Text('Regret'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  eliminarSector(int idSectorSeleccionado) async{ //miomio
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      bool respuesta;
      print("CAMPOS ENVIADO");
      print("${widget.value}");
      print("$idSectorSeleccionado");
      print("$codSectorSeleccionado");
      print("${widget.socioid}");

      var url =
          "$urlUsuario/${widget.url}/eliminarSector";
      print(url);
        final response = await http.post(url, body: {
                        "idUsuario": "${widget.value}",
                        "idsectorAntiguo": "$idSectorSeleccionado",
                        "idsectorNuevo": "$codSectorSeleccionado",
                        "idsocio": "${widget.socioid}",
                        "api_token": apiToken,
                        
                      });
      print(response.body);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        final load = map["load"];

        if(load == true){
          _getSector();
          // Navigator.of(context).pop();
        }

      }
        

  }



  Widget _sector(String sector, int cont, bool select, int disponible, int idSector, int idSectorSeleccionado){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: disponible == 1 ? null : (){
                setState(() {
                  codSectorSeleccionado = idSector;
                  cantSectores = 0;
                  _isLoading = false;
                });
                eliminarSector(idSectorSeleccionado);
                Navigator.of(context).pop();
                
                // cargandoCambiarSector();
                print(codSectorSeleccionado);
              },
              textColor: Colors.white,
              color: Color(x),
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                sector,
              ),
            ),
          );
  }

  
  int sectorSeleccionado = 99;
  String sectorNombre = '';
  int codSectorSeleccionado;

  void _selectSector(int idSectorSeleccionado) {
    
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 300.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR UN NUEVO SECTOR', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                            for(var cont =0; cont<cantSectoresSocio; cont++ )
                              _sector(dataSectoresSocio[cont]['sectoresDescripcion'], 
                                        cont, false , 
                                        dataSectoresSocio[cont]['estadoSectoristaGestor'], 
                                        dataSectoresSocio[cont]['id'], 
                                        idSectorSeleccionado )
                            
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }
  
}