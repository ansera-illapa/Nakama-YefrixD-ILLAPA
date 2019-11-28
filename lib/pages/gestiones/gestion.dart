import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesGlobales.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
import 'package:illapa/pages/gestiones/gestionFMAdministrador.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class GestionPage extends StatefulWidget {

  @override
  _GestionPageState createState() => _GestionPageState();
}

class _GestionPageState extends State<GestionPage> {
  bool _buscar = false;
  String textoBusqueda = '' ;
  bool ordenAZ = true;
  bool ordenZA = false;
  bool orden19 = false;
  bool orden91 = false;

  var moneyType = new NumberFormat("#,##0.00", "en_US");
Widget _buildListGestionEmpresas(String imagen, 
                                  String nombreEmpresa, 
                                  int numeroDocumentos, 
                                  String sumaImportesDocumentos, 
                                  int numeroDocumentosVencidos, 
                                  String sumaImportesDocumentosVencidos, 
                                  int idEmpresa){
    
  return 
        GestureDetector(
          onTap: (){Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context ) => GestionSociosPage(
                          value: idEmpresa,
                          nombre: nombreEmpresa,
                          imagen: imagen,
                          numeroDocumentos: numeroDocumentos,
                          sumaImportesDocumentos: sumaImportesDocumentos,
                          numeroDocumentosVencidos: numeroDocumentosVencidos,
                          sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,

                        )
                      )
                    );},
          child: Padding(
            padding: EdgeInsets.only(bottom: 1.0),
            child: Container(
                    color: Color(0xff5893d4),
                    child: Column(
                      children: <Widget>[
                        
                        ListTile(
                          leading: new CircleAvatar(
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey,
                            backgroundImage: new NetworkImage(imagen),
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      nombreEmpresa,
                                      style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                    ),
                                    Text(
                                      '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))}',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                  ],
                                ),
                              ),
                              new IconButton(
                                    icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                    onPressed: () => Navigator.push(
                                                        context, 
                                                        MaterialPageRoute(
                                                          builder: (BuildContext context ) => GestionSociosPage(
                                                            value: idEmpresa,
                                                            nombre: nombreEmpresa,
                                                            imagen: imagen,
                                                            numeroDocumentos: numeroDocumentos,
                                                            sumaImportesDocumentos: sumaImportesDocumentos,
                                                            numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                            sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,
                                                          )
                                                        )
                                                      ),
                                  )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          );
  }

  List data = [{}];
  int cantEmpresas = 0;
  bool _isLoading = false;
  bool siEmpresas;
  
  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  String apiToken;
  _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    final url =
        "$urlGlobal/api/empresasTodas?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("BODY ANTES:");
      print(response.body);
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionData.json');
      await fileData.writeAsString("${response.body}");
      _getVariables();


    }
  }

  int orderAZ(var a,var b){
    return a.compareTo(b);
  }

  int order19(String a,String b){
    int numeroA = double.parse(a).round();
    int numeroB = double.parse(b).round();
    if(numeroA < numeroB){
      return -1;
    }
    if(numeroA > numeroB){
      return 1;
    }
    return 0;
  }
  
  Widget _loading(){
      barrierDismissible: true;
      return Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                ),
              );
    
  }

  // Widget loading(){
  //   return 
  // }

  

  @override
  void initState() {
    setState(() {
        // VARIABLES GLOBALES PARA PINTAR DATOS
        data                            = pagGestGestionGlobal;
        cantEmpresas                    = pagGestGestionGlobal.length;
        numeroDocumentos                = numeroDocumentosGlobal;
        sumaImporteDocumentos           = sumaImporteDocumentosGlobal;
        numeroDocumentosVencidos        = numeroDocumentosVencidosGlobal;
        sumaImportesDocumentosVencidos  = sumaImportesDocumentosVencidosGlobal;

        if(cantEmpresas > 0){
          _isLoading = true;
        }
    });
    // TODO: implement initState
    super.initState();
    _getVariables();
    _getData();

    
  }


  _getVariables() async {
    
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionData.json');
      try{
          print(await fileData.readAsString());
          final map = json.decode(await fileData.readAsString());
          print("BODY DESPUES:");
          print(map);
          final users = map["result"];
          final code = map["code"];
          final load = map["load"];
          final numeroDocumentos = map["numeroDocumentos"];
          final sumaImporteDocumentos = map["sumaImportesDocumentos"];
          final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
          final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];
          
          setState(() {
            this.apiToken = apiToken;
            this.numeroDocumentos = numeroDocumentos;
            this.sumaImporteDocumentos = sumaImporteDocumentos;
            this.numeroDocumentosVencidos = numeroDocumentosVencidos;
            this.sumaImportesDocumentosVencidos = sumaImportesDocumentosVencidos;
            _isLoading = load;
            this.data = users;
            this.siEmpresas = code;
            if(siEmpresas){
              cantEmpresas = this.data.length;
            }

            // VARIABLES GLOBALES PARA PINTAR DATOS
            pagGestGestionGlobal = users;
            numeroDocumentosGlobal                = numeroDocumentos;
            sumaImporteDocumentosGlobal           = sumaImporteDocumentos;   
            numeroDocumentosVencidosGlobal        = numeroDocumentosVencidos;       
            sumaImportesDocumentosVencidosGlobal  = sumaImportesDocumentosVencidos;   
          });

      }catch(error){
        print("NO HAY DATOS");
        print(error);
      }

  }



  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: (){},
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text('Gestión'),
          backgroundColor: Color(0xFF070D59),
        ),
        backgroundColor: Color(0xFF070D59),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF070D59),
          ),
          child: Sidebar(
            
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              
              Container(
                color: Color(0xff1f3c88),
                // height: 80.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: new CircleAvatar(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey,
                        backgroundImage: new NetworkImage(imagenAdmin),
                      ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Illapa',
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                                ),
                                Text(
                                  '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImporteDocumentos))}', 
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                                onPressed: (){
                                  Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (BuildContext context ) => GestionFMAdministradorPage(
                                                value         : idusuarioGlobal,
                                                tipoUsuario   : tipousuarioGlobal,
                                                nombreUsuario : nombreGlobal,
                                                imagenUsuario : imagenUsuarioGlobal,
                                                apiToken      : apiToken,
                                              )
                                            )
                                          );
                                },
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if(_buscar)
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Buscar'
                      ),
                      onChanged: (text){
                        setState(() {
                            textoBusqueda = text;
                            print(textoBusqueda);
                        });
                      },
                    ),
                  ),
                ),
              if(!_isLoading)
                _loading(),
              Container(
                color: Color(0xfff7b633),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(top: 5.0),
                      width: 5.0,
                      // height: MediaQuery.of(context).size.height/100,
                      // height: double.,
                      color: Color(0xfff7b633),
                    ),
                    Expanded(
                      child: Container(
                        color: Color(0xff070D59),
                        child: Column(
                          children: <Widget>[
                            for(var cont =0; cont<cantEmpresas; cont++ )
                            if(data[cont]['empresaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['empresaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                              _buildListGestionEmpresas(data[cont]['personaImagen'],
                                                        data[cont]['empresaNombre'], 
                                                        data[cont]['numeroDocumentos'], 
                                                        data[cont]['sumaImportesDocumentos'], 
                                                        data[cont]['numeroDocumentosVencidos'], 
                                                        data[cont]['sumaImportesDocumentosVencidos'], 
                                                        data[cont]['empresaId']),
                          ],
                        ),
                        
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            color: Color(0xff1f3c88),
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buscar
                  ?IconButton(
                    icon: Icon(
                      FontAwesomeIcons.timesCircle, 
                      
                      color: Colors.white,
                      ), 
                    onPressed: () {
                      setState(() {
                        _buscar = false;
                      });
                    },)
                  :IconButton(
                    icon: Icon(
                      Icons.search, 
                      color: Colors.white,
                      ), 
                    onPressed: () {
                      setState(() {
                        _buscar = true;
                      });
                    },),
                if(ordenAZ)
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.sortAlphaUp, 
                      color: Colors.white,
                    ), 
                    onPressed: () {
                      setState(() {
                        ordenAZ = false;
                        ordenZA = true;
                      });
                      data.sort((a, b) {
                        return orderAZ(b['empresaNombre'],a['empresaNombre']);
                      });
                    },
                    tooltip: "Ordenar de la Z a la A",
                  ),
                if(ordenZA)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortAlphaDown, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      ordenZA = false;
                      orden19 = true;
                    });
                    data.sort((a, b) {
                      return orderAZ(a['empresaNombre'],b['empresaNombre']);
                    });
                  },
                  tooltip: "Ordenar de la A a la Z",
                ),
                if(orden19)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortNumericDown, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      orden19 = false;
                      orden91 = true;
                    });
                    data.sort((a, b) {
                      return order19("${a['sumaImportesDocumentosVencidos']}","${b['sumaImportesDocumentosVencidos']}");
                    });
                  },
                  tooltip: "Ordenar de importe vencido de menor a mayor",
                ),
                if(orden91)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortNumericUp, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      orden91 = false;
                      ordenAZ = true;
                    });
                    data.sort((a, b) {
                      return order19("${b['sumaImportesDocumentosVencidos']}","${a['sumaImportesDocumentosVencidos']}");
                    });
                  },
                  tooltip: "Ordenar de importe vencido de mayor a menor",
                )
              ],
            ),
          ),
      )
    );
  }
}

