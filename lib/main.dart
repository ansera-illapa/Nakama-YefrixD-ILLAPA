
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
import 'package:illapa/pages/gestiones/gestion.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionEmpresa.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeClientes.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionSectores.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/pages/login.dart';
import 'package:illapa/routes.dart';
import 'package:illapa/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() => runApp(
  MaterialApp(
    home: TodoApp(),
    routes: buildAppRoutes(),
    theme: ThemeData(primaryColor: Color(0xFF1F3C88),
  ))
);


class TodoApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TodoAppState();

}

class _TodoAppState extends State<TodoApp>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => _rootPage
          ),);
      },
    );



    getRootPage().then((Widget page) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString('idUsuarioPref'));
      print("-------------");
      String uId;
      try{
        print("UID:");
        print("-------------");
        print(prefs.getString('idUsuarioPref'));
        print("-------------");
        uId = prefs.getString('idUsuarioPref');
        print(uId);
      }catch(error){
        print("-------------");
        print("ERROR CATCH");
        print("-------------");
        setState(() {
          _rootPage = page;
        });
      }
      
      print("USUARIO CONECTADO:");
      print("$uId");
      if(uId == "null" || uId == null ){
        setState(() {
          _rootPage = page;
        });
      }else{

          _getVariables();
          int usuarioTipo = int.parse(prefs.getString('usuarioTipoPref'));
          print("-------------");
          print(usuarioTipo);
          int idUsuario = int.parse(uId);

          switch (usuarioTipo) {
          case 1: setState(() {
                  _rootPage = GestionSociosPage(
                    value: idUsuario
                  );
                });
             
                    
            break;
          case 2:setState(() {
                  _rootPage = GestionClientesPage(
                    value: idUsuario
                  );
                });
               
            break;
          case 3: setState(() {
                  _rootPage = GestionSectoresPage(
                    value: idUsuario
                  );
                });
            break;
            
          case 4: setState(() {
                  _rootPage = GestionEmpresaPage(
                    value: idUsuario
                  );
                });
            break;

          case 5: setState(() {
                  _rootPage = GfreeClientesPage(
                    value: idUsuario
                  );
                });
            break;
          case 99: Navigator.of(context).pushReplacementNamed('/gestion'); break;
          default:
        }
      }
    });
  }

  _getVariables() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      setState(() {
         apiTokenGlobal       = prefs.getString('apiTokenPref');
         tipousuarioGlobal    = int.parse(prefs.getString('usuarioTipoPref'));
         idusuarioGlobal      = int.parse(prefs.getString('idUsuarioPref'));
         imagenUsuarioGlobal  = prefs.getString('imagenLogeadoPref');
         nombreGlobal         = prefs.getString('nombreLogeadoPref');
      });

      print("VARIABLES GLOBALES : ");
      print(apiTokenGlobal);
      print(tipousuarioGlobal);
      print(idusuarioGlobal);
      print(imagenUsuarioGlobal);
      print(nombreGlobal);
  }
  
  Widget _rootPage = LoginPage();
  
  Future<Widget> getRootPage() async =>
    globalNombre == null 
     ?LoginPage()
     :GestionPage();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/cargando.jpg"),
            fit: BoxFit.cover
          ),
        ),

        child: Center(
          child: LogoImg(),
        )
      ),
    );

    
  }
}
