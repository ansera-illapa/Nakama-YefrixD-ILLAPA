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

class TramosFreeMostrarPage extends StatefulWidget {
  final int value;
  TramosFreeMostrarPage({Key key, this.value}) : super(key: key);

  @override
  _TramosFreeMostrarPageState createState() => _TramosFreeMostrarPageState();
}

class _TramosFreeMostrarPageState extends State<TramosFreeMostrarPage> {

  Widget _buildListTramos(int cont, int desde, int hasta ){

    return 
      Container(
        color: Color(0xff5893d4),
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                    '$cont. De $desde a $hasta', 
                    style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0, color: Colors.white),
                  ),
                
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.edit,
                        color: Color(0xff1f3c88)
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
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
                                keyboardType: TextInputType.number,
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
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Agregar'),
                                  onPressed: (){
                                    _agregarTramo();
                                      Navigator.of(context).pop();
                                      _isLoading=false;
                                    _getTramos();
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Expanded(
                                child: 
                                RaisedButton(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Cancelar'),
                                  onPressed: (){},
                                )
                              )
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
  int identificador = 0;
  

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
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag/tramos/tramosFree/tramosFreeMostrar${widget.value}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();

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
    _getTramos();
    _getVariables();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pag/tramos/tramosFree/tramosFreeMostrar${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
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

          
          this.identificador = socioSeleccionado['personaNumeroIdentificacion'];
          
          
          this.data = listTramos;
          this.codes = code;
          if(codes){
            cantTramos = this.data.length;
          }else{
            cantTramos = 0;
          }
          
        });
          
      }catch(error){
        print(error);
      
      }
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
                      backgroundImage: new NetworkImage('https://cdn.pixabay.com/photo/2015/10/30/10/40/key-1013662_960_720.jpg'),
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
                            ],
                          ),
                        ),
                        new IconButton(
                              icon: Icon(Icons.ac_unit, color: Colors.white,),
                              onPressed: () => Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => TramosFreeMostrarPage()
                                                  )
                                                ),
                            )
                      ],
                    ),
                  ),
                ],
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
                          // _buidEstListEmpresas('https://cdn.pixabay.com/photo/2016/02/19/10/56/man-1209494_1280.jpg', 'Socio 1', 1, 987140650, 'socio1@hotmail.com', 'usuario'),
                          
                          for(var cont =0; cont<cantTramos; cont++ )
                          _buildListTramos(cont+1, data[cont]['inicio'], data[cont]['fin'],),
                          // _buildListTramos(2, -30, 0,),
                          // _buildListTramos(3, 1, 15, ),
                          // _buildListTramos(4, 16, 30, ),
                          // _buildListTramos(5, 31, 60, ),
                          // _buildListTramos(6, 61, 90, ),
                          // _buildListTramos(7, 91, 9999,),
                          
                          
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          modalAddTramo(context);
        },
        tooltip: 'Agregar un nuevo tramo',
        
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
    
  }
}