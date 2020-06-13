import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/usuarios/usuarioAgregarSector.dart';
import 'package:illapa/pages/usuarios/usuarioNuevo.dart';
import 'package:illapa/pages/usuarios/usuarioSectores.dart';
import 'package:illapa/pages/usuarios/usuariosUsuarios.dart';
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
  final String tipoIdentificacion;
  final String numeroIdentificacion;
  final String correo;
  final String cargo;
  final String imagen;
  final bool   cargoUsuario;
  
  // DATOS DEL SOCIO
  final String nombreSocio;
  final String imagenSocio;
  final String tipoDocumentoIdentidadSocio;
  final String numeroDocumentoIdentidadSocio;
  final String userEmailSocio;
  
  UsuariosEspecificoPage({Key key, 
                                this.value, 
                                this.socioid,
                                this.url,
                                this.nombre, 
                                this.tipoIdentificacion,
                                this.numeroIdentificacion,
                                this.correo, 
                                this.cargo,
                                this.imagen,
                                this.cargoUsuario,

                                this.nombreSocio,
                                this.imagenSocio,
                                this.tipoDocumentoIdentidadSocio,
                                this.numeroDocumentoIdentidadSocio,
                                this.userEmailSocio,
                          }) : super(key: key);

  @override
  _UsuariosEspecificoPageState createState() => _UsuariosEspecificoPageState();
}

class _UsuariosEspecificoPageState extends State<UsuariosEspecificoPage> {

  bool usuarioSeleccionado = false;  
Widget _buildListSectores( String titulo, int idSector){
  
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
                                icon: Icon(FontAwesomeIcons.solidEdit, color: Colors.white,),
                                onPressed: (){
                                  _selectSector(idSector);
                                },
                              ),
                          if(widget.cargoUsuario)
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.trashAlt, color: Colors.redAccent,),
                                onPressed: (){
                                  modalRevocarSector(context, idSector);
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

  Widget _anadirSector( String titulo){
    return 
      GestureDetector(
        onTap: (){
            _selectNuevoSector();
        },
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
                                  icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                  onPressed: (){
                                    _selectNuevoSector();
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

        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/usuarios-usuariosEspecifico${widget.value}.json');
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
    setState(() {
     usuarioSeleccionado = widget.cargoUsuario; 
    });

    super.initState();
    _getSector();
    _getVariables();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/usuarios-usuariosEspecifico${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final sector = map["sectoresSeleccionados"];
        final sectoresSocio = map["sectores"];
        final load = map["load"];
        final siSectores = map['siSectores'];
        setState(() {
          
          _isLoading = load;
          if(code == true){

            this.dataSectores = sector;
            this.cantSectores = this.dataSectores.length;

            this.dataSectoresSocio = sectoresSocio;
            this.cantSectoresSocio = this.dataSectoresSocio.length;

          }else if(siSectores == true){
            this.dataSectoresSocio = sectoresSocio;
            this.cantSectoresSocio = this.dataSectoresSocio.length;
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
                                widget.tipoIdentificacion+" "+widget.numeroIdentificacion,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.correo,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.cargo,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
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
                          _buildListSectores(dataSectores[cont]['sectoresDescripcion'], dataSectores[cont]['sectorId']),
                          if(usuarioSeleccionado == true || cantSectores <= 0)
                            if(_isLoading)
                              _anadirSector('Agregar nuevo sector')
                          
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
      floatingActionButtonLocation: 
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff1f3c88),
            child: 
                  const Icon(
                        FontAwesomeIcons.userEdit,
                        ), 
                  onPressed: () {
                    modalEditarUsuario(context);
                  },
                  tooltip: 'Editar usuario',
          ),
      bottomNavigationBar: BottomAppBar(
          color: Color(0xff1f3c88),
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              IconButton(icon: Icon(FontAwesomeIcons.bezierCurve, color: Colors.white,), onPressed: () {
                addSector(context);
              },
              tooltip: 'Agregar Sector',
              ),
              IconButton(icon: Icon(FontAwesomeIcons.userMinus, color: Colors.white,), onPressed: () {
                modalDegradarUsuario(context);
              }, tooltip: "Degradar Usuario",
              ),
            ],
          ),
        ),
    );
  }

  Future<bool> modalEditarUsuario(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 280.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left:10.0, right: 10.0, bottom: 10.0),
                          child: Text('¿Estás seguro de cambiar el tipo de usuario?', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:10.0, right: 10.0, bottom: 10.0),
                          child: Text('Recuerda que todos los sectores asignados seran revocados de este usuario', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Editar Usuario', 
                                  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed:  
                                     (){
                                          Navigator.of(context).pop();
                                          _cargando("Editando usuario");
                                          _editarUsuario();
                                        }
                                    
                                ),
                              ),
                              
                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }

  Future<bool> modalRevocarSector(context, int idSector) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 180.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de revocar este sector?', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Revocar', 
                                  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed:  
                                     (){
                                          Navigator.of(context).pop();
                                          _cargando("Revocando sector");
                                          _revocarSector(idSector);
                                        }
                                    
                                ),
                              ),
                              
                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }

  Future<bool> modalDegradarUsuario(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 180.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de degradar este usuario?', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Degradar', 
                                  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed:  
                                     (){
                                          Navigator.of(context).pop();
                                          _cargando("Degradando Usuario");
                                          _degradarUsuario();
                                        }
                                    
                                ),
                              ),
                              
                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }

  _degradarUsuario() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlUsuario/degradar/${widget.url}/${widget.socioid}/${widget.value}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context ) => UsuariosUsuariosPage(
              value : widget.socioid,
              nombre : "${widget.nombreSocio}",
              imagen : "${widget.imagenSocio}",
              tipoDocumentoIdentidad : "${widget.tipoDocumentoIdentidadSocio}",
              numeroDocumentoIdentidad : "${widget.numeroDocumentoIdentidadSocio}",
              userEmail : "${widget.userEmailSocio}",
            )
          )
        );
    }
  }

  Future<void> _cargando(String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
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
          "$urlUsuario/${widget.url}/editarSector";
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

  anadirSector(int idSectorSeleccionado) async{ //miomio
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      bool respuesta;
      print("CAMPOS ENVIADO");
      print("${widget.value}");
      print("$idSectorSeleccionado");
      print("${widget.socioid}");

      var url =
          "$urlUsuario/${widget.url}/anadirSector";
      print(url);
        final response = await http.post(url, body: {
                        "idUsuario": "${widget.value}",
                        "idsectorNuevo": "$idSectorSeleccionado",
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

  _revocarSector(int idSectorSeleccionado) async{ 
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      bool respuesta;
      print("CAMPOS ENVIADO");
      print("${widget.value}");
      print("$idSectorSeleccionado");
      print("${widget.socioid}");

      var url =
          "$urlUsuario/${widget.url}/revocarSector";
      print(url);
        final response = await http.post(url, body: {
                        "idUsuario": "${widget.value}",
                        "idsectorAntiguo": "$idSectorSeleccionado",
                        "idsocio": "${widget.socioid}",
                        "api_token": apiToken,
                        
                      });
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        final map = json.decode(response.body);
        final load = map["load"];

        if(load == true){
          _getSector();
        }
      }else{
        Navigator.of(context).pop();
      }
  }

  _editarUsuario() async{ 
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      bool respuesta;
      print("CAMPOS ENVIADO");
      print("${widget.value}");
      print("${widget.socioid}");

      var url =
          "$urlUsuario/${widget.url}/editarUsuario";
      print(url);
        final response = await http.post(url, body: {
                        "idUsuario": "${widget.value}",
                        "idsocio": "${widget.socioid}",
                        "api_token": apiToken,
                      });
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        final map = json.decode(response.body);
        final load = map["load"];

        if(load == true){
          // _getSector();
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context ) => UsuariosUsuariosPage(
                value: widget.socioid,
                nombre: widget.nombreSocio,
                imagen: widget.imagenSocio,
                tipoDocumentoIdentidad: widget.tipoDocumentoIdentidadSocio,
                numeroDocumentoIdentidad: widget.numeroDocumentoIdentidadSocio,
                userEmail: widget.userEmailSocio,
              )
            )
          );


        }
      }else{
        Navigator.of(context).pop();
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

  Widget _sectorNuevo(String sector, int cont, bool select, int disponible, int idSector){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: disponible == 1 ? null : (){
                setState(() {
                  // codSectorSeleccionado = idSector;
                  cantSectores = 0;
                  _isLoading = false;
                });
                anadirSector(idSector);
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


  void _selectNuevoSector() {
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
                              _sectorNuevo(dataSectoresSocio[cont]['sectoresDescripcion'], 
                                        cont, false , 
                                        dataSectoresSocio[cont]['estadoSectoristaGestor'], 
                                        dataSectoresSocio[cont]['id'],)
                            
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }
  
TextEditingController descripcionSector = TextEditingController();
Future<bool> addSector(context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                color: Color(0xFF070D59),
                height: 250.0,
                width: 200.0,
                padding: EdgeInsets.all(10.0),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Agregar un sector',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 15.0,
                                color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            TextField(
                              maxLines: 3,
                              controller: descripcionSector,
                              keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "",
                                  labelText: "Descripción",
                                ),
                              ),
                            
                            
                          ],
                        )
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Color(0xFF1f3c88),
                            child: Center(
                              child: Text(
                                'Agregar',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.white,)
                              ),
                            ),
                            onPressed: () {
                              agregarSector();
                              Navigator.of(context).pop();
                              _cargando("Creando sector");
                            },
                            
                          ),
                        ),
                        
                      ],
                    )
                  ],
                )));
      });
  }
  agregarSector() async{
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      bool respuesta;
      var url =
          "$urlUsuario/agregarSector";

        final response = await http.post(url, body: {

                        "idSocio": "${widget.socioid}",
                        "descripcion": descripcionSector.text ,
                        "api_token": apiToken,
                        
                      });
        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          print(response.body);
          setState(() {
           descripcionSector.text = ''; 
          });
          _getSector();
        }

  }
}