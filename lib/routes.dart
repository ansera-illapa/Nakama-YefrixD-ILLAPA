import 'package:flutter/material.dart';
import 'package:illapa/extras/google_places/buscarLugares.dart';
import 'package:illapa/pages/configuraciones/configuracion.dart';
import 'package:illapa/pages/confirmacion.dart';
import 'package:illapa/pages/datos/dato.dart';
import 'package:illapa/pages/estadisticas/estadisticas.dart';
import 'package:illapa/pages/gestiones/gestion.dart';
import 'package:illapa/pages/login.dart';
import 'package:illapa/pages/register.dart';
import 'package:illapa/pages/vencimientos/vencMes.dart';
import 'package:illapa/pages/vencimientos/vencimiento.dart';




Map<String, WidgetBuilder> buildAppRoutes(){
  return{
    '/login': (BuildContext context) => new LoginPage(),
    '/register': (BuildContext context) => new RegisterPage(),
    '/confirmacion': (BuildContext context) => new ConfirmacionPage(),
    '/gestion': (BuildContext context) => new GestionPage(),
    
    '/vencimiento': (BuildContext context) => new VencimientoPage(), 
    '/vencmes': (BuildContext context) => new VencMesPage(), 



    '/estadistica': (BuildContext context) => new EstadisticaPage(), 
    '/datos': (BuildContext context) => new DatoPage(), 
    '/configuracion': (BuildContext context) => new ConfiguracionPage(), 

    "/search": (_) => CustomSearchScaffold(),


  };
}