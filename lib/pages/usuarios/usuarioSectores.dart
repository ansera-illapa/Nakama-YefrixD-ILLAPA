import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/usuarios/usuarioAgregarSector.dart';
import 'package:illapa/pages/usuarios/usuarioNuevo.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuariosSectoresPage extends StatefulWidget {
  
  final int     idUsuarioAnterior;
  final String  nombreUsuarioAnterior;
  final String  tipoIdentificacionUsuarioAnterior;
  final String  numeroIdentificacionUsuarioAnterior;
  final String  imagenUsuarioAnterior;
  
  final int value;
  final String nombre ;
  final String tipoIdentificacion;
  final String identificacion;
  final String correo;
  final String imagen;
  
  
  
  UsuariosSectoresPage({Key key,
                                this.idUsuarioAnterior,
                                this.nombreUsuarioAnterior,
                                this.tipoIdentificacionUsuarioAnterior,
                                this.numeroIdentificacionUsuarioAnterior,
                                this.imagenUsuarioAnterior,

                                this.value,
                                this.nombre, 
                                this.tipoIdentificacion,
                                this.identificacion, 
                                this.correo, 
                                this.imagen
                          }) : super(key: key);

  @override
  _UsuariosSectoresPageState createState() => _UsuariosSectoresPageState();
}

class _UsuariosSectoresPageState extends State<UsuariosSectoresPage> {

  
Widget _buidEstListEmpresas( String titulo, int idSector){
  
    return 
    GestureDetector(
      // onTap: (){Navigator.push(
      //           context, 
      //           MaterialPageRoute(
      //             builder: (BuildContext context ) => DatoClientesPage()
      //           )
      //         );},
      
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
                                  titulo,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                ),
                                
                              ],
                            ),
                          ),
                          new IconButton(
                                icon: Icon(FontAwesomeIcons.timesCircle, color: Colors.white,),
                                onPressed: (){
                                  print(idSector);
                                  modalEliminarSector(context, idSector);
                                },
                                
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



  
  int cantSectores = 0;
  var dataSectores;
  
  int cantSectoresSocio = 0;
  var dataSectoresSocio;


  _getSector() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    
    final url =
        "$urlUsuario/socio/sectores/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/usuarios/usuarioSectores${widget.value}.json');
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
    _getSector();
    _getVariables();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/usuarios/usuarioSectores${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final sectoresSocio = map["sectores"];
        final load = map["load"];

        setState(() {
          
          _isLoading = load;
          if(code == true){

            this.dataSectores = sectoresSocio;
            this.cantSectores = this.dataSectores.length;

            this.dataSectoresSocio = sectoresSocio;
            this.cantSectoresSocio = this.dataSectoresSocio.length;
            
          }else{
            this.cantSectoresSocio = 0;
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
        title: new Text('Usuarios'),
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
                widget.nombreUsuarioAnterior != null
                ?Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context ) => UsuarioNuevoPage(
                        idSocio:                      widget.value,
                        idUsuario:                    widget.idUsuarioAnterior,
                        nombreUsuario:                widget.nombreUsuarioAnterior,
                        tipoIdentificacionUsuario:    widget.tipoIdentificacionUsuarioAnterior,
                        numeroIdentificacionUsuario:  "${widget.numeroIdentificacionUsuarioAnterior}",
                        imagenUsuario:                widget.imagenUsuarioAnterior,
                      )
                    )
                  )
                :Navigator.of(context).pop();
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
                                widget.tipoIdentificacion +" "+ widget.identificacion,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.correo,
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'SOCIO',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
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
                          
                          for(var cont =0; cont < cantSectores; cont++ )
                            _buidEstListEmpresas(dataSectores[cont]['sectoresDescripcion'], dataSectores[cont]['id']),
                          
                          
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
      floatingActionButton: 
        FloatingActionButton(
          onPressed: (){
            addSector(context);
          },
          tooltip: 'Agregar sector',
          child: Icon(FontAwesomeIcons.plus),
        )
    );
    
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController descripcionSector = TextEditingController();
Future<bool> addSector(context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                color: Color(0xFF070D59),
                height: 250.0,
                width: 200.0,
                padding: EdgeInsets.all(10.0),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Agregar un sector',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 15.0,
                                color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            TextField(
                              maxLines: 3,
                              controller: descripcionSector,
                              keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "",
                                  labelText: "Descripción",
                                ),
                              ),
                            
                            
                          ],
                        )
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Color(0xFF1f3c88),
                            child: Center(
                              child: Text(
                                'Agregar',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.white,)
                              ),
                            ),
                            onPressed: () {
                              agregarSector();
                              Navigator.of(context).pop();
                            },
                            
                          ),
                        ),
                        
                      ],
                    )
                  ],
                )));
      });
  }
  
  agregarSector() async{
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      setState(() {
        _isLoading= false; 
      });
      bool respuesta;
      var url =
          "$urlUsuario/agregarSector";

        final response = await http.post(url, body: {

                        "idSocio": "${widget.value}" ,
                        "descripcion": descripcionSector.text ,
                        "api_token": apiToken,
                        
                      });
        if (response.statusCode == 200) {
          print(response.body);
          _getSector();
        }

  }

  Future<bool> modalEliminarSector(context, int idSector) {
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
                          child: Text('¿Estás seguro de eliminar este sector?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
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
                                    eliminarSectorEspecifico(idSector);
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
  
  eliminarSectorEspecifico(int idSector) async{ //miomio
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      
      print(idSector);
      var url =
          "$urlUsuario/socio/eliminarSector";

        final response = await http.post(url, body: {

                        "idSector": "$idSector" ,
                        "idSocio": "${widget.value}" ,
                        "api_token": apiToken,
                        
                      });
        if (response.statusCode == 200) {
          print(response.body);
          final map = json.decode(response.body);
          final code = map["code"];
          if(code == false){
            print('no se pudo');
            modalAlertaError();
          }

          _getSector();


        }
  }

  Future<bool> modalAlertaError() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 200.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('Este sector no se pudo eliminar, debido a que ya esta asignado a un usuario (sectorista, gestor o cliente)', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Aceptar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                                  onPressed: (){
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
  
}