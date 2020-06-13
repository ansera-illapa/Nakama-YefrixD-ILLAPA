import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/usuarios/usuarioSectores.dart';
import 'package:illapa/pages/usuarios/usuariosUsuarios.dart';
import 'package:illapa/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuarioNuevoPage extends StatefulWidget {
  final int     idSocio;
  final int     idUsuario;
  final String  nombreUsuario;
  final String  tipoIdentificacionUsuario;
  final String  numeroIdentificacionUsuario;
  final String  imagenUsuario;

  UsuarioNuevoPage({
                    Key key, 
                    this.idSocio, 
                    this.idUsuario,
                    this.nombreUsuario,
                    this.tipoIdentificacionUsuario,
                    this.numeroIdentificacionUsuario,
                    this.imagenUsuario

                  }) : super(key: key);

  @override
  _UsuarioNuevoPageState createState() => _UsuarioNuevoPageState();
}

class _UsuarioNuevoPageState extends State<UsuarioNuevoPage> {

 DateTime _dateVencimiento;
 bool selectSectorista = false;



 


  Widget _sector(String sector, int cont, bool select, int disponible, int idSector){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: disponible == 1 ? null : (){
                Navigator.of(context).pop();
                setState(() {
                  sectorSeleccionado = cont;
                  sectorNombre = sector;
                  codSectorSeleccionado = idSector;
                });
                print(codSectorSeleccionado);
              },
              textColor: Colors.white,
              color: Color(x),
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                sector,
              ),
            ),
          );
  }

  int sectorSeleccionado = 99;
  String sectorNombre = '';
  int codSectorSeleccionado;

  void _selectSector() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 300.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR SECTOR', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                            for(var cont =0; cont<cantSectores; cont++ )
                              
                              sectorSeleccionado == cont
                              ?_sector(dataSectores[cont]['descripcion'], cont, true , dataSectores[cont]['estGestor'], dataSectores[cont]['id'] )
                              :_sector(dataSectores[cont]['descripcion'], cont, false, dataSectores[cont]['estGestor'], dataSectores[cont]['id'] ),
                            
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }

  Widget _sectores(String sector, int cont, bool select, int disponible, int idSector){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              
              disabledTextColor: Colors.white,
              onPressed: disponible == 1 ? null : (){
                
                setState(() {
                   if(select == true){
                     sectoresList[cont] = false;
                     sectoresSeleccionados = sectoresSeleccionados-1;
                     List x = sectoresNombre.split("W-Q"+sector);
                     sectoresNombre = x[0]+x[1];
                    
                     String idSectorString = idSector.toString();
                     List y = codSectoresSeleccionado.split("-"+idSectorString);
                     codSectoresSeleccionado = y[0]+y[1];
                     print("deselect: "+codSectoresSeleccionado);

                   }else{
                     sectoresList[cont] = true;
                     sectoresSeleccionados = sectoresSeleccionados+1;
                     sectoresNombre = sectoresNombre+"W-Q"+sector;
                     String idSectorString = idSector.toString();
                     codSectoresSeleccionado = codSectoresSeleccionado+"-"+idSectorString;
                     print("selects: "+codSectoresSeleccionado);


                   }
                  
                });
                Navigator.of(context).pop();
                _selectSectores();
                
              },

              textColor: Colors.white,
              color: Color(x),
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                sector,
              ),
            ),
          );
  }

  int sectoresSeleccionado = 99;
  String sectoresNombre = 'W-Q';
  var sectoresList = new List(99);
  int sectoresSeleccionados = 0;
  String codSectoresSeleccionado="";
  

  void _selectSectores() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 300.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR SECTORES', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                            for(var cont =0; cont<cantSectores; cont++ )
                              
                              sectoresList[cont] == true
                              ?_sectores(dataSectores[cont]['descripcion'], cont, true , dataSectores[cont]['estSectorista'], dataSectores[cont]['id'] )
                              :_sectores(dataSectores[cont]['descripcion'], cont, false, dataSectores[cont]['estSectorista'], dataSectores[cont]['id'] ),
                            
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }

  agregarGestor() async{
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      print(codSectorSeleccionado);
      print(widget.idUsuario);
      bool respuesta;
      var url =
          "$urlUsuario/agregarGestor";

        final response = await http.post(url, body: {

                        "idSector": "$codSectorSeleccionado" ,
                        "idSectorista":  "${widget.idUsuario}",
                        "api_token": apiToken,
                        
                      });

  }


  agregarSectorista() async{
     final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      print(apiToken);
      print("${widget.idSocio}");
      print("$codSectoresSeleccionado");
      print("${widget.idUsuario}");
      bool respuesta;
      var url =
          "$urlUsuario/agregarSectorista";

        final response = await http.post(url, body: {

                        "idSocio": "${widget.idSocio}" ,
                        "idsSectores": "$codSectoresSeleccionado",
                        "idSectorista": "${widget.idUsuario}" ,
                        "api_token": apiToken,
                        
                      });

  }

  bool faltaSector = false;
  Future<bool> modalAddDocumento(context, ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 180.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: 
                          Column(
                            children: <Widget>[
                              Text('¿Estás seguro de agregar este nuevo usuario?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                              if(faltaSector == true)
                                Text('Falta seleccionar un sector', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold',fontSize: 15.0),)
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
                                  child: Text('Agregar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed: selectSectorista 
                                    ? (){
                                          if(sectoresSeleccionados > 0){
                                            agregarSectorista();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                                builder: (BuildContext context ) => UsuariosUsuariosPage(
                                                  value: widget.idSocio
                                                )
                                              )
                                            );
                                          }else{
                                            setState(() {
                                             faltaSector = true; 
                                            });
                                            Navigator.of(context).pop();
                                            modalAddDocumento(context);
                                          }
                                        }
                                    : (){
                                        if(sectorSeleccionado != 99){
                                            agregarGestor();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                                builder: (BuildContext context ) => UsuariosUsuariosPage(
                                                  value: widget.idSocio
                                                )
                                              )
                                            );
                                          }else{
                                            setState(() {
                                             faltaSector = true; 
                                            });
                                            Navigator.of(context).pop();
                                            modalAddDocumento(context);
                                          }
                                          
                                        }
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
 

  Widget _buildUsuariosAsignados(String imagen, String nombre, String dniRuc, String tipoIdentificador ,String correo, String usuario){
  return GestureDetector(
    // onTap: (){
    //   _selectSectores();
    // },
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
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                              ),
                              Text(
                                '$tipoIdentificador: $dniRuc',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$correo',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$usuario',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
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
      ),
    );
                  
}

  Widget _buildSectorSelccionado(String imagen, String titulo, int contSelectsSectores, String nombreSector){
    int selecionados = 0;
    if(contSelectsSectores != 99){
      selecionados = 1;
    }
    
    return GestureDetector(
      onTap: (){
        _selectSector();
      },

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
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                ),
                                for(var x= 1; x<=selecionados; x++)
                                  Text(
                                    nombreSector,
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                
                                
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '$selecionados',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                // IconButton(
                                //   icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                //   // onPressed: () => Navigator.push(
                                //   //                     context, 
                                //   //                     MaterialPageRoute(
                                //   //                       builder: (BuildContext context ) => DatoPagosPage()
                                //   //                     )
                                //   //                   ),
                                // )
                              ],
                            )
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



  Widget _buildSectoresSelccionados(String imagen, String titulo, int contSelectsSectores, String nombreSector){
    
    
    List nombres = nombreSector.split("W-Q");

    return GestureDetector(
      onTap: (){
        _selectSectores();
      },

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
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                ),
                                for(var x= 2; x<=contSelectsSectores+1; x++)
                                  nombres[x] == ""
                                  ?Text('x')
                                  :Text(
                                    nombres[x],
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  )
                                
                                
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '$contSelectsSectores',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                // IconButton(
                                //   icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                //   // onPressed: () => Navigator.push(
                                //   //                     context, 
                                //   //                     MaterialPageRoute(
                                //   //                       builder: (BuildContext context ) => DatoPagosPage()
                                //   //                     )
                                //   //                   ),
                                // )
                              ],
                            )
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



  int contSectores = 1;

  Widget _buildCrearSectores( int cont, String tipo, int y){
  
  return 
    Container(
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
                                for(var x = 0; x< cont ; x++)
                                TextField(
                                  decoration: InputDecoration(
                                    // fillColor: Colors.white,
                                    filled: true,
                                    // hintText: "Illapa@hotmail.com",
                                    labelText: tipo,
                                  ),
                                ),
                                
                              ],
                            ),
                          ),

                          if(y == 1)
                            Container(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                  icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                  onPressed: (){
                                    setState(() {
                                      contSectores = contSectores+1;
                                    });
                                  },
                                ),
                                IconButton(
                                      icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                      onPressed: (){
                                        setState(() {
                                          if(contSectores > 1)
                                          contSectores = contSectores-1;
                                        });
                                      },
                                    )

                                ],
                              ),
                            ),
                         
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      )
  );
                  
}





  
  var dataSectores;
  String nombreSocio = 'cargando ..';
  String nombreEmpresa = 'cargando .. ';
  String imagenSocio = '';
  String imagenEmpresa = '';

  String tipoidentificador = "";
  String tipoidentificadorEmpresa = "";

  String identificador = '';
  String identificadorEmpresa = '';

  String email = '';
  String emailEmpresa = '';

  bool codes;
  int cantSectores = 0;

  _getDatosEmpresaSocioSectores() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlUsuario/datoSocioEmpresaSectores/${widget.idSocio}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/usuarios-usuarioNuevo${widget.idSocio}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();
      
    }
  }


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDatosEmpresaSocioSectores();
    _getVariables();
  }


  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;

  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/usuarios-usuarioNuevo${widget.idSocio}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final socioSeleccionado = map["socio"];
        final empresaSeleccionada = map["empresa"];
        final load = map["load"];
        final listSectores = map["sectores"];


        print(map);
        setState(() {
          //miomio
          this.nombreEmpresa = empresaSeleccionada['empresaNombre'];
          this.imagenEmpresa = empresaSeleccionada['personaImagen'];
          this.identificadorEmpresa = "${empresaSeleccionada['personaNumeroIdentificacion']}";
          this.emailEmpresa = empresaSeleccionada['userEmail'];
          this.tipoidentificadorEmpresa = empresaSeleccionada['personaTipoIdentificacion'];
          this.nombreSocio = socioSeleccionado['personaNombre'];
          this.imagenSocio = socioSeleccionado['personaImagen'];
          this.tipoidentificador = socioSeleccionado['personaTipoIdentificacion'];
          this.identificador = "${socioSeleccionado['personaNumeroIdentificacion']}";
          this.email = socioSeleccionado['userEmail'];
    
          this.dataSectores = listSectores;
          

          this.codes = code;
          if(codes){
            if(dataSectores != null){
              cantSectores = this.dataSectores.length;
              
            }else{
              cantSectores = 0;
              
            }
            
            
          }else{
            cantSectores = 0;
            
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
        // title: new Text("${widget.idSocio} ${widget.idUsuario}"),
        title: Text("Agregar un nuevo usuario"),
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
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: new CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: new NetworkImage(widget.imagenUsuario),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.nombreUsuario}',
                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                widget.tipoIdentificacionUsuario+ ': ${widget.numeroIdentificacionUsuario}',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
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
            
            
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  Expanded(
                    child: Container(
                      color: Color(0xff070D59),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('EMPRESA', 
                              textAlign: TextAlign.right,
                              style: 
                                TextStyle(
                                  color: Color(0xfff7b633),
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0
                                  
                                ),
                            ),
                          ),
                          _buildUsuariosAsignados('$imagenEmpresa', 
                                                    '$nombreEmpresa',"$identificadorEmpresa", tipoidentificadorEmpresa , 
                                                    '$emailEmpresa', 'Empresa'),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('SOCIO', 
                              textAlign: TextAlign.right,
                              style: 
                                TextStyle(
                                  color: Color(0xfff7b633),
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0
                                  
                                ),
                            ),
                          ),
                          _buildUsuariosAsignados('$imagenSocio', 
                                                  '$nombreSocio', "$identificador", tipoidentificador ,'$email', 'Socio'),
                          
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, left: 5.0),
                            child: Row(
                              children: <Widget>[
                                Switch(
                                  value: selectSectorista,
                                  onChanged: (value) {
                                    setState(() {
                                      selectSectorista = value;
                                    });
                                  },
                                  inactiveThumbColor:  Colors.white,
                                  inactiveTrackColor: Color(0xff1f3c88),
                                  activeTrackColor:  Color(0xfff7b633), 
                                  activeColor:  Color(0xff1f3c88),
                                ),
                                selectSectorista
                                ?Text('Sectorista', 
                                  textAlign: TextAlign.right,
                                  style: 
                                    TextStyle(
                                      color: Color(0xfff7b633),
                                      fontFamily: 'illapaBold',
                                      fontSize: 15.0
                                      
                                    ),
                                )
                                :Text('Gestor', 
                                  textAlign: TextAlign.right,
                                  style: 
                                    TextStyle(
                                      color: Color(0xfff7b633),
                                      fontFamily: 'illapaBold',
                                      fontSize: 15.0
                                      
                                    ),
                                )
                              ],
                            )
                          ),

                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('SECTORES', 
                              textAlign: TextAlign.right,
                              style: 
                                TextStyle(
                                  color: Color(0xfff7b633),
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0
                                  
                                ),
                            ),
                          ),

                          selectSectorista == false
                          ?_buildSectorSelccionado('https://cdn.pixabay.com/photo/2016/02/19/10/56/man-1209494_1280.jpg', 
                                                    'SECTOR SELECCIONADO', sectorSeleccionado, sectorNombre)
                          : _buildSectoresSelccionados('https://cdn.pixabay.com/photo/2016/02/19/10/56/man-1209494_1280.jpg', 
                                                        'SECTORES SELECCIONADOS', sectoresSeleccionados, sectoresNombre),

                          Padding(
                            padding: EdgeInsets.only(bottom: 80.0),
                          )
                          
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
      floatingActionButtonLocation: 
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff1f3c88),
            child: 
                  const Icon(
                        FontAwesomeIcons.save,
                        ), 
                  onPressed: () {
                    setState(() {
                      faltaSector = false; 
                    });
                    modalAddDocumento(context);
                  },
                  tooltip: 'Agregar usuario',
          ),
      bottomNavigationBar: BottomAppBar(
          color: Color(0xff1f3c88),
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.bezierCurve, color: Colors.white,), onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => UsuariosSectoresPage(
                      value: widget.idSocio,
                      idUsuarioAnterior                   :widget.idUsuario ,
                      nombreUsuarioAnterior               :widget.nombreUsuario ,
                      tipoIdentificacionUsuarioAnterior   :widget.tipoIdentificacionUsuario ,
                      numeroIdentificacionUsuarioAnterior :widget.numeroIdentificacionUsuario ,
                      imagenUsuarioAnterior               :widget.imagenUsuario ,

                      nombre: nombreSocio,
                      imagen: imagenSocio,
                      tipoIdentificacion: tipoidentificador,
                      identificacion: identificador,
                      correo: email,
                    )
                  )
                );
              },
              tooltip: 'Agregar Sector',
              ),
            ],
          ),
        ),
    );
  }
  
   


}


 


