import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/widgets.dart';
import 'package:http/http.dart' as http;


class RecuperarContrasenaPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      key: _scaffoldKey,
      body: Container(
        
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
                  padding: EdgeInsets.only(top: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Introduce tu correo electrónico para recuperar tu contraseña.\n',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new RaisedButton(
                          child: new Text(
                            "Recuperar",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'illapaBold',
                            ),
                          ),
                          color: Color(0xffF7B633), 
                          onPressed: (){
                            _forgotPassword();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text('Cancelar', style: TextStyle(color: Colors.black,)),
                          color: Colors.grey,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }


  bool _isSendingForgotPassword = false;
  _forgotPassword() async{
    if(_isSendingForgotPassword) return;
    setState(() {
     _isSendingForgotPassword = true; 
    });

    final form = _formKey.currentState;

    if(!form.validate()){
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
       _isSendingForgotPassword = false; 
      });
      return;
    }

    form.save();

    try{
      String email = _email.replaceAll(" ", "");
      // RECUPERAR CONTRASEÑA 

      String url ="$urlGlobalMails/recuperar/email/"+email;

      final response = await http.get(url);

      if (response.statusCode == 200) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Acabamos de enviarte un mensaje a tu correo.'),
          duration: Duration(seconds: 10),
        ));
      }else{
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Ocurrio un error al intentar conectar con el servidor'),
          duration: Duration(seconds: 10),
        ));
      }


      
    }catch(e){
      //MUESTRA LOS MENSAJES DE ERROR
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
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
        _isSendingForgotPassword = false;
      });
    }
  }

}