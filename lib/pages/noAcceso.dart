import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
import 'package:illapa/widgets.dart';

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
      
      

      setState(() {
          tipoUsuario = tipousuarioGlobal;
          idUsuario = idusuarioGlobal;
          imagenUsuario = imagenUsuarioGlobal;

      });
      
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