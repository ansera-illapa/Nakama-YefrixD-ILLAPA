import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/pages/gestiones/gestionCliente.dart';
import 'package:illapa/pages/gestiones/gestionSocios.dart';
import 'package:illapa/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class GestionFMEmpPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final int numeroDocumentos;
  final String sumaImportesDocumentos;
  final int numeroDocumentosVencidos;
  final String sumaImportesDocumentosVencidos;

  GestionFMEmpPage({Key key, 
                              this.value,
                              this.nombre,
                              this.imagen,
                              this.numeroDocumentos,
                              this.sumaImportesDocumentos,
                              this.numeroDocumentosVencidos,
                              this.sumaImportesDocumentosVencidos}) : super(key: key);
  @override
  _GestionFMEmpPageState createState() => _GestionFMEmpPageState();
}

class _GestionFMEmpPageState extends State<GestionFMEmpPage> {


  String textoBusqueda = '' ;
  bool _buscar = false;
  bool sinListaNegra = false;

  var data;
  int cantEmpresas = 0;
  bool _isLoading = false;
  bool siEmpresas;
  
  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';


  String nombreSocio = '';
  String imagenSocio = '';
  String sumaImportesDocumentos = '0.00';

  int cantClientes = 0;
  bool codes;

  _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/filtroMayor/empresas/${widget.value}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final listClientes = map["result"];
      final load = map["load"];
      // print(socioSeleccionado['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.data = listClientes;
        this.codes = code;
        if(codes){
          cantClientes = this.data.length;
        }else{
          cantClientes = 0;
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                ),
              );
    
  }

  var moneyType = new NumberFormat("#,##0.00", "en_US");
  
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    _getData();
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowCircleLeft,
                color: Colors.grey
                
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
        ],
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
                      backgroundImage: new NetworkImage(widget.imagen),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.nombre,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                '${widget.numeroDocumentos} registros por ${moneyType.format(double.parse(widget.sumaImportesDocumentos))}', 
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '${widget.numeroDocumentosVencidos} vencidos por ${moneyType.format(double.parse(widget.sumaImportesDocumentosVencidos))}',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(FontAwesomeIcons.chartLine, color: Colors.white,),
                        //       onPressed: (){
                        //         // _getDataSinListaNegra();

                        //       },
                        //     )
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
                          if(sinListaNegra == false)
                            for(var cont =0; cont < cantClientes; cont++ )
                              if(data[cont]['numeroDocumentosVencidos'] > 0)
                              if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1)
                                _buildListGestionClientesFMAdm(data[cont]['personaImagen'], 
                                                          data[cont]['personaNombre'], 
                                                          data[cont]['numeroDocumentos'], 
                                                          data[cont]['sumaImportesDocumentos'], 
                                                          data[cont]['numeroDocumentosVencidos'], 
                                                          data[cont]['sumaImportesDocumentosVencidos'], 
                                                          data[cont]['clienteId']),
                            if(sinListaNegra == true)
                            for(var cont =0; cont < cantClientes; cont++ )
                                  if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1)
                                    _buildListGestionClientesFMAdm(data[cont]['personaImagen'], 
                                                              data[cont]['personaNombre'], 
                                                              data[cont]['numeroDocumentos'], 
                                                              data[cont]['sumaImportesDocumentos'], 
                                                              data[cont]['numeroDocumentosVencidos'], 
                                                              data[cont]['sumaImportesDocumentosVencidos'], 
                                                              data[cont]['clienteId']),
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
              
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.ellipsisH, 
                  color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      if(sinListaNegra == false){
                        sinListaNegra = true;
                      }else{
                        sinListaNegra = false;
                      }
                     
                    });
                    },
                ),
            ],
          ),
        ),
    );
  }







  
  Widget _buildListGestionClientesFMAdm(String imagen, 
                                    String nombre, 
                                    int numeroDocumentos, 
                                    String sumaImportesDocumentos, 
                                    int numeroDocumentosVencidos, 
                                    String sumaImportesDocumentosVencidos, 
                                    int idCliente){
    return 
      GestureDetector(
        onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context ) => GestionClientePage(
                          value: idCliente,
                          nombreCliente:nombre,
                          imagenCliente: urlImagenes+imagen,
                          sumaImportesVencidos: "$sumaImportesDocumentosVencidos",
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
                                      nombre,
                                      style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0  ),
                                    ),
                                    Text(
                                      '$numeroDocumentos registros por $sumaImportesDocumentos',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
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
                                                            nombreCliente:nombre,
                                                            imagenCliente: urlImagenes+imagen,
                                                            sumaImportesVencidos: "$sumaImportesDocumentosVencidos",
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

 /* _getDataSinListaNegra() async {
    // print(apiToken);
    final url =
        "$urlGlobal/api/empresasTodas/filtroMayorAdmSinListaNegra?api_token="+apiToken;
    print(url);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final socioSeleccionado = map["socio"];
      final socioVencido = map["socioVencido"];
      final listClientes = map["result"];
      final load = map["load"];
      // print(socioSeleccionado['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreSocio = socioSeleccionado['personaNombre'];
        this.imagenSocio = socioSeleccionado['personaImagen'];
        this.numeroDocumentos = socioSeleccionado['numeroDocumentos'];
        this.sumaImportesDocumentos = socioSeleccionado['sumaImportesDocumentos'];

        this.numeroDocumentosVencidos = socioVencido['numeroDocumentosVencidos'];
        this.sumaImportesDocumentosVencidos = socioVencido['sumaImportesDocumentosVencidos'];
        
        this.data = listClientes;
        this.codes = code;
        if(codes){
          cantClientes = this.data.length;
        }else{
          cantClientes = 0;
        }
        
      });
    }
  }*/
}

