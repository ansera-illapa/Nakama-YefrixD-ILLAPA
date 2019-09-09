import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/usuarios/usuarioAgregarSector.dart';
import 'package:illapa/pages/usuarios/usuarioEditarUsuario.dart';
import 'package:illapa/pages/usuarios/usuarioNuevo.dart';
import 'package:illapa/pages/usuarios/usuariosEspecifico.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuariosUsuariosPage extends StatefulWidget {
  final int    value;
  final String nombre;
  final String imagen;
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String userEmail;

  UsuariosUsuariosPage({Key key, this.value,
                                  this.nombre,
                                  this.imagen,
                                  this.tipoDocumentoIdentidad,
                                  this.numeroDocumentoIdentidad,
                                  this.userEmail}) : super(key: key);

  @override
  _UsuariosUsuariosPageState createState() => _UsuariosUsuariosPageState();
}

class _UsuariosUsuariosPageState extends State<UsuariosUsuariosPage> {
  bool _buscar = false;
  String textoBusqueda = '';
Widget _buildListUsuarios(String imagen, 
                          String nombre, 
                          String tipo, 
                          String identif, 
                          String correo, 
                          String usuario, 
                          int id, 
                          String url,
                          bool cargoUsuario){
  

    return 
      Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Container(
                color: Color(0xff5893d4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (BuildContext context ) => UsuarioEditarUsuarioPage(
                                idSocio: widget.value,
                                nombreCargoUsuario: usuario,
                                cargoUsuario: cargoUsuario,
                                idUsuario: id,
                                nombreUsuario: nombre,
                                tipoIdentificacionUsuario: tipo,
                                numeroIdentificacionUsuario: '$identif',
                                imagenUsuario: imagen,
                                url: url,

                              )
                            )
                          );
                        },
                        child: new CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          backgroundImage: new NetworkImage(imagen),
                        ),
                      ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (BuildContext context ) => UsuariosEspecificoPage(
                                      value: id,
                                      socioid: widget.value,
                                      url: url,
                                      nombre: nombre,
                                      identificacion: '$tipo $identif',
                                      correo: correo,
                                      cargo: usuario,
                                      imagen: imagen,
                                      
                                    )
                                  )
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    nombre,
                                    style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                  ),
                                  Text(
                                    '$tipo $identif',
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
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                onPressed: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (BuildContext context ) => UsuariosEspecificoPage(
                                        value: id,
                                        socioid: widget.value,
                                        url: url,
                                        nombre: nombre,
                                        identificacion: '$tipo $identif',
                                        correo: correo,
                                        cargo: usuario,
                                        imagen: imagen,
                                        
                                      )
                                    )
                                  );
                                },
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        );
  }



  var dataSectoristas;
  var dataGestores;
  String nombreSocio = '';
  String imagenSocio = '';
  String tipoidentificador = "";
  String identificador = '';
  String email = '';

  int cantSectoristas = 0;
  int cantGestores = 0;
  bool codes;

  _getUsuarios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlUsuario/usuariosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final socioSeleccionado = map["socio"];
      final listSectoristas = map["resultSectorista"];
      final listGestores= map["resultGestores"];
      final load = map["load"];
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreSocio = socioSeleccionado['personaNombre'];
        this.imagenSocio = socioSeleccionado['personaImagen'];
        this.tipoidentificador = socioSeleccionado['personaTipoIdentificacion'];
        this.identificador ="${socioSeleccionado['personaNumeroIdentificacion']}";
        this.email = socioSeleccionado['userEmail'];

        this.dataSectoristas = listSectoristas;
        this.dataGestores = listGestores;

        this.codes = code;
        if(codes){
          if(dataSectoristas != null){
            cantSectoristas = this.dataSectoristas.length;
            
          }else{
            cantSectoristas = 0;
            
          }
          if(dataGestores != null){
            cantGestores = this.dataGestores.length;
          }else{
            cantGestores = 0;
          } 
          
        }else{
          cantSectoristas = 0;
          cantGestores = 0;
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
      nombreSocio = widget.nombre;
      imagenSocio = widget.imagen;
      tipoidentificador = widget.tipoDocumentoIdentidad;
      identificador = widget.numeroDocumentoIdentidad;
      email = widget.userEmail;

    }
    // TODO: implement initState
    super.initState();
    _getUsuarios();
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
      key: _scaffoldKey,
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
              // height: 90.0,
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
                              Text(
                                '$tipoidentificador $identificador',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                email,
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Socio',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(Icons.ac_unit, color: Colors.white,),
                        //       // onPressed: () => Navigator.push(
                        //       //                     context, 
                        //       //                     MaterialPageRoute(
                        //       //                       builder: (BuildContext context ) => DatoClientesPage()
                        //       //                     )
                        //       //                   ),
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
                          
                          for(var cont =0; cont<cantSectoristas; cont++ )
                            if(dataSectoristas[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || dataSectoristas[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                            _buildListUsuarios(dataSectoristas[cont]['personaImagen'], 
                                                dataSectoristas[cont]['personaNombre'], 
                                                dataSectoristas[cont]['personaTipoIdentificacion'], 
                                                "${dataSectoristas[cont]['personaNumeroIdentificacion']}", 
                                                dataSectoristas[cont]['userEmail'], 'Sectorista',
                                                dataSectoristas[cont]['sectoristasId'], 'sectorista',true),
                          
                          for(var cont =0; cont<cantGestores; cont++ )                          
                            if(dataGestores[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || dataGestores[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                            _buildListUsuarios(dataGestores[cont]['personaImagen'], 
                                                dataGestores[cont]['personaNombre'], 
                                                dataGestores[cont]['personaTipoIdentificacion'], 
                                                "${dataGestores[cont]['personaNumeroIdentificacion']}", 
                                                dataGestores[cont]['userEmail'], 'Gestor', 
                                                dataGestores[cont]['gestorId'], 'gestor', false),
                          
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
                        FontAwesomeIcons.plus,
                        ), 
                  onPressed: () {
                    // addSectorUsuario(context); Agregar usuario o secto
                    usuarioBuscar(context);

                  },
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
              IconButton(icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white,), onPressed: () {
                _getUsuarios();
              },),
            ],
          ),
        ),
    );
    
  }
  Future<bool> addSectorUsuario(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  color: Color(0xFF070D59),
                  height: 160.0,
                  width: 200.0,
                  padding: EdgeInsets.all(10.0),
                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      SizedBox(height: 20.0),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Agregar un nuevo sector o usuario',
                                style: TextStyle(
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0,
                                  color: Colors.white
                                ),
                              ),
                              
                            ],
                          )
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                            Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  child: Center(
                                    child: Icon(
                                            FontAwesomeIcons.bezierCurve,
                                            ), 
                                  ),
                                  backgroundColor: Color(0xFF1f3c88),
                                  onPressed: () => {
                                    Navigator.of(context).pop(),
                                    addSector(context)
                                  },
                                ),
                                Center(
                                    child: Text(
                                      'Sector',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14.0,
                                          color: Colors.white,)
                                    ),
                                  ),
                              ],
                            ),
                          
                          Padding(
                            padding: EdgeInsets.all(15.0),
                          ),
                          
                            Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  child: Center(
                                    child: Icon(
                                            FontAwesomeIcons.userPlus,
                                            ), 
                                  ),
                                  backgroundColor: Color(0xFF1f3c88),
                                  onPressed: () => {
                                    Navigator.of(context).pop(),
                                    usuarioBuscar(context)
                                    },
                                ),
                                Center(
                                    child: Text(
                                      'Usuario',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14.0,
                                          color: Colors.white,)
                                    ),
                                  ),
                              ],
                            )
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

                        "idSocio": "${widget.value}" ,
                        "descripcion": descripcionSector.text ,
                        "api_token": apiToken,
                        
                      });

  }

final _scaffoldKey = GlobalKey<ScaffoldState>();
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
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Sector agregado correctamente'),
                              ));                              
                              // Navigator.of(context).pop();
                              // usuarioValido(context);
                            },
                            
                          ),
                        ),
                        
                      ],
                    )
                  ],
                )));
      });
  }



  TextEditingController emailBucar = TextEditingController();
  bool emailExiste = false;
  bool loadBuscadorEmail = true;

  Future<bool> usuarioBuscar(context) {
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
                              'Busca a tu proximo empleador',
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
                              controller: emailBucar,
                              keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "illapa@hotmail.com",
                                  labelText: "Correo",
                                ),
                              ),
                            if(emailExiste)
                              Text(
                                'Este correo no existe',
                                style: TextStyle(
                                  fontFamily: 'illapaBold',
                                  fontSize: 12.0,
                                  color: Colors.red
                                ),
                              ),
                          ],
                        )
                    ),
                    SizedBox(height: 15.0),
                    !loadBuscadorEmail
                    ?_loading()
                    :Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Color(0xFF1f3c88),
                            child: Center(
                              child: Text(
                                'BUSCAR',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.white,)
                              ),
                            ),
                            onPressed: () {
                              loadBuscadorEmail = false;
                              Navigator.of(context).pop();
                              
                              usuarioBuscar(context);
                              // usuarioValido(context);
                              _validarUsuario();
                              
                            },
                            
                          ),
                        ),
                      ],
                    )
                  ],
                )));
      });
  }
  int codesValidado;
  bool validadEmailAsociado = false;
  String emailUsuarioValidado;
  String nombreUsuarioValidado;
  int idSectoristaValido;
  String tipoidentificadorValido;
  String identificadorValido;
  String imagenValido;
  bool siAsociado;
  
  _validarUsuario() async{
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    

    var url =
          "$urlUsuario/usuarioValidarSocio";

        var response = await http.post(url, body: {
                        "api_token": apiToken,
                        "email": emailBucar.text,
                        "idEmpresaSeleccionada": "${widget.value}" ,
                      });

      print(url);
      final map = json.decode(response.body);
      final code = map["code"];
      final loadValidar = map["loadValidar"];
      final validadEmailAsociadoMap = map["pertenece"];
      final resultUsuario = map["resultUser"];
      final idSectoristaValido = map["idSectoristaValidado"];
      final siAsociado = map["siAsociado"];

      print(response.body);

      setState(() {
        this.codesValidado = code;
        this.loadBuscadorEmail = loadValidar;
        this.validadEmailAsociado = validadEmailAsociadoMap;
        
        if(codesValidado == 1){
          this.emailUsuarioValidado = resultUsuario['userEmail'];
          this.nombreUsuarioValidado = resultUsuario['personaNombre'];
          this.idSectoristaValido = idSectoristaValido;  
          print("idsectoristaValido: $idSectoristaValido" );
          this.tipoidentificadorValido = resultUsuario['personaTipoIdentificacion'];
          this.identificadorValido = "${resultUsuario['personaNumeroIdentificacion']}";
          this.imagenValido = resultUsuario['personaImagen'];
          this.siAsociado = siAsociado;
        }
        
      });
      if(codesValidado != 1){
        // ESTE CORREO NO EXISTE
          emailExiste = true;
          Navigator.of(context).pop();
          usuarioBuscar(context);
        }else{
          // ESTE CORREO EXISTE
          if(validadEmailAsociado){
            if(siAsociado){
              emailExiste = false;
              Navigator.of(context).pop();
              print("EXISTE");
              // Navigator.push(
              //           context, 
              //           MaterialPageRoute(
              //             builder: (BuildContext context ) => UsuarioAgregarSectorPage()
              //           )
              //         );
              
              print("Este correo existe y es socio de esta empresa");

            }else{
              emailExiste = false;
              Navigator.of(context).pop();
              usuarioValido(context);
              print("Este correo existe pero no es socio de esta empresas");
            }
          }else{
              emailExiste = false;
              Navigator.of(context).pop();
              usuarioValido(context);
              print("Este correo existe y no esta asociado a ninguna empresa");
          }
        }
  }

  Future<bool> usuarioValido(context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 320.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Color(0xFF070D59)),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage('$imagenValido'),
                                      fit: BoxFit.cover)),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            validadEmailAsociado
                            ?Text(
                              'Este usuario ya se encuentra asociado',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                color: Colors.red
                              ),
                            )
                            :Text(
                              'Este usuario esta disponible',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                color: Colors.greenAccent
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0) ,
                            ),
                            Text(
                              nombreUsuarioValidado,
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              emailUsuarioValidado,
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              '$tipoidentificadorValido: $identificadorValido',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            child: Center(
                              child: Text(
                                'ASOCIAR',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Color(0xFF070D59)),
                              ),
                            ),
                            
                            onPressed: validadEmailAsociado ? null : (){
                              // agregarUsuario();
                              Navigator.of(context).pop();
                              // _isLoading=false;
                              // _getUsuarios();
                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (BuildContext context ) => UsuarioNuevoPage(
                                      idSocio: widget.value,
                                      idUsuario: idSectoristaValido,
                                      nombreUsuario: nombreUsuarioValidado,
                                      tipoIdentificacionUsuario: tipoidentificadorValido,
                                      numeroIdentificacionUsuario: "$identificadorValido",
                                      imagenUsuario: imagenValido,
                                    )
                                  )
                                );

                              print("usuario asociado");
                            },
                            
                            disabledColor: Colors.grey,
                            color: Colors.transparent
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            child: Center(
                              child: Text(
                                'CANCELAR',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Color(0xFF070D59)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent
                          )
                        )
                        
                      ],
                    )
                  ],
                )));
      });
  }

  
}


 