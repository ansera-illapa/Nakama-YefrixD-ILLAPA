import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionFiltroMayor.dart';
import 'package:illapa/pages/gestiones/gestionSectorista/gestionSectorClientes.dart';

import 'package:illapa/pages/tramos/tramosMostrar.dart';

import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GestionSectoresPage extends StatefulWidget {
  final int value;

  GestionSectoresPage({Key key, this.value,
                              }) : super(key: key);
  @override
  _GestionSectoresPageState createState() => _GestionSectoresPageState();
}

class _GestionSectoresPageState extends State<GestionSectoresPage> {

  
Widget _buildListSectores(int id, String descripcion ){
    return 
    GestureDetector(
      onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => GestionSectorClientesPage(
                    value: id,
                    nombreSectorista: nombreSectorista,
                    imagenSectorista: imagenSectorista,
                    sumaImporteDocumentos: sumaImporteDocumentos,
                    numeroDocumentos: numeroDocumentos,
                    sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,
                    numeroDocumentosVencidos: numeroDocumentosVencidos,


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
                      
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  descripcion,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                ),
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                onPressed: () => Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GestionSectorClientesPage(
                                                        value: id,
                                                        nombreSectorista: nombreSectorista,
                                                        imagenSectorista: imagenSectorista,
                                                        sumaImporteDocumentos: sumaImporteDocumentos,
                                                        numeroDocumentos: numeroDocumentos,
                                                        sumaImportesDocumentosVencidos: sumaImportesDocumentosVencidos,
                                                        numeroDocumentosVencidos: numeroDocumentosVencidos,
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
        )
    );
  }

  var data;
  String nombreSectorista = '';
  String imagenSectorista = '';
  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';
  
  

  int cantSectores = 0;

  bool codes;
  _getSectorista() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGestionSectoristas/sectores/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final sectoristaSeleccionado = map["sectorista"];
      final numeroDocumentos = map["numeroDocumentos"];
      final sumaImporteDocumentos = map["sumaImporteDocumentos"];
      final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
      final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];
      final sectores = map["result"];
      final load = map["load"];
      // print(empresaSeleccionada['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreSectorista = sectoristaSeleccionado['personaNombre'];
        this.imagenSectorista = sectoristaSeleccionado['personaImagen'];
        this.numeroDocumentos = numeroDocumentos;
        this.sumaImporteDocumentos = sumaImporteDocumentos;
        this.numeroDocumentosVencidos = numeroDocumentosVencidos;
        this.sumaImportesDocumentosVencidos = sumaImportesDocumentosVencidos;
        
        this.data = sectores;
        this.codes = code;
        if(codes){
          cantSectores = this.data.length;
        }else{
          cantSectores = 0;
        }
        
      });
    }
  }


  bool _isLoading = false;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSectorista();
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
      tipoUsuario = int.parse(tipoUsuarioInt);
      idUsuario = int.parse(idUsuarioInt);
      imagenUsuario = imagenUsuarioString;
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");
      print("IMAGEN: $imagenUsuario");

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Gestión'),
        backgroundColor: Color(0xFF070D59),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
          ),
          
        ],
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
              color: Color(0xff1f3c88),
              // height: 90.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: new CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: new NetworkImage(imagenSectorista),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nombreSectorista,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                '$numeroDocumentos registros por $sumaImporteDocumentos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(Icons.ac_unit, color: Colors.white,),
                              onPressed: () => Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => GestionFMSecPage(
                                                      value: widget.value,
                                                      nombre: nombreSectorista,
                                                      imagen: imagenSectorista,
                                                      numeroDocumentos: numeroDocumentos,
                                                      numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                      sumaImportesDocumentos: sumaImporteDocumentos,
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
            if(!_isLoading)
              _loading(),             
            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    width: 5.0,
                    // height: MediaQuery.of(context).size.height,
                    color: Color(0xfff7b633),
                    
                  
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[

                          for(var cont =0; cont<cantSectores; cont++ )
                            _buildListSectores(data[cont]['id'], data[cont]['descripcion'],),
                          
                          
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        // tooltip: '',
        
        child: Icon(FontAwesomeIcons.ellipsisH),
      ),
    );
    
  }
}