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

class UsuarioEditarUsuarioPage extends StatefulWidget {
  final int     idSocio;
  final String  nombreCargoUsuario;
  final bool    cargoUsuario;
  final int     idUsuario;
  final String  nombreUsuario;
  final String  tipoIdentificacionUsuario;
  final String  numeroIdentificacionUsuario;
  final String  imagenUsuario;
  final String  url;
  final List    sectores;

  UsuarioEditarUsuarioPage({
                    Key key, 
                    this.idSocio, 
                    this.idUsuario,
                    this.nombreUsuario,
                    this.nombreCargoUsuario,
                    this.cargoUsuario,
                    this.tipoIdentificacionUsuario,
                    this.numeroIdentificacionUsuario,
                    this.imagenUsuario,
                    this.url,
                    this.sectores,
                  }) : super(key: key);

  @override
  _UsuarioEditarUsuarioPageState createState() => _UsuarioEditarUsuarioPageState();
}

class _UsuarioEditarUsuarioPageState extends State<UsuarioEditarUsuarioPage> {

 DateTime _dateVencimiento;
 bool selectSectorista;
 bool unavez = true;

  Widget _sector(String sector, int cont, bool select, int disponible, int idSector, int idGestorSector ){
    var x = 0xff5893d4;


    if(select == true){
      x = 0xff1f3c88;
    }
    bool esSector = false;

    if(unavez = true){
      if(idGestorSector != null){
         sectorSeleccionado = cont;
         unavez = false; 
          esSector = true;
      }
    }

    

    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: disponible == 1 && esSector == false? null : (){
                Navigator.of(context).pop();
                setState(() {
                  sectorSeleccionado = cont;
                  sectorNombre = sector;
                  codSectorSeleccionado = idSector;
                  unavez = false; 
                });
                print(sectorSeleccionado);
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
            // height: 300.0,
            color: Color(0xFF070D59),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR SECTOR', 
                      style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    for(var cont =0; cont<cantSectores; cont++ )
                      sectorSeleccionado == cont
                      ?_sector(dataSectores[cont]['descripcion'], 
                                cont, 
                                true , 
                                dataSectores[cont]['estGestor'], 
                                dataSectores[cont]['id'],
                                dataSectores[cont]['idGestor'] )
                      :_sector(dataSectores[cont]['descripcion'], 
                                cont, 
                                false, 
                                dataSectores[cont]['estGestor'], 
                                dataSectores[cont]['id'] ,
                                dataSectores[cont]['idGestor']),
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

  Future<bool> modalEditUsuario(context, ) {
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
                          child: Text('¿Estás seguro de editar este usuario?', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Editar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed: selectSectorista 
                                    ? (){
                                          // editarSectorista();
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (BuildContext context ) => UsuariosUsuariosPage(
                                                value: widget.idSocio
                                              )
                                            )
                                          );
                                        }

                                    : (){
                                          // editarGestor();
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (BuildContext context ) => UsuariosUsuariosPage(
                                                value: widget.idSocio
                                              )
                                            )
                                          );
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

  Widget _buildSectorSelccionado(String titulo, int contSelectsSectores, String nombreSector){
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



  Widget _buildSectoresSelccionados(String titulo, int contSelectsSectores, String nombreSector){
    
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
        "$urlUsuario/datoSocioEmpresaSectores/${widget.url}/${widget.idSocio}/${widget.idUsuario}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {

      final map = json.decode(response.body);
      final code = map["code"];
      final socioSeleccionado = map["socio"];
      final empresaSeleccionada = map["empresa"];
      final load = map["load"];
      final listSectores = map["sectores"];
      final sectorGestor = map["sectorGestor"];



      print(map);
      setState(() {
        
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
        //miomio

        if(widget.cargoUsuario == false){
          for(var cont =0; cont<cantSectores; cont++ ){
            if(dataSectores[cont]['id'] ==dataSectores[cont]['idGestor'] ){
              setState(() {
               sectorSeleccionado = cont; 
              });
           }
          }
           

          setState(() {
           sectorNombre = sectorGestor['descripcion'];
           codSectorSeleccionado = sectorGestor['id']; 
           print(sectorNombre);
           print(codSectorSeleccionado);
          });
        }

        
      });
    }
  }


  
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
     selectSectorista = widget.cargoUsuario;
    });
    
    super.initState();
    _getDatosEmpresaSocioSectores();
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
        // title: new Text("${widget.idSocio} ${widget.idUsuario}"),
        title: Text("Editar usuario"),
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
                              Text(
                                widget.nombreCargoUsuario,
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
                          ?_buildSectorSelccionado('SECTOR SELECCIONADO', sectorSeleccionado, sectorNombre)
                          : _buildSectoresSelccionados('SECTORES SELECCIONADOS', sectoresSeleccionados, sectoresNombre),

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
                    modalEditUsuario(context);
                  },
                  tooltip: 'Editar usuario',
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
              IconButton(icon: Icon(FontAwesomeIcons.userMinus, color: Colors.white,), onPressed: () {
                modalDegradarUsuario(context);
              }, tooltip: "Degradar Usuario",
              ),
            ],
          ),
        ),
    );
  }
  
  Future<bool> modalDegradarUsuario(context) {
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
                          child: Text('¿Estás seguro de degradar este usuario?', 
                            style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), 
                            textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Degradar', 
                                  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                  onPressed:  
                                     (){
                                          Navigator.of(context).pop();
                                          _cargando("Degradando Usuario");
                                          _degradarUsuario();
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

  _editarUsuario() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlUsuario/editar/${widget.url}/${widget.idSocio}/${widget.idUsuario}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context ) => UsuariosUsuariosPage(
              value : widget.idSocio,
              nombre : '$nombreSocio',
              imagen : '$imagenSocio',
              tipoDocumentoIdentidad : tipoidentificador,
              numeroDocumentoIdentidad : "$identificador",
              userEmail : '$email',
            )
          )
        );
    }
  }

  _degradarUsuario() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlUsuario/degradar/${widget.url}/${widget.idSocio}/${widget.idUsuario}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context ) => UsuariosUsuariosPage(
              value : widget.idSocio,
              nombre : '$nombreSocio',
              imagen : '$imagenSocio',
              tipoDocumentoIdentidad : tipoidentificador,
              numeroDocumentoIdentidad : "$identificador",
              userEmail : '$email',
            )
          )
        );
    }
  }

  Future<void> _cargando(String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                          ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
   


}


 


