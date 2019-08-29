import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/usuarios/usuariosSocios.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NoAccesoPage extends StatefulWidget {
  @override
  _NoAccesoPageState createState() => _NoAccesoPageState();
}

class _NoAccesoPageState extends State<NoAccesoPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

      setState(() {
          tipoUsuario = int.parse(tipoUsuarioInt);
          idUsuario = int.parse(idUsuarioInt);
          imagenUsuario = imagenUsuarioString;

      });
      
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");

  }
  
  @override
  Widget build(BuildContext context) {
    

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('SIN ACCESO'),
        backgroundColor: Color(0xFF070D59),
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
              // color: Color(0xff1f3c88),
              // height: 90.0,
              child: Column(
                children: <Widget>[
                  Text('Lo sentimos, no tienes acceso a esta interfaz. Para solicitar acceso y saber mas sobre este aplicativo porfavor llamar a: 997545414. Gracias !', style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 15.0,
                                color: Colors.white
                              ),)
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}