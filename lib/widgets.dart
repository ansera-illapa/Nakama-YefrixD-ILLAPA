import 'dart:io';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
import 'package:illapa/extras/google_places/buscarLugares.dart';
import 'package:illapa/pages/configuraciones/configuracion.dart';
import 'package:illapa/pages/datos/dato.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/datos/datosFree/datFreeClientes.dart';
import 'package:illapa/pages/datos/datosSocios.dart';
import 'package:illapa/pages/estadisticas/estadisticaFree/estFreeClientes.dart';
import 'package:illapa/pages/estadisticas/estadisticaGestor/estadisticaGestor.dart';
import 'package:illapa/pages/estadisticas/estadisticas.dart';
import 'package:illapa/pages/estadisticas/estadisticasClientes.dart';
import 'package:illapa/pages/estadisticas/estadisticasSectorista/estadisticasSectores.dart';
import 'package:illapa/pages/estadisticas/estadisticasSocios.dart';
import 'package:illapa/pages/gestiones/gestion.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionEmpresa.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeClientes.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionSectores.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/pages/login.dart';
import 'package:illapa/pages/noAcceso.dart';
import 'package:illapa/pages/tramos/tramosEmpresas.dart';
import 'package:illapa/pages/tramos/tramosMostrar.dart';
import 'package:illapa/pages/tramos/tramosSocios.dart';
import 'package:illapa/pages/usuarios/usuariosEmpresas.dart';
import 'package:illapa/pages/usuarios/usuariosSocios.dart';
import 'package:illapa/pages/usuarios/usuariosUsuarios.dart';
import 'package:illapa/pages/vencimientos/vencimiento.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Texty extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Container(child: new Text('Word'),);
  }
  
}



class LogoImg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var assetsImage = new AssetImage('assets/img/LogoIllapa.png');
    var image = new Image(
      image: assetsImage, 
      width: 150.0, 
      height: 130,
      
      );
    return new Container( 
      child: image,
    
    );
  }
}






class Sidebar extends StatelessWidget {
  
  Sidebar({Key key}) : super(key: key );

  @override
  Widget build(BuildContext context) {
    
    _logout() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiTokenPref', "ApiEliminada");
      await prefs.setString('idUsuarioPref', "null");

      exit(0);
      // Navigator.push(
      // context,
      // new MaterialPageRoute(
      //     builder: (BuildContext context) => new LoginPage()));
    }

    _rutaGestion(){
      _ruta(){
        if(tipousuarioGlobal == 1){
          return new GestionSociosPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 2){
          return new GestionClientesPage(
            value: idusuarioGlobal
          );
        }else if(tipousuarioGlobal == 3){
          return new GestionSectoresPage(
            value: idusuarioGlobal
          );
        }else if(tipousuarioGlobal == 4){
          return new GestionEmpresaPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 5){
          return new GfreeClientesPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 99){
          return new GestionPage(
          );
        }
      } 
      
      return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>_ruta()));
    }

    _rutaVencimiento(){
      _ruta(){
        if(tipousuarioGlobal == 1){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'empresa',
          );
         
        }else if(tipousuarioGlobal == 2){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'socio',
          );
        }else if(tipousuarioGlobal == 3){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'sectorista',
          );
        }else if(tipousuarioGlobal == 4){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'gestor',
          );
         
        }else if(tipousuarioGlobal == 5){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'free',
          );
         
        }else if(tipousuarioGlobal == 99){
          return new VencimientoPage(
            id: idusuarioGlobal,
            url: 'admin',
          );
         
        }
        
      } 
      
      return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>_ruta()));
    }

    _rutaEstadisticas(){
      _ruta(){
        if(tipousuarioGlobal == 1){
          return new EstadisticasSociosPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 2){
          return new EstadisticasClientesPage(
            value: idusuarioGlobal
          );
        }else if(tipousuarioGlobal == 3){
          return new EstadisticaSectoresPage(
            value: idusuarioGlobal
          );
        }else if(tipousuarioGlobal == 4){
          return new EstadisticaGestorPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 5){
          return new EstFreeClientesPage(
            value: idusuarioGlobal
          );
         
        }else if(tipousuarioGlobal == 99){
          return new EstadisticaPage(
            
          );
         
        }
      } 
      
      return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>_ruta()));
    }

    _rutaDatos(){

      if(tipousuarioGlobal == 1){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => DatoSociosPage(
                  value: idusuarioGlobal      
                )));
        }else if(tipousuarioGlobal == 2){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => DatoClientesPage(
                  value: idusuarioGlobal      
                )));
        }else if(tipousuarioGlobal == 3){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));

          
        }else if(tipousuarioGlobal == 4){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
         
         
        }else if(tipousuarioGlobal == 5){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => DatFreeClientesPage(
                  value: idusuarioGlobal      
                )));

         
        }else if(tipousuarioGlobal == 99){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => DatoPage(
                  
                )));
         
        }
      
    }

    _rutaUsuarios(){
      // _ruta(){
        if(tipousuarioGlobal == 1){
          return Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => new UsuariosSociosPage(
              value: idusuarioGlobal
            )
          ));
         
         
        }else if(tipousuarioGlobal == 2){
          return Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => new UsuariosUsuariosPage(
              value: idusuarioGlobal
            )
          ));
          
          // return new UsuariosEmpresasPage();
        }else if(tipousuarioGlobal == 3){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
          
        }else if(tipousuarioGlobal == 4){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
          
         
        }else if(tipousuarioGlobal == 5){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));

         
        }else if(tipousuarioGlobal == 99){
          return Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => new UsuariosEmpresasPage()
          ));
         
        }
      // } 
      
      // return Navigator.push(
      //   context,
      //   new MaterialPageRoute(
      //       builder: (BuildContext context) =>_ruta()));
    }

    _rutaTramos(){
      // _ruta(){
        if(tipousuarioGlobal == 1){
          return Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>TramosSociosPage(
                      value: idusuarioGlobal
                    )));
         
        }else if(tipousuarioGlobal == 2){
           return Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>TramosMostrarPage(
                      value: idusuarioGlobal
                    )));
          
        }else if(tipousuarioGlobal == 3){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
          
        }else if(tipousuarioGlobal == 4){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
          
         
        }else if(tipousuarioGlobal == 5){
          return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => NoAccesoPage(
                )));
        }
        else if(tipousuarioGlobal == 99){
            return Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>TramosEmpresasPage()));

         
        }
      // } 
      
      // return Navigator.push(
      //   context,
      //   new MaterialPageRoute(
      //       builder: (BuildContext context) =>_ruta()));
    }

    String cargo = "";
    switch (tipousuarioGlobal) {
      case 1:
        cargo = "Empresa";  
        break;
      case 2:
        cargo = "Socio";
        break;
      case 3:
        cargo = "Sectorista";
        break;
      case 4:
        cargo = "Gestor";
        break;
      case 5:
        cargo = "Free";
        break;
      case 99:
        cargo = "Administrador";
        break;
      default:
    }
    
    var imagenSidebar = '';
    if( imagenUsuarioGlobal != null ){
      imagenSidebar = imagenUsuarioGlobal;
    }

    return 
         Drawer(
            child: ListView(
              children: <Widget>[
              
              Container(
                color: Color(0xFF070D59),
                child: UserAccountsDrawerHeader(
                  
                  currentAccountPicture: new CircleAvatar(
                    
                    backgroundColor: Color(0xFF070D59),
                    backgroundImage: new NetworkImage(imagenSidebar),
                    
                  ),
                
                  accountName: new Text('$nombreGlobal', 
                    style: TextStyle(
                      fontFamily: 'illapaBold',
                    )),
                  accountEmail: Column(
                    children: <Widget>[
                      Text(
                        cargo,
                        style: TextStyle(
                          fontFamily: 'illapaMedium',
                        ),
                      ),
                      // Text('DEMO',style: TextStyle(
                      //     fontFamily: 'illapaMedium',
                      //   ),
                      // )
                    ],
                  )
                    
                  
                  
                ),
              ),
              
              Ink(
                color: Color(0xFF5893D4),
                child: ListTile(
                  trailing: Icon(FontAwesomeIcons.solidLightbulb , color: Colors.white,),
                  title: new 
                    Text(
                      'Gestión', 
                      style: 
                        TextStyle(
                          color: Colors.white,
                          fontFamily: 'illapaBold'
                        ),
                    ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // rutaGestion();
                    _rutaGestion();
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                
                
                child: ListTile(
                  trailing: Icon(FontAwesomeIcons.clock, color: Colors.white,),
                  title: new Text('Vencimientos', style: TextStyle(color: Colors.white,fontFamily: 'illapaBold' ),),
                  onTap: () {
                    Navigator.of(context).pop();
                    _rutaVencimiento();
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (BuildContext context) => new VencimientoPage()));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                child: ListTile(
                  trailing: Icon(FontAwesomeIcons.chartLine, color: Colors.white,),
                  title: new Text('Estadísticas', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold'),),
                  onTap: () {
                    Navigator.of(context).pop();
                    _rutaEstadisticas();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                child: ListTile(
                  trailing: Icon(FontAwesomeIcons.file, color: Colors.white,),
                  title: new Text('Datos', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold'),),
                  onTap: () {
                    Navigator.of(context).pop();
                    _rutaDatos();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              // Ink(
              //   color: Color(0xFF5893D4),
              //   child: 
              //   ListTile(
              //     title: new Text('Configuración', style: TextStyle(color: Colors.white,fontFamily: 'illapaBold'),),
              //     onTap: () {
              //       Navigator.of(context).pop();
              //       Navigator.push(
              //           context,
              //           new MaterialPageRoute(
              //               builder: (BuildContext context) => new NoAccesoPage()));
              //     },
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                child: 
                ListTile(
                  trailing: Icon(FontAwesomeIcons.userPlus, color: Colors.white,),
                  title: new Text('Usuarios', style: TextStyle(color: Colors.white,fontFamily: 'illapaBold'),),
                  onTap: () {
                    
                    Navigator.of(context).pop();
                    _rutaUsuarios();


                  },
                  
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                child: ListTile(
                  
                  title: new Text('Tramos', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold'),),
                  onTap: () {
                    Navigator.of(context).pop();
                    _rutaTramos();
                  },
                  trailing: Icon(Icons.pie_chart, color: Colors.white,),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 1.0),
              ),
              Ink(
                color: Color(0xFF5893D4),
                child: ListTile(
                  
                  title: new Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold'),),
                  onTap: () {
                    // Navigator.of(context).pop();
                    _logout();
                    
                  },
                  trailing: Icon(Icons.exit_to_app, color: Colors.white,),
                ),
              ),
              
            ],
            ),
          );
  }

}

