
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      if(await FirebaseAuth.instance.currentUser() == null ){
        setState(() {
          _rootPage = page;
        });
      }else{
        FirebaseUser  user = await FirebaseAuth.instance.currentUser();

        if(user.isEmailVerified == true){

          final directory = await getApplicationDocumentsDirectory();
          final fileTipo = File('${directory.path}/tipo.txt');
          final fileId = File('${directory.path}/id.txt');

          String uTipo = await fileTipo.readAsString();
          String uId = await fileId.readAsString();
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

        }else{
          setState(() {
            _rootPage = LoginPage();
          });
        }
        
      
      }
    });
  }
  
  
  Widget _rootPage = LoginPage();
  
  Future<Widget> getRootPage() async =>
    await FirebaseAuth.instance.currentUser() == null 
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
