import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/gestiones/gestionClientes.dart';
import 'package:illapa/pages/gestiones/gestionEmpresa/gestionFiltroMayor.dart';
import 'package:illapa/widgets.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class GestionSociosPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final int numeroDocumentos;
  final String sumaImportesDocumentos;
  final int numeroDocumentosVencidos;
  final String sumaImportesDocumentosVencidos;

  GestionSociosPage({Key key, this.value, 
                              this.nombre, 
                              this.imagen, 
                              this.numeroDocumentos, 
                              this.sumaImportesDocumentos,
                              this.numeroDocumentosVencidos,
                              this.sumaImportesDocumentosVencidos}) : super(key: key);
  
  @override
  _GestionSociosPageState createState() => _GestionSociosPageState();
}


class _GestionSociosPageState extends State<GestionSociosPage> {

  bool _buscar = false;
  String textoBusqueda = '' ;
  bool ordenAZ = true;
  bool ordenZA = false;
  bool orden19 = false;
  bool orden91 = false;

  var moneyType = new NumberFormat("#,##0.00", "en_US");

  Widget _buildListGestionEmpresas(String imagen, 
                                  String nombre, 
                                  int numeroDocumentos, 
                                  String sumaImportesDocumentos, 
                                  int numeroDocumentosVencidos, 
                                  String sumaImportesDocumentosVencidos, 
                                  int idSocio){
    return 
    GestureDetector(
    onTap: (){Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => GestionClientesPage(
                    value: idSocio,
                    nombre: nombre,
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
                                  nombre,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white ,fontSize: 15.0 ),
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
                                                      builder: (BuildContext context ) => GestionClientesPage(
                                                        value: idSocio,
                                                        nombre: nombre,
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
      )
    );
  }

  var data;
  String nombreEmpresa = '';
  String imagenEmpresa = '';
  int numeroDocumentos = 0;
  String sumaImportesDocumentos = '';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '';
  
  int cantSocios = 0;

  bool _isLoading = false;


  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/sociosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final empresaSeleccionada = map["empresa"];
      final empresaSeleccionadaVencidos= map["empresaVencida"];
      final listSocios = map["result"];
      final load = map["load"];
      
      print(code);
      setState(() {

        _isLoading = load;
        this.nombreEmpresa = empresaSeleccionada['nombre'];
        this.imagenEmpresa = empresaSeleccionada['personaImagen'];
        this.numeroDocumentos = empresaSeleccionada['numeroDocumentos'];
        this.sumaImportesDocumentos = empresaSeleccionada['sumaImportesDocumentos'];
        this.numeroDocumentosVencidos = empresaSeleccionadaVencidos['numeroDocumentosVencidos'];
        this.sumaImportesDocumentosVencidos = empresaSeleccionadaVencidos['sumaImportesDocumentosVencidos'];
        
        this.data = listSocios;
        
        if(code){
          cantSocios = this.data.length;
          
        }else{
          cantSocios = 0;
        }
      });
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
  

  @override
  void initState() {
    if(widget.nombre != null){
      nombreEmpresa = widget.nombre;
      imagenEmpresa = widget.imagen;
      numeroDocumentos = widget.numeroDocumentos;
      sumaImportesDocumentos = widget.sumaImportesDocumentos;
      numeroDocumentosVencidos = widget.numeroDocumentosVencidos;
      sumaImportesDocumentosVencidos = widget.sumaImportesDocumentosVencidos;

    }
    
    // TODO: implement initState
    super.initState();
    _getVariables();
    _getSocios();
    
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
    
    return WillPopScope(
      onWillPop: (){
        
      },
      child: Scaffold(
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
                        backgroundImage: new NetworkImage(imagenEmpresa),
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
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                                ),
                                Text(
                                  '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))}',
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                                ),
                                Text(
                                  '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                  style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                                ),
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.users, color: Colors.white,),
                                onPressed: () => Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GestionFMEmpPage(
                                                        value: widget.value,
                                                        nombre: nombreEmpresa,
                                                        imagen: imagenEmpresa,
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

                            for(var cont =0; cont<cantSocios; cont++ )
                            if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                              _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                        data[cont]['personaNombre'], 
                                                        data[cont]['numeroDocumentos'], 
                                                        data[cont]['sumaImportesDocumentos'], 
                                                        data[cont]['numeroDocumentosVencidos'], 
                                                        data[cont]['sumaImportesDocumentosVencidos'], 
                                                        data[cont]['socioId'] ),
                            
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
                        return orderAZ(b['personaNombre'],a['personaNombre']);
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
                      return orderAZ(a['personaNombre'],b['personaNombre']);
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
      ),
    );
    
  }
}

