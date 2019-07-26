// import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/pages/confirmacion.dart';
import 'package:illapa/pages/gestiones/gestion.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionEmpresa.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeClientes.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/pages/recuperar.dart';
import 'package:illapa/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LoginPage extends StatefulWidget {
  final String apitoken;
  LoginPage({Key key, this.apitoken}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Future<SharedPreferences> _apiToken = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password; 
  String api;

  bool _isLoggingIn = false;

  _login() async{
    // String x = "${widget.apitoken}";    

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
      FirebaseUser  user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password);
      
      if(user.isEmailVerified){
        // final SharedPreferences apiToken = await _apiToken;
        var url =
          "$urlGlobal/api/loginApi";

        var response = await http.post(url, body: {
                        "email": _email,
                        "pass": _password,
                        
                      });
        final directory = await getApplicationDocumentsDirectory();
        final fileApi = File('${directory.path}/api.txt');
        final fileTipo = File('${directory.path}/tipo.txt');
        final fileId = File('${directory.path}/id.txt');
        final fileNombre = File('${directory.path}/nombre.txt');
        final fileImagen = File('${directory.path}/imagen.txt');

        final map = json.decode(response.body);
        final apiToken = map["api_token"];
        int usuarioTipo = map["tipoUsuario"];
        final idUsuario = map["id"];
        final nombreLogeado = map["nombreLogeado"];
        final imagenLogeado = map["imagenLogeado"];

        
        // final api = response.body;
        // print("Esta:"+api[0]);
        await fileApi.writeAsString(apiToken);
        await fileTipo.writeAsString("$usuarioTipo");
        await fileId.writeAsString("$idUsuario");
        await fileNombre.writeAsString("$nombreLogeado");
        await fileImagen.writeAsString("$imagenLogeado");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('nombre', "$nombreLogeado");

        print("api:$apiToken");
        print("Tipo:$usuarioTipo");
        print("Usuario:$idUsuario");
        print("Nombre:$nombreLogeado");
        print("Imagen:$imagenLogeado");

       

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
                null;
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





  @override
  Widget build(BuildContext context) {
    

    return new Scaffold(
      // appBar: new AppBar(
      // ),
      key: _scaffoldKey,
      
      body: WillPopScope(
        onWillPop: (){
          print('xd');
          // exit(0);
        },
        child: Container(
        
          padding: EdgeInsets.all(30.0),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       const Color(0xFF1F3C88),
          //       const Color(0xFF070D59),
          //     ],
          //     begin: Alignment.centerLeft,
          //     end: Alignment.centerRight
          //   )
          // ),
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
                    padding: EdgeInsets.only(top: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Correo Electronico',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
                        Container(
                          height: 33.0,

                          child: TextFormField(
                          
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                // hintText: "Illapa@hotmail.com",
                                // labelText: "Correo",
                                
                              ),

                              validator: (val){
                                if(val.isEmpty){
                                  return 'email incorrecto';
                                }else{
                                  return null;
                                }
                              },

                              onSaved: (val){
                                setState((){
                                  _email = val;
                                });
                              },
                            ),
                        ),
                        


                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                        ),

                        Text('Contraseña',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
                        Container(
                          height: 33.0,
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              // hintText: "**********",
                              // labelText: "Contraseña",
                            ),
                            onSaved: (val){
                              setState(() {
                                  _password = val;
                              });
                            },
                          ),
                        )



                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                  ),
                  new RaisedButton(
                    
                    child: new Text("Iniciar sesión"),
                    color: Color(0xffF7B633), 
                    onPressed: (){
                      _login();
                    },
                    
                  ),
                  Container(
                    height: 25.0,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GoogleSignInButton(
                                    text: '',
                                    onPressed: (){
                                      
                                    },
                                ),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                        ),
                        Expanded(
                          child: FacebookSignInButton(
                              text: '',
                              onPressed: (){},
                            ),
                        )
                        
                        
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
                          child: Text('Olvidé mi contraseña', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
                        ),
                        GestureDetector(
                          onTap: (){
                            print('xd');
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (BuildContext context ) => ConfirmacionPage(
                                  
                                )
                              )
                            );
                          },
                          child: Text('¿No has recibido correo de confirmación?', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacementNamed('/register');
                            print('registrate');
                          },
                          child: Text('¿No tienes cuenta? ¿Regístrate!', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
                        ),
                        
                        
                        
                      ],
                    ),

                  )

                ],
              ),
            ),
          ),
        ),
      )
      
      
    );
    
  }


}





// new Padding(
//         padding: const EdgeInsets.all(20.0),
        
//         child: new ListView(
//           children: <Widget>[
//             LogoImg(),
//             new RaisedButton(
//               onPressed: (){},
//               child: new Text("Iniciar sesión"),
//               color: Color(0xffF7B633), 
              
//             ),
//             new Padding(
//               padding: const EdgeInsets.all(5.0),
//             ),
//             GoogleSignInButton(
//                 text: 'Inicia sesión con Google',
//                 onPressed: () => _signIn()
//                   .then((FirebaseUser user) => print(user))
//                   .catchError((e) => print(e)),
//             ),
//             // new RaisedButton(
              
//             //   child: new Text("Sign In"),
//             //   color: Colors.green,
//             // ),
//             new Padding(
//               padding: const EdgeInsets.all(5.0),
//             ),
//             FacebookSignInButton(
//               text: 'Inicia sesión con Facebook',
//               onPressed: (){},
//             ),

//             // new RaisedButton(
//             //   onPressed: _signOut,
//             //   child: new Text("Sign out"),
//             //   color: Colors.red,
//             // ),
//             new Padding(
//               padding: const EdgeInsets.all(10.0),
//             ),
//           ],
//         ),
//       ),