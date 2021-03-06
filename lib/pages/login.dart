// import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
import 'package:illapa/pages/confirmacion.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionEmpresa.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeClientes.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionSectores.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/pages/recuperar.dart';
import 'package:illapa/pages/register.dart';
import 'package:illapa/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:illapa/widgets/modals.dart';

class LoginPage extends StatefulWidget {
  final String apitoken;
  LoginPage({Key key, this.apitoken}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool ocultarContrasena = true;
  _register() async{  
  
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Registrando usuario'),
    ));
    
    final form = _formKey.currentState;

    String url =
      "$urlGlobal/api/registrarpost";
    print(url);
    print('DATOS:');
    print(identidadSeleccionada);
    print(_nombre);
    print(_dni.text);
    print(_email);
    print(_password);

    var response = await http.post(url, body: {
                    "tipoIdentificacion": identidadSeleccionada,
                    "nombre": _nombre,
                    "dni": _dni.text,
                    "email": _email,
                    "pass": 'FacebokLogin',
                    
                  });
    print(response.statusCode           );
    if (response.statusCode == 200) {
      print('Respuesta ${response.body}');
      _loginSociality();

    }
    



  } 

  TextEditingController nombreOpcional = TextEditingController();
  TextEditingController _dni = TextEditingController();
  
  Future<bool> modalCampoIdentifiacacion(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 310.0,
                color: AppTheme.primary,
                padding: EdgeInsets.all(10.0),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0),),
                            Text('Ahora solo falta llenar algunos datos de identificación.', 
                                style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                            Padding(padding: EdgeInsets.only(top:20.0),),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: identidadSeleccionada,
                                      items: listTipos,
                                      onChanged: seleccionarIdentidad,

                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                      controller: _dni,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: "",
                                        labelText: "Numero Identificación",
                                        
                                      ),
                                      validator: (val){
                                        if(val.isEmpty){
                                          return 'Debe ser un DNI real';
                                        }else{
                                          return null;
                                        }
                                      },
                                      
                                    ),
                                  )
                                ),
                                
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                            ),
                            if(identidadSeleccionada != '1' && identidadSeleccionada != '2'  )
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: TextFormField(
                                    controller: nombreOpcional,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: "",
                                        labelText: "Nombres completos",
                                        
                                      ),
                                      validator: (val){
                                          if(val.isEmpty){
                                            return 'Este campo es necesario';
                                          }else{
                                            return null;
                                          }
                                        },
                                        onSaved: (val){
                                          setState((){
                                            nombreOpcional.text = val;
                                            _nombre = val;
                                          });
                                        },
                                  )
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                          color: AppTheme.naranja,
                                          padding: EdgeInsets.all(10.0),
                                          child: Text('Aceptar', style: TextStyle(color: Colors.white,)),
                                          onPressed: (){
                                            _register();
                                          },
                                        )
                                  )
                                ],
                              )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
            );
        });
  }


  List<DropdownMenuItem<String>> listTipos = new List();
  _getTiposDocumentoIdentidad() async{

    final url =
        "$urlGlobal/api/tiposDocumentosIdentidad";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final tipos = map["tipos"];
      final load = map["load"];


      setState(() {
          for(int cont = 0; cont < tipos.length ; cont++){
            listTipos.add(new DropdownMenuItem(
                value: tipos[cont]['id'].toString(),
                child: new Text(" "+tipos[cont]['nombre'])
            ));
          }
          
      });

    }

  }

  String identidadSeleccionada;
  void seleccionarIdentidad(String tipoIdentidad) {
    Navigator.of(context).pop();
    modalCampoIdentifiacacion(context);
    print(tipoIdentidad);
    setState(() {
      identidadSeleccionada = tipoIdentidad;
    });
  }

  _loginSociality() async{
     
    try{
      
        String url = "$urlGlobal/api/loginSocialityApi";
        print(url);
        var response = await http.post(url, body: {
                        "email": _email,
                        "pass": 'FacebokLogin',
                        
                      });
        print(response.body);
        final map = json.decode(response.body);
        final code = map["code"];
        print('CODE ');
        print(code);
        if(code == false){
          modalCampoIdentifiacacion(context);
        }else{

          final apiToken = map["api_token"];
          int usuarioTipo = map["tipoUsuario"];
          final idUsuario = map["id"];
          final nombreLogeado = map["nombreLogeado"];
          final imagenLogeado = map["imagenLogeado"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('apiTokenPref', "$apiToken");
          await prefs.setString('usuarioTipoPref', "$usuarioTipo");
          await prefs.setString('idUsuarioPref', "$idUsuario");
          await prefs.setString('nombreLogeadoPref', "$nombreLogeado");
          await prefs.setString('imagenLogeadoPref', "$imagenLogeado");

          final directory = await getApplicationDocumentsDirectory();
          final fileApi = File('${directory.path}/api.txt');
          await fileApi.writeAsString('$apiToken');        

          switch (usuarioTipo) {
            case 1: Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context ) => GestionSociosPage(
                            value: idUsuario
                          )
                        )
                      );
                      
              break;
            case 2: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GestionClientesPage(
                      value: idUsuario
                    )
                  )
                );
              break;
            case 3: 
                  Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GestionSectoresPage(
                      value: idUsuario
                    )
                  )
                );
              break;
            case 4: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GestionEmpresaPage(
                      value: idUsuario
                    )
                  )
                );
              break;

            case 5: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GfreeClientesPage(
                      value: idUsuario
                    )
                  )
                );
              break;
            case 99: Navigator.of(context).pushReplacementNamed('/gestion'); break;
            default:
          }
        }
      
    }catch(e){
      //MUESTRA LOS MENSAJES DE ERROR
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Correo incorrecta'),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Cerrar',
            onPressed: (){
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally{
      setState((){
        _isLoggingIn = false;
      });
    }

  }


  _loginConFb() async {
    final facebookLogin = new FacebookLogin();

    final facebookLoginResult = await facebookLogin
            .logInWithReadPermissions(['email', 'public_profile']);

        switch (facebookLoginResult.status) {
          case FacebookLoginStatus.error:
             _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('hubo un problema al momento de iniciar sesion con FACEBOOK.'),
                duration: Duration(seconds: 10),
                action: SnackBarAction(
                  label: 'Cerrar',
                  onPressed: (){
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                  },
                ),
              ),
            );
            break;

          case FacebookLoginStatus.cancelledByUser:
              _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('hubo un problema al momento de iniciar sesion con FACEBOOK.'),
                duration: Duration(seconds: 10),
                action: SnackBarAction(
                  label: 'Cerrar',
                  onPressed: (){
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                  },
                ),
              ),
            );
            break;  

          case FacebookLoginStatus.loggedIn:

            FacebookAccessToken myToken = facebookLoginResult.accessToken;
            
            final token = facebookLoginResult.accessToken.token;
            final graphResponse = await http.get(
                        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
            final profile = json.decode(graphResponse.body);
            print('DATOS');
            print(profile);
            print(profile['email']);
            setState(() {
             _email =  profile['email'];
             _nombre = profile['first_name'];
             _apellidos = profile['last_name'];
             nombreOpcional.text = _nombre+' '+_apellidos;
            });
            _loginSociality();
            
        }
    }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTiposDocumentoIdentidad();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _nombre;
  String _apellidos;
  String _email;
  
  String _password; 
  String api;

  bool _isLoggingIn = false;

  _login() async{
    if(_isLoggingIn) return;

    setState(() {
     _isLoggingIn = true;
    });

    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Validando'),
    ));
    final form = _formKey.currentState;

    if(!form.validate()){
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
       _isLoggingIn = false; 
      });
      return;
    }

    form.save();

    try{
      String email = _email.replaceAll(" ", "");
      // LOGIN USUARIO
        
      String url =
        "$urlGlobal/api/loginApi";

      var response = await http.post(url, body: {
                      "email": email,
                      "pass": _password,
                    });
      print(response.body);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);

        final apiToken      = map["api_token"];
        int   usuarioTipo   = map["tipoUsuario"];
        final idUsuario     = map["id"];
        final nombreLogeado = map["nombreLogeado"];
        final imagenLogeado = map["imagenLogeado"];
        final verificado    = map["verificado"];

        globalNombre = "$nombreLogeado";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('apiTokenPref', "$apiToken");
        await prefs.setString('usuarioTipoPref', "$usuarioTipo");
        await prefs.setString('idUsuarioPref', "$idUsuario");
        await prefs.setString('nombreLogeadoPref', "$nombreLogeado");
        await prefs.setString('imagenLogeadoPref', "$imagenLogeado");

        final directory = await getApplicationDocumentsDirectory();
        final fileApi = File('${directory.path}/api.txt');
        await fileApi.writeAsString('$apiToken');

        setState(() {
          apiTokenGlobal       = prefs.getString('apiTokenPref');
          tipousuarioGlobal    = int.parse(prefs.getString('usuarioTipoPref'));
          idusuarioGlobal      = int.parse(prefs.getString('idUsuarioPref'));
          imagenUsuarioGlobal  = prefs.getString('imagenLogeadoPref');
          imagenUsuarioGlobalJunto  = urlImagenes+imagenUsuarioGlobal;
          nombreGlobal         = prefs.getString('nombreLogeadoPref');
        });

        if(verificado){
          switch (usuarioTipo) {
            case 1: Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context ) => GestionSociosPage(
                            value: idUsuario
                          )
                        )
                      );
                      
              break;
            case 2: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GestionClientesPage(
                      value: idUsuario
                    )
                  )
                );
              break;
            case 3: 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context ) => GestionSectoresPage(
                        value: idUsuario
                      )
                    )
                  );
              break;
            case 4: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GestionEmpresaPage(
                      value: idUsuario
                    )
                  )
                );
              break;

            case 5: Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => GfreeClientesPage(
                      value: idUsuario
                    )
                  )
                );
              break;
            case 99: Navigator.of(context).pushReplacementNamed('/gestion'); break;
            default:
          }
        }else{
          print('no confirmo');
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Este correo no ha sido confirmado'),
          ));
        }
        

      }else{
        print('Servidor');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Problemas con el servidor intentelo mas tarde'),
        ));
      }           
      
      
        
      
    }catch(e){
      //MUESTRA LOS MENSAJES DE ERROR
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Correo o contraseña incorrecta'),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Cerrar',
            onPressed: (){
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally{
      setState((){
        _isLoggingIn = false;
      });
    }

  }




  
  GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: ['email']);

  // LOGIN WITH GOOGLE
   _loginGoogle() async{
     try{
       await _googleSignIn.signIn();
       setState(() {
          print('login setstate');
          print(_googleSignIn.currentUser.displayName);
       });
     }catch(err){
       print(err);
     }
   }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: (){
          modalMensaje.modalOpcion(
            context, 
            "Estas apunto de cerrar la aplicación", 
            (){
              exit(0);
            }, 
            AppTheme.primary
            
          );
          
        },
        child: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/fondo.jpeg"),
              fit: BoxFit.cover
            ),
          ),
          child: ScrollConfiguration(
            behavior: HiddenScrollBehavior(),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  LogoImg(),
                  Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Correo Electronico',
                          style: TextStyle(
                            color: Colors.white, 
                            fontFamily: 'illapaBold'
                            ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 10.0, ),
                            child: Container(
                              height: 37,
                              padding: EdgeInsets.only(left:10.0, right: 10.0, ),
                              color: Colors.white,
                              child: TextFormField(
                                onSaved: (val){
                                  setState((){
                                    _email = val;
                                  });
                                },
                              // obscureText: ocultarContrasena,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 16.0,
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontFamily: AppTheme.fontName, 
                                    fontSize: 16.0
                                ),
                              ),
                            ),
                          )
                        ),
                        Text(
                          'Contraseña',  
                          style: TextStyle(
                            color: Colors.white, 
                            fontFamily: 'illapaBold',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, ),
                            child: Container(
                              height: 37,
                              padding: EdgeInsets.only(left:10.0,  ),
                              color: Colors.white,
                              child: TextFormField(
                                onSaved: (val){
                                  setState(() {
                                      _password = val;
                                  });
                                },
                              obscureText: ocultarContrasena,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 16.0,
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontFamily: AppTheme.fontName, 
                                    fontSize: 16.0
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      if(ocultarContrasena){
                                        ocultarContrasena = false;
                                      }else{
                                        ocultarContrasena = true;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                      ocultarContrasena
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                )
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                  ),
                  new RaisedButton(
                    child: new Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'illapaBold',
                      ),
                    ),
                    color: AppTheme.naranja, 
                    onPressed: (){
                      _login();
                    },
                  ),
                  Container(
                    height: 25.0,
                    child: Row(
                      children: <Widget>[
                        // Expanded(
                        //   child: GoogleSignInButton(
                        //     text: '',
                        //     onPressed: () => _loginGoogle()
                        //     ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(right: 5.0),
                        // ),
                        // Expanded(
                        //   child: FacebookSignInButton(
                        //       text: '',
                        //       onPressed: () =>_loginConFb(),
                        //     ),
                        // )
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (BuildContext context ) => RecuperarContrasenaPage(
                                  
                                )
                              )
                            );
                          },
                          child: Text(
                            'Olvidé mi contraseña', 
                            style: new TextStyle(
                              fontFamily: 'illapaBold', 
                              color: Colors.white,
                              )
                            ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (BuildContext context ) => ConfirmacionPage(
                                )
                              )
                            );
                          },
                          child: Text(
                            '¿No has recibido correo de confirmación?', 
                            style: new TextStyle(
                              fontFamily: 'illapaBold', 
                              color: Colors.white, 
                              )
                            ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (BuildContext context ) => RegisterPage(
                                  
                                )
                              )
                            );
                          },
                          child: Text(
                            '¿No tienes cuenta? ¿Regístrate!', 
                            style: new TextStyle(
                              fontFamily: 'illapaBold', 
                              color: Colors.white, 
                              )
                            ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15.0),
                          child: GestureDetector(
                            onTap: (){
                              exit(0);
                            },
                            child: Text(
                              'Salir', 
                              style: new TextStyle(
                                fontFamily: 'illapaBold', 
                                color: Colors.white, 
                                )
                              ),
                          ),
                        )
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/fondo.jpeg"),
              fit: BoxFit.cover
            ),
          ),
        child: Text(
          // 'V2.3p',
          globalVersion,
          style: new TextStyle(
            fontFamily: 'illapaBold', 
            color: Colors.white, 
          ),
          textAlign: TextAlign.end,
        ),
      )
    );
  }
}