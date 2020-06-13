import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/usuarios/usuarioAgregarSector.dart';
import 'package:illapa/pages/usuarios/usuarioSectores.dart';
import 'package:illapa/pages/usuarios/usuariosUsuarios.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuariosSociosPage extends StatefulWidget {
  final int value;
  final String imagen;
  final String nombre;
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String userEmail;
  UsuariosSociosPage({Key key, this.value,
                                this.imagen,
                                this.nombre,
                                this.tipoDocumentoIdentidad,
                                this.numeroDocumentoIdentidad,
                                this.userEmail}) : super(key: key);

  @override
  _UsuariosSociosPageState createState() => _UsuariosSociosPageState();
}

class _UsuariosSociosPageState extends State<UsuariosSociosPage> {
  bool _buscar = false;
  String textoBusqueda = '';
  bool ordenAZ = false;
  Widget _buidEstListEmpresas(String imagen, 
                              String nombre, 
                              String tipoDocumentoIdentidad, 
                              String numeroDocumentoIdentidad, 
                              String correo, 
                              String usuario, 
                              int idSocio ){
    
      return 
        Padding(
          padding: EdgeInsets.only(bottom: 1.0),
          child: Container(
                  color: Color(0xff5893d4),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: GestureDetector(
                          onTap: (){Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (BuildContext context ) => UsuariosSectoresPage(
                                        value: idSocio,
                                        nombre: nombre,
                                        imagen: imagen,
                                        tipoIdentificacion: tipoDocumentoIdentidad,
                                        identificacion: numeroDocumentoIdentidad,
                                        correo: correo,
                                      )
                                    )
                                  );},
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
                                      builder: (BuildContext context ) => UsuariosUsuariosPage(
                                        value: idSocio,
                                        nombre: nombre,
                                        imagen: imagen,
                                        tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                                        numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                                        userEmail: correo,
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
                              )
                            ),
                            new IconButton(
                                  icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                  onPressed: () => Navigator.push(
                                                      context, 
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context ) => UsuariosUsuariosPage(
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
        "$urlUsuario/sociosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/usuarios-usuariosSocios${widget.value}.json');
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

  agregarSocio() async{
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      print(idSectoristaValido);
      bool respuesta;
      var url =
          "$urlUsuario/agregarSocio";

        final response = await http.post(url, body: {

                        "idSectoristaValido": "$idSectoristaValido",
                        "idEmpresaSeleccionada": "${widget.value}" ,
                        "api_token": apiToken,
                        
                      });
        _getSocios();

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
      tipoidentificador = widget.tipoDocumentoIdentidad;
      identificador = widget.numeroDocumentoIdentidad;
      email = widget.userEmail;
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
      final fileData = File('${directory.path}/usuarios-usuariosSocios${widget.value}.json');

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
          this.nombreEmpresa = empresaSeleccionada['empresaNombre'];
          this.imagenEmpresa = empresaSeleccionada['personaImagen'];
          this.tipoidentificador = "${empresaSeleccionada['personaTipoIdentificacion']}";

          
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
                                '$tipoidentificador $identificador',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                email,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Empresa',
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
                          _buidEstListEmpresas(data[cont]['personaImagen'], 
                                                data[cont]['personaNombre'], 
                                                data[cont]['personaTipoIdentificacion'], 
                                                "${data[cont]['personaNumeroIdentificacion']}", 
                                                data[cont]['userEmail'], 'Socio', 
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
      floatingActionButtonLocation: 
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff1f3c88),
            child: 
                  const Icon(
                        FontAwesomeIcons.plus,
                        ), 
                  onPressed: () {
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
          print("idsector: $idSectoristaValido" );
          
          this.tipoidentificadorValido = resultUsuario['personaTipoIdentificacion'];
          this.imagenValido = resultUsuario['personaImagen'];
          this.identificadorValido = "${resultUsuario['personaNumeroIdentificacion']}";
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
              Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context ) => UsuarioAgregarSectorPage()
                        )
                      );
              
              print("Este correo existe y es socio de esta empresa");

            }else{
              emailExiste = false;
              Navigator.of(context).pop();
              usuarioValido(context);
              print("Este correo existe pero no es socio de esta empresa");
            }
          }else{
              emailExiste = false;
              Navigator.of(context).pop();
              usuarioValido(context);
              print("Este correo existe pero no es socio de esta empresa");
          }
          

        }

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
                              'Busca a tu socio',
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
                            emailExiste
                            ?Text(
                              'Este correo no existe',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                color: Colors.red
                              ),
                            )
                            :Text(''),
                            
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
                              agregarSocio();
                              Navigator.of(context).pop();
                              _isLoading=false;
                              
                              
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


