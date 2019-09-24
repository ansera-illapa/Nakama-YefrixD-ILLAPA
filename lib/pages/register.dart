
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/pages/login.dart';
import 'package:illapa/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
  

 


class RegisterPage extends StatefulWidget {
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final _formKey = GlobalKey<FormState>();
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  
  String _email;
  String _nombre = '';
  String _password;
  String _dni;


  bool _isRegistering = false;
  bool correoExistente = false;
  String api;

  _register() async{  
  
    if(_isRegistering) return;

    setState(() {
     _isRegistering = true; 
     correoExistente = false;
    });

    

    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Registrando usuario'),
    ));
    
    final form = _formKey.currentState;

    if(!form.validate()){
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
       _isRegistering = false; 
      });
      return;
    }

    form.save();
    print(_password.length);
    if(_password.length < 5){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('La contraseña debe tener por lo menos 6 caracteres'),
      ));
      return;
    }
    
    try{
      String email = _email.replaceAll(" ", "");
      FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: _password);

        var url =
          "$urlGlobal/api/registrarpost";

        var response = await http.post(url, body: {
                        "tipoIdentificacion": identidadSeleccionada,
                        "nombre": _nombre,
                        "dni": _dni,
                        "email": email,
                        "pass": _password,
                        
                      });
        api = response.body;
        print('Respuesta ${response.body}');

        
      try{
        await user.sendEmailVerification();
        

      }catch(e){
        print('Ocurrio un error al enviar correo');
        print(e.message);

      }
    }catch(e){
      //MUESTRA LOS MENSAJES DE ERROR
      setState(() {
       correoExistente = true; 
      });
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Este correo ya existe"),
          duration: Duration(seconds: 5),
          
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
        _isRegistering = false;
        
      });
      if(correoExistente == false){
        
        modalRegistroExitoso(context);
      }
    }

  } 


  Future<bool> modalRegistroExitoso(context) {
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
                  child: ListView(
                    children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                          child: Column(
                            children: <Widget>[
                              Text('El usuario fue registrado exitosamente ahora solo falta la confirmación de correo electronico', 
                                style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      color: Color(0xfff7b633),
                                      padding: EdgeInsets.all(10.0),
                                      child: Text('Aceptar', style: TextStyle(color: Colors.white,)), //miomio
                                      onPressed: (){
                                        Navigator.of(context).pushReplacementNamed('/login');
                                      },
                                    )
                                  )
                                ],
                              )
                            ],
                          )
                        )
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
    print(url);
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
    print(tipoIdentidad);
    setState(() {
      identidadSeleccionada = tipoIdentidad;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTiposDocumentoIdentidad();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      // ),
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(20.0),
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
                  padding: EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[

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
                                onSaved: (val){
                                  setState((){
                                    _dni = val;
                                  });
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
                                      _nombre = val;
                                    });
                                  },
                            )
                          ),
                        ),
                      

                      TextFormField(
                        
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Illapa@hotmail.com",
                          labelText: "Correo",
                          
                        ),
                        validator: (val){
                          if(val.isEmpty){
                            return 'Debe ser una direccion de correo electronico existente';
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
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "**********",
                          labelText: "Contraseña",
                          
                        ),
                        validator: (val){
                          if(val.isEmpty){
                            return 'debe poner una contraseña';
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val){
                          setState(() {
                              _password = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                new RaisedButton(
                  
                  child: new Text("Registrarse"),
                  color: Color(0xffF7B633), 
                  onPressed: (){
                    
                    _register();

                  },
                  
                ),
                
                
                
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                ),
                
                Container(
                  child: Column(
                    children: <Widget>[

                      GestureDetector(
                        onTap: (){
                          print('olvide');
                        },
                        child: Text('¿Ya estas registrado?', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushReplacementNamed('/login');
                          print('olvide');
                        },
                        child: Text('Inicia sesión aquí', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
                      ),
                      
                    ],
                  ),

                )

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Text('Recuerda que al registrarte debes confirmar tu direccion de correo electronico', style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, )),
      )
    );
  }
}