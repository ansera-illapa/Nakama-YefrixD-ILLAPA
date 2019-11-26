
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:illapa/pages/gestiones/gestion.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionEmpresa.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeClientes.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionSectores.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/pages/login.dart';
import 'package:illapa/pages/register.dart';
import 'package:illapa/routes.dart';
import 'package:illapa/widgets.dart';
import 'package:path_provider/path_provider.dart';




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
      final directory = await getApplicationDocumentsDirectory();
      final fileId = File('${directory.path}/id.txt');
      String uId;
      try{
        uId = await fileId.readAsString();
      }catch(error){
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

          
          final fileTipo = File('${directory.path}/tipo.txt');
          

          String uTipo = await fileTipo.readAsString();
          
          int usuarioTipo = int.parse(uTipo);
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
