import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TramosMostrarPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String correo;
  final String imagen;

  TramosMostrarPage({Key key, this.value, this.nombre, this.correo, this.imagen }) : super(key: key);

  @override
  _TramosMostrarPageState createState() => _TramosMostrarPageState();
}

class _TramosMostrarPageState extends State<TramosMostrarPage> {
  bool _buscar = false;
  String textoBusqueda = '' ;
  bool ordenAZ = true;
  bool ordenZA = false;
  bool orden19 = false;
  bool orden91 = false;

  Widget _buildListTramos(int cont, int desde, int hasta, String nombreTramo, int idTramo){

    return 
      Container(
        color: Color(0xff5893d4),
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Row(
                children: <Widget>[
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          '$nombreTramo', 
                          style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                        ),
                      Text(
                        ' De $desde a $hasta', 
                        style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                      ),
                      
                    ],
                  )
                ],
              )
                
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(FontAwesomeIcons.trashAlt, color: Colors.redAccent,),
                        onPressed: (){
                          modalEliminarTramo(context, idTramo );
                        },
                      )
                  ],
                )
              ),
            ),
            
          ],
        ),
      );
    }

  eliminarTramoEspecifico(int idTramo) async{ //miomio
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      print(idTramo);
      var url =
          "$urlTramo/eliminarTramo";

        final response = await http.post(url, body: {

                        "idTramo": "$idTramo" ,
                        "api_token": apiToken,
                        
                      });
        _getTramos();

  }



  Future<bool> modalEliminarTramo(context, int idTramo) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 170.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de eliminar este tramo?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Eliminar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                                  onPressed: (){
                                    eliminarTramoEspecifico(idTramo);
                                    setState(() {
                                      _isLoading=false; 
                                    });
                                    
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(5.0),
                              // ),
                              // Expanded(
                              //   child: 
                              //   RaisedButton(
                              //     color: Colors.white,
                              //     padding: EdgeInsets.all(10.0),
                              //     child: Text('Cancelar'),
                              //     onPressed: (){
                              //       Navigator.of(context).pop();
                              //     },
                              //   )
                              // )
                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }


  Future<bool> modalAddTramo(context) {
    TextEditingController nombreTexto = TextEditingController();
    TextEditingController desteTexto = TextEditingController();
    TextEditingController hastaTexto = TextEditingController();
    _agregarTramo() async{
       
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();

      bool respuesta;
      var url =
          "$urlTramo/agregarTramo";

      var response = await http.post(url, body: {

                      "socioId": '${widget.value}',
                      "nombre": nombreTexto.text,
                      "desde": desteTexto.text,
                      "hasta": hastaTexto.text,
                      "api_token": apiToken,
                      
                    });
      _getTramos();

        

      print('${widget.value}');
      print(desteTexto.text);
      print(hastaTexto.text);
      print(apiToken);
    }

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 300.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('Agregar un nuevo tramo', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: nombreTexto,
                                // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  // hintText: "33 ",
                                  labelText: "Nombre del tramo",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textDirection: TextDirection.ltr,
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: desteTexto,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        // hintText: "33 ",
                                        labelText: "Desde",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: hastaTexto,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        // hintText: "33 ",
                                        labelText: "Hasta",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Agregar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                                  onPressed: (){
                                    _agregarTramo();
                                      Navigator.of(context).pop();
                                      _isLoading=false;
                                    
                                  },
                                ),
                              ),
                             



                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
    }
    
  
  var data;
  String nombreSocio = '';
  String emailSocio = '';
  String tipoidentificador = "";
  String identificador = '';
  

  int cantTramos = 0;

  bool codes;
  _getTramos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlTramo/tramosSocio/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final socioSeleccionado = map["socio"];
      final listTramos = map["result"];
      final load = map["load"];
      // print(socioSeleccionado['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreSocio = socioSeleccionado['personaNombre'];
        this.emailSocio = socioSeleccionado['userEmail'];

        if(socioSeleccionado['personaTipoIdentificacion'] == 1){
          this.tipoidentificador = "DNI";
        }else{
          this.tipoidentificador = "RUC";
        }

        
        this.identificador = "${socioSeleccionado['personaNumeroIdentificacion']}";
        
        
        this.data = listTramos;
        this.codes = code;
        if(codes){
          cantTramos = this.data.length;
        }else{
          cantTramos = 0;
        }
        
      });
    }
  }

  int orderAZ(var a,var b){
    return a.compareTo(b);
  }

  int order19(var a,var b){
    if(a<b){
      return -1;
    }
    if(a>b){
      return 1;
    }
    return 0;
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
    if(widget.nombre != null){
      setState(() {
       nombreSocio = widget.nombre;
       imagenUsuario = widget.imagen;
       emailSocio = widget.correo;
      });

    }
    super.initState();
    _getTramos();
    _getVariables();
  }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario = '';
  String nombreUsuario = '';

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
        title: new Text('Tramos'),
        backgroundColor: Color(0xFF070D59),
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
                      backgroundImage: new NetworkImage(imagenUsuario),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nombreSocio,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                             
                              Text(
                                emailSocio,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                "Socio",
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(Icons.ac_unit, color: Colors.white,),
                        //       onPressed: () => Navigator.push(
                        //                           context, 
                        //                           MaterialPageRoute(
                        //                             builder: (BuildContext context ) => TramosMostrarPage()
                        //                           )
                        //                         ),
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
            !_isLoading
            ?  _loading()
            :Container(
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
                          
                          for(var cont =0; cont<cantTramos; cont++ )
                          if(data[cont]['nombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['nombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                          _buildListTramos(cont+1, data[cont]['inicio'], data[cont]['fin'], data[cont]['nombre'], data[cont]['id']),
                        ],
                      ),
                      
                    ),
                  ),
                  
                ],
              )
            ),
            
          ],
        ),
      ),
      floatingActionButtonLocation: 
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff1f3c88),
            child: 
                  const Icon(
                        FontAwesomeIcons.plus,
                        ), 
                  onPressed: () {
                    modalAddTramo(context);
                  },
                  tooltip: 'Agregar un nuevo tramo',
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
                      return orderAZ(b['nombre'],a['nombre']);
                    });
                  },
                  tooltip: "Ordenar de la A a la Z",
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
                    return orderAZ(a['nombre'],b['nombre']);
                  });
                },
                tooltip: "Ordenar de la Z a la A",
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
                    return order19(b['inicio'],a['inicio']);
                  });
                },
                tooltip: "Ordenar de inico menor a mayor",
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
                    return order19(a['inicio'],b['inicio']);
                  });
                },
                tooltip: "Ordenar de inico mayor a menor",
              )


            ],
          ),
        ),
    );
    
  }
}