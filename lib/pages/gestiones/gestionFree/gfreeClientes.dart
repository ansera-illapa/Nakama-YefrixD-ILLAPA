import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/gestiones/gestionCliente.dart';
import 'package:illapa/pages/gestiones/gestionFree/gfreeFiltroMayor.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GfreeClientesPage extends StatefulWidget {
  final int value;
  GfreeClientesPage({Key key, this.value}) : super(key: key);

  @override
  _GfreeClientesPageState createState() => _GfreeClientesPageState();
}

class _GfreeClientesPageState extends State<GfreeClientesPage> {

  bool _buscar = false;
  bool _sectorSelect = false;
  bool _gestorSelect = false;

  
  Widget _buildListClientes(String imagen, 
                              String nombreCliente, 
                              int regCant, 
                              String regPor, 
                              int vencCant, 
                              String vencPor, 
                              int idCliente){
    
      return 
      GestureDetector(
        onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context ) => GestionClientePage(
                          value: idCliente,
                          imagenCliente: urlImagenes+imagen,
                          nombreCliente: nombreCliente,
                          numeroDocumentosVencidos: vencCant,
                          sumaImportesVencidos: "$vencPor",
                        )
                      )
                    );
                  },
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
                            backgroundImage: new NetworkImage(urlImagenes+imagen),
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      nombreCliente,
                                      style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0  ),
                                    ),
                                    Text(
                                      '$regCant registros por $regPor',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      '$vencCant vencidos por $vencPor',
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
                                                          builder: (BuildContext context ) => GestionClientePage(
                                                            value: idCliente,
                                                            imagenCliente: urlImagenes+imagen,
                                                            nombreCliente: nombreCliente,
                                                            numeroDocumentosVencidos: vencCant,
                                                            sumaImportesVencidos: "$vencPor",
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
  String nombreGestor = '';
  String imagenGestorFree = '';
  int cantClientes = 0;
  bool codes;
  bool _isLoading = false;
  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGestionFree/clientesTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final listClientes = map["result"];
      final sectoristaFreeSeleccionado = map["sectorista"];
      final numeroDocumentos = map["numeroDocumentos"];
      final sumaImporteDocumentos = map["sumaImporteDocumentos"];
      final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
      final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];
      
      
      final load = map["load"];
      
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreGestor = sectoristaFreeSeleccionado['personaNombre'];
        this.imagenGestorFree = sectoristaFreeSeleccionado['personaImagen'];
        this.data = listClientes;

        this.numeroDocumentos = numeroDocumentos;
        this.sumaImporteDocumentos = sumaImporteDocumentos;
        this.numeroDocumentosVencidos = numeroDocumentosVencidos;
        this.sumaImportesDocumentosVencidos = sumaImportesDocumentosVencidos;

        this.codes = code;
        if(codes){
          cantClientes = this.data.length;
        }else{
          cantClientes = 0;
        }
        
      });
    }
  }




  bool importarCLientes = false;
  bool todosClientes = false;
  int todosCantClientes = 0;
  // MUESTRA TODOS LOS CLIENTES SIN EXCEPCION DE QUE ESTEN EN LA LISTA NEGRA, TENGAN DOCUMENTOS U OTROS
  var dataClientesTodos;
  _getTodosClientes() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGestionFree/clientesTodosExcepcion/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final listClientes = map["result"];
      final sectoristaFreeSeleccionado = map["sectorista"];
      final numeroDocumentos = map["numeroDocumentos"];
      final sumaImporteDocumentos = map["sumaImporteDocumentos"];
      final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
      final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];
      
      
      final load = map["load"];
      
      print(code);
      setState(() {
        _isLoading = load;
        
        this.dataClientesTodos = listClientes;
        this.codes = code;
        if(codes){
          todosCantClientes = this.dataClientesTodos.length;
        }else{
          todosCantClientes = 0;
        }
        
      });
    }

    
  }

  Widget _loading(){
      barrierDismissible: true;
      return Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                ),
              );
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSocios();
    _getVariables();
    


  }
  var textoBusqueda = '' ;
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

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            tipousuario: tipoUsuario,
            idusuario: idUsuario,
            imagenUsuario: imagenUsuario,
            nombre : nombreUsuario

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
                        backgroundImage: new NetworkImage(imagenGestorFree),
                      ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  nombreGestor,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                                ),
                                Text(
                                  '$numeroDocumentos registros por $sumaImporteDocumentos',
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                                ),
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(Icons.cloud, color: Colors.white,),
                                onPressed: () => Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GfreeFiltroMayorPage(
                                                        value: widget.value,
                                                        imagenGestor:imagenGestorFree,
                                                        nombreGestor: nombreGestor,
                                                        numeroDocumentos: numeroDocumentos,
                                                        sumaImportesDocumentos: "$sumaImporteDocumentos",
                                                        numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                        sumaImportesDocumentosVencidos: "$sumaImportesDocumentosVencidos"

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
                      onChanged: (text) {
                        print(text);
                        setState(() {
                            textoBusqueda = text;
                            print(textoBusqueda);
                        });
                      },
                      // onChanged: (String filtro){
                      //   print(filtro);
                      // },
                    ),
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
                      
                      color: Color(0xfff7b633),
                      
                    
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.black,
                        color: Color(0xff070D59),
                        child: Column(
                          children: <Widget>[
                            if(todosClientes == false)
                              for(var cont =0; cont<cantClientes; cont++ )
                                if(data[cont]['numeroDocumentosVencidos'] > 0)
                                  if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                                    _buildListClientes(data[cont]['personaImagen'], 
                                                        data[cont]['personaNombre'], 
                                                        data[cont]['numeroDocumentos'], 
                                                        data[cont]['sumaImportesDocumentos'], 
                                                        data[cont]['numeroDocumentosVencidos'], 
                                                        data[cont]['sumaImportesDocumentosVencidos'], 
                                                        data[cont]['clienteId']),  
                                  if(todosClientes == true)
                                    for(var cont =0; cont<todosCantClientes; cont++ )
                                        if(dataClientesTodos[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || dataClientesTodos[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                                          _buildListClientes(dataClientesTodos[cont]['personaImagen'], 
                                                              dataClientesTodos[cont]['personaNombre'], 
                                                              dataClientesTodos[cont]['numeroDocumentos'], 
                                                              dataClientesTodos[cont]['sumaImportesDocumentos'], 
                                                              dataClientesTodos[cont]['numeroDocumentosVencidos'], 
                                                              dataClientesTodos[cont]['sumaImportesDocumentosVencidos'], 
                                                              dataClientesTodos[cont]['clienteId']),  
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
          
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _buscar
        //   ? (){
        //       setState(() {
        //               _buscar = false;
        //             });
        //     }
        //   : (){
        //       setState(() {
        //               _buscar = true;
        //             });
        //     },

        //   tooltip: '',

        //   child: 
        //     _buscar
        //       ?Icon(FontAwesomeIcons.timesCircle)
        //       :Icon(FontAwesomeIcons.search)
        // ),


        
        bottomNavigationBar: BottomAppBar(
            color: Color(0xff1f3c88),
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buscar
                ?IconButton(icon: Icon(FontAwesomeIcons.timesCircle, color: Colors.white,), onPressed: () {
                    
                    setState(() {
                      _buscar = false;  
                    });
                    
                  },)
                :IconButton(icon: Icon(FontAwesomeIcons.search, color: Colors.white,), onPressed: () {
                    setState(() {
                      _buscar = true; 
                    });
                  },),

                IconButton(icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white,), onPressed: () {
                  setState(() {
                    if(importarCLientes == false){
                      _getTodosClientes();
                      _isLoading = false;
                      importarCLientes = true;
                    }
                    if(todosClientes == false){
                      
                      todosClientes = true; 
                    }else{
                      todosClientes = false; 
                    }
                  
                  });
                },),
              ],
            ),
          ),
        
          
          
      )
    );
    
  }
  
}


