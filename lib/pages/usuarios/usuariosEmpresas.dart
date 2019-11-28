import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/usuarios/usuariosSocios.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuariosEmpresasPage extends StatefulWidget {
  @override
  _UsuariosEmpresasPageState createState() => _UsuariosEmpresasPageState();
}

class _UsuariosEmpresasPageState extends State<UsuariosEmpresasPage> {
  bool _buscar = false;
  String textoBusqueda = '' ;
  bool ordenAZ = false;
Widget _buildListGestionEmpresas(String imagen, 
                                String nombre, 
                                String tipoDocumentoIdentidad, 
                                String numeroDocumentoIdentidad, 
                                String userEmail, 
                                String usuario, 
                                int idEmpresa){
  
    return 
    GestureDetector(
      onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => UsuariosSociosPage(
                    value: idEmpresa,
                    imagen: imagen,
                    nombre: nombre,
                    tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                    numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                    userEmail: userEmail,
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
                                  '$tipoDocumentoIdentidad $numeroDocumentoIdentidad',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$userEmail',
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
                                                      builder: (BuildContext context ) => UsuariosSociosPage(
                                                        value: idEmpresa,
                                                        imagen: imagen,
                                                        nombre: nombre,
                                                        tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                                                        numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                                                        userEmail: userEmail,
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
  int cantEmpresas = 0;
  _getDato() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    final url =
        "$urlUsuario/empresasTodas?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {

        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/usuarios/usuariosEmpresas.json');
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
  _agregarEmpresa() async{
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      
      print(apiToken);
      print(nombreEmpresaNueva.text);
      print(idSectoristaValido);
      bool respuesta;
      var url =
          "$urlUsuario/agregarEmpresa";

        final response = await http.post(url, body: {
                        "idSectoristaValido": "$idSectoristaValido",
                        "nombreEmpresa": nombreEmpresaNueva.text,
                        "api_token": apiToken,
                      });
      _getDato();

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
    _getDato();
    _getVariables();
  }

  
  TextEditingController emailBucar = TextEditingController();
  TextEditingController nombreEmpresaNueva = TextEditingController();
  int codes;
  bool emailExiste = false;
  bool loadBuscadorEmail = true;

  bool validadEmailAsociado = false;

  String nombreUsuarioValidado;
  String emailUsuarioValidado;
  String imagenUsuarioValidado;
  String tipoidentificador;
  String identificador;
  int idSectoristaValido;

  _validarUsuario() async{
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    

    var url =
          "$urlUsuario/usuarioValidar";

        var response = await http.post(url, body: {
                        "api_token": apiToken,
                        "email": emailBucar.text,
                      });

      print(url);
      final map = json.decode(response.body);
      final code = map["code"];
      final loadValidar = map["loadValidar"];
      final validadEmailAsociadoMap = map["pertenece"];
      final resultUsuario = map["resultUser"];
      final idSectoristaValido = map["idSectoristaValidado"];
      
      print(response.body);

      setState(() {
        this.codes = code;
        this.loadBuscadorEmail = loadValidar;
        this.validadEmailAsociado = validadEmailAsociadoMap;
        
        if(code == 1){
          this.emailUsuarioValidado = resultUsuario['userEmail'];
          this.nombreUsuarioValidado = resultUsuario['personaNombre'];
          this.idSectoristaValido = idSectoristaValido;  
          print("idsector: $idSectoristaValido" );

          this.tipoidentificador = resultUsuario['personaTipoIdentificacion'];
          this.identificador = "${resultUsuario['personaNumeroIdentificacion']}";
          this.imagenUsuarioValidado = resultUsuario['personaImagen'];

        }
                
      });
      if(code != 1){
          emailExiste = true;
          Navigator.of(context).pop();
          usuarioBuscar(context);
        }else{
          emailExiste = false;
          Navigator.of(context).pop();
          usuarioValido(context);
        }
      
    

  }


  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;

  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/usuarios/usuariosEmpresas.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final users = map["result"];
        final load = map["load"];
        final code = map["code"];
        print(code);
        setState(() {
          _isLoading = load;
          this.data = users;
          if(code == true){
            cantEmpresas = this.data.length;  
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
                      backgroundImage: new NetworkImage(imagenAdmin),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Illapa',
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                'illpa@hotmail.com',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                "Administrador",
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
                          for(var cont =0; cont<cantEmpresas; cont++ )
                            if(data[cont]['empresaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['empresaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                              _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                        data[cont]['empresaNombre'], 
                                                        data[cont]['personaTipoIdentificacion'], 
                                                        "${data[cont]['personaNumeroIdentificacion']}", 
                                                        data[cont]['userEmail'], 'Empresas', 
                                                        data[cont]['empresaId']),
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
                    return orderZA(a['empresaNombre'],b['empresaNombre']);
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
                    return orderAZ(a['empresaNombre'],b['empresaNombre']);
                  });
                },
              )


            ],
          ),
        ),
    );
    
  }

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

  Future<bool> nombreEmpresa(context) {
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
                            Center(
                              child: Text(
                                  'Nombre de la empresa',
                                  style: TextStyle(
                                    fontFamily: 'illapaBold',
                                    fontSize: 15.0,
                                    color: Colors.white
                                  ),
                                ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            TextField(
                              controller: nombreEmpresaNueva,
                              keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Empresa",
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
                              
                              _agregarEmpresa();
                              Navigator.of(context).pop();
                              _isLoading=false;
                              
                              
                            },
                            
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
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
                                          NetworkImage('$imagenUsuarioValidado'),
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
                              '$tipoidentificador: $identificador',
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

                              Navigator.of(context).pop();
                              nombreEmpresa(context);
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