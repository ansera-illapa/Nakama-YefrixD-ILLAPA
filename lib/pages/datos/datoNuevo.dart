import 'dart:io';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/datos/datosMapa.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

// IMAGEN
import 'package:image_picker/image_picker.dart';

// GOOGLE MAPS BUSCADOR
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

// COUNTRY PICKER
import 'package:country_code_picker/country_code_picker.dart';


class DatoNuevoPage extends StatefulWidget {
  final int estatus;
  final String nombre;
  final String dnioruc;

  final int clienteId;
  final int sectorId;
  final int socioId;
  final String tipoIdentidad;
  final String identidad;
  
  final List pais;
  final List ciudad;
  final List calle;
  final List codPostal;
  final List latitud ;
  final List longitud;
  final int cantDirecciones;
  
  DatoNuevoPage({
                  Key key, 
                  this.estatus, 
                  this.nombre, 
                  this.dnioruc, 
                  this.clienteId, 
                  this.sectorId, 
                  this.socioId,

                  this.tipoIdentidad,
                  this.identidad,
                  this.pais,
                  this.ciudad,
                  this.calle,
                  this.codPostal,
                  this.latitud,
                  this.longitud,
                  this.cantDirecciones
                  }) : super(key: key);

  @override
  _DatoNuevoPageState createState() => _DatoNuevoPageState();
}

class _DatoNuevoPageState extends State<DatoNuevoPage> {
  int contDireccion = 1;
  int contTelefonos = 1;
  int contCorreos = 1;
  
  
  TextEditingController direccion = TextEditingController();
  
  // var direcciones = new List(1);
  List<String> direccionesList = [null];
  
  List<String> correosList = [null];
  
  



  List pais ;
  List ciudad;
  List calle;
  List codPostal;
  List latitud ;
  List longitud;

  int cantDirecciones = 0;

  String paisSeleccionado = "Perú";
  String codePaisSeleccionado = "PE";
  String codigoPostalPaisSeleccionado = "+51";
  Widget _buildDireccion(){
    return 
      Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.0),
          child: Container(
                  color: Color(0xff5893d4),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: new Container(
                          child: Row(
                            children: <Widget>[
                                
                              new Expanded(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: CountryCodePicker(
                                              onChanged: (value){
                                                print(value.code); 
                                                setState(() {
                                                
                                                codigoPostalPaisSeleccionado = value.dialCode; 
                                                paisSeleccionado = value.name; 
                                                codePaisSeleccionado = value.code; 

                                                pais[cantDirecciones] = value.name;
                                                codPostal[cantDirecciones] = value.dialCode;
                                                
                                                });

                                              },
                                              initialSelection: 'PE',
                                              showCountryOnly: true,
                                              showOnlyCountryWhenClosed: true,
                                              alignLeft: true,
                                              favorite: ['+51', 'PE']),
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: _handlePressButton,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              iconSize: 15.0,
                                              icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                              onPressed: _handlePressButton,
                                            ),

                                            Text('Agregar Dirección', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
                                            
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
                    ],
                  ),
                ),
        )
      );
    }
  

  List<String> telefonosPrefijo = ["+51"];
  List<String> listTelefonoPais = ['Perú'];
  List<String> telefonosTipo = ["1"];
  List<String> telefonosList = [null];
  Widget _buildTelefono(int cont, 
                        String tipo, 
                        var list, 
                        String primerCampo, 
                        String segundoCampo, 
                        String tercerCampo, 
                        var listPrimerCampo,
                        var listSegundoCampo){
  
    return 
      Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.0),
          child: Container(
                  color: Color(0xff5893d4),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: new Container(
                          child: Row(
                            children: <Widget>[
                                Container(
                                    width: 30.0,
                                      child: IconButton(
                                            iconSize: 10.0,
                                            icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                            onPressed: (){
                                              setState(() {
                                                if(contTelefonos > 1){
                                                  telefonosList.removeRange(contTelefonos-1, contTelefonos);
                                                  telefonosPrefijo.removeRange(contTelefonos-1, contTelefonos);
                                                  telefonosTipo.removeRange(contTelefonos-1, contTelefonos);
                                                  listTelefonoPais.removeRange(contTelefonos-1, contTelefonos);
                                                }
                                                  
                                                if(contTelefonos > 1)
                                                  contTelefonos = contTelefonos-1;
                                              });
                                            },
                                          )
                                    ),
                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    for(int x = 0; x< cont ; x++)
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      height: 30.0,
                                                      child: CountryCodePicker(
                                                              onChanged: (value){
                                                                print(value);
                                                                listPrimerCampo[x] = "$value";
                                                                listTelefonoPais[x] = "${value.name}";
                                                              },
                                                              initialSelection: 'PE',
                                                              showCountryOnly: false,
                                                              showOnlyCountryWhenClosed: false,
                                                              alignLeft: true,
                                                              favorite: ['+51', 'PE']),
                                                    )
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 10.0),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30.0,
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        value: telefonosTipo[x],
                                                        items: dropwListTiposTelefonos,
                                                        onChanged:(value){
                                                          print(value);
                                                          setState(() {
                                                            listSegundoCampo[x] = value;
                                                          });
                                                        } 
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              ),
                                              Padding(padding: EdgeInsets.only(top: 5.0),),
                                              Container(
                                                // height: 30.0,
                                                child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLength: 9,
                                                    onChanged: (text){
                                                      list[x] = text;
                                                      // value = value+text;
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      hintText: tercerCampo,
                                                    ),
                                                ),
                                              )
                                            ],
                                          )
                                        )
                                      ),
                                      
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            contTelefonos = contTelefonos+1;
                                          });
                                          if(contTelefonos > 1){
                                            telefonosList.add(null);
                                            telefonosPrefijo.add("+51");
                                            listTelefonoPais.add("Perú");
                                            telefonosTipo.add("1");
                                          }
                                          // telefonosList.add(null);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              iconSize: 15.0,
                                              icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                              onPressed: (){
                                                setState(() {
                                                  contTelefonos = contTelefonos+1;
                                                });
                                                if(contTelefonos >= 1){
                                                  telefonosList.add(null);
                                                  telefonosPrefijo.add("+51");
                                                  listTelefonoPais.add("Perú");
                                                  telefonosTipo.add("1");
                                                }
                                                // telefonosList.add(null);
                                              },
                                            ),
                                            Text(
                                              'Agregar Telefono', 
                                              style: TextStyle( 
                                                color: Colors.white, 
                                                fontFamily: 'illapaBold', 
                                                fontSize: 15.0
                                              ),
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
                    ],
                  ),
                ),
        )
    );
  } 

  Widget _buildListDatosCliente( 
    int cont, 
    var list, 
    String tercerCampo, ){

    return 
      Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.0),
          child: Container(
                  color: Color(0xff5893d4),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        
                        title: new Container(
                          child: Row(
                            children: <Widget>[
                                
                                  Container(
                                      width: 30.0,
                                        child: IconButton(
                                              iconSize: 10.0,
                                              icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                              onPressed: (){
                                                setState(() {
                                                  if(contCorreos > 1)
                                                    correosList.removeRange(contCorreos-1, contCorreos);
                                                  if(contCorreos > 1)
                                                    contCorreos = contCorreos-1;
                                                });
                                              },
                                            )
                                    ),

                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    
                                    for(var x = 0; x< cont ; x++)
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.only(top: 5.0),),
                                              Container(
                                                height: 30.0,
                                                child: TextField(
                                                    onChanged: (text){
                                                      list[x] = text;
                                                      // value = value+text;
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      hintText: tercerCampo,
                                                    ),
                                                ),
                                              )
                                            ],

                                          )
                                        )
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            contCorreos = contCorreos+1;
                                          });
                                          correosList.add(null);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              iconSize: 15.0,
                                              icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                              onPressed: (){
                                                setState(() {
                                                  contCorreos = contCorreos+1;
                                                });
                                                correosList.add(null);
                                              },
                                            ),
                                            Text('Agregar Correo', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
                                            
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
                    ],
                  ),
                ),
        )
    );
                  
  } 

  

  Widget _buildClienteAsociado(String dato){
    var x = '$dato'.replaceAll(new RegExp('null'), '-');
    return 
      Container(
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
                                  "$x",
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                ),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
                  
  }


  var dataSectores;
  int cantSectores = 0;

  var listTiposTelefonos;
  List<DropdownMenuItem<String>> dropwListTiposTelefonos = new List();

  _getSectores() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlDato/sectoresTodos/${widget.socioId}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
          final directory = await getApplicationDocumentsDirectory();
          final fileData = File('${directory.path}/pag-datos-datoNuevo${widget.clienteId}.json');
          await fileData.writeAsString("${response.body}");
          _getVariables();
   
    }
  }

  


  @override
  void initState() {
    // TODO: implement initState
    if(widget.cantDirecciones == null){
      pais = ["$paisSeleccionado"];
      ciudad = [null];
      calle = [null];
      codPostal = ["$codigoPostalPaisSeleccionado"];
      latitud  = [null] ;
      longitud = [null] ;
      cantDirecciones = 0;
    }else{

      pais = widget.pais;
      ciudad = widget.ciudad;
      calle = widget.calle;
      codPostal = widget.codPostal;
      latitud = widget.latitud;
      longitud = widget.longitud;

      cantDirecciones = widget.cantDirecciones;
    }
    super.initState();
    _getSectores();
    // _getVariables();
  }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pag-datos-datoNuevo${widget.clienteId}.json');

      // GET SOCIOS
      try{
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final load = map["load"];
        final listSectores = map["sectores"];
        final tiposTelefonos = map["tiposTelefonos"];

        setState(() {
          this.dataSectores = listSectores;
          cantSectores = this.dataSectores.length;
        });

        listTiposTelefonos = tiposTelefonos;
          for(int cont = 0; cont < tiposTelefonos.length ; cont++){
              dropwListTiposTelefonos.add(new DropdownMenuItem(
                  value: tiposTelefonos[cont]['id'].toString(),
                  child: new Text(" "+tiposTelefonos[cont]['nombre'])
              ));
            }
          
      }catch(error){
        print(error);
      
      }

  }


  Future<File> file;
  cargarImagen(){
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery );  
    });
    
    if(file != null){
      print('No hay imagen');
      // startUpload();
    }else{
      print('Nueva imagen');
    }
    
  }

  startUpload(){
    if(tmpFile == null){
      print('no hay imagen');
    }else{
      print('si');
    }
    setState(() {
      fileName = tmpFile.path.split('/').last;  
    });
  }
  
  upload(String fileName, int id) async{
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url = '$urlSubirImagen/agregarImagenCliente' ;
    print("subir Imagen:");
    print(url);
    
    http.post(url, body: {
      "api_token": apiToken,
      "idCliente":"$id",
      "image":base64Image,
      "nombre": fileName
    });

    print( "BASE:"+base64Image);
  }

  File tmpFile;
  String base64Image;
  String fileName;

  Widget verImagen(){
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot){
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null){
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.transparent,
                              // backgroundImage: new NetworkImage(widget.imagen),
                              child: 
                                    Image.file(
                                      snapshot.data,
                                      fit: BoxFit.fill,
                                    ),
                                  
                            );
          
          
        } else if ( snapshot.error != null){
          return const Text(
            'Error al subir la imagen',
            textAlign: TextAlign.center,
          );
        }else{
          return CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.transparent,
                              backgroundImage: new NetworkImage(urlImagenes+"imagenes_clientes/clientes.png"),
                            );
        }
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Datos'),
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
            
          )
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
                    leading: GestureDetector(
                      onTap: (){
                        cargarImagen();
                      },
                      child: verImagen(),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        ),
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.nombre,
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, ),
                              ),
                              Text(
                                '${widget.dnioruc}',
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
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('Direcciones:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
            ),
                   
            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          
                          
                          
                          for(int cont= 0 ; cont < cantDirecciones; cont++)
                            // _buildClienteAsociado( ""+ pais[cont]+
                            //                           "\n"+ciudad[cont]+ 
                            //                           "("+"${codPostal[cont]}"+")"+ 
                            //                           "\n"+calle[cont]),
                          _buildClienteAsociado(calle[cont]),
                          _buildDireccion()
                        ],
                      ),
                      
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('Telefonos:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
            ),

            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          if(widget.estatus == 0)
                            _buildClienteAsociado("987140650"),
                            _buildTelefono(contTelefonos, 
                                          'Telefonos',  
                                          telefonosList,
                                          'PRFIJO',
                                          'TIPO', 'NUMERO',
                                          telefonosPrefijo, 
                                          telefonosTipo),
                          
                        ],
                      ),
                      
                    ),
                  )
                ],
              )
            ),

            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('Correos:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
            ),


            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          if(widget.estatus == 0)
                            for(var x = 1; x<5; x++)
                              _buildClienteAsociado("gerson.vilca@tecsup.edu.pe"),

                          _buildListDatosCliente(contCorreos,
                                                correosList, 'Correos'),
                          
                        ],
                      ),
                      
                    ),
                  )
                ],
              )
            ),

            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('Sector:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
            ),

            Container(
              color: Color(0xfff7b633),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          _buildSectorSelccionado( 'SECTOR SELECCIONADO', sectorSeleccionado, sectorNombre),
                          
                        ],
                      ),
                      
                    ),
                    
                  ),
                  
                ],
              )
            ),
            Padding(
                padding: EdgeInsets.only(top: 50.0),
              )

            



              
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showReview(context);
          
        },
        tooltip: 'Agregar Cliente',
        
        child: Icon(FontAwesomeIcons.plus),
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

  Widget _sector(String sector, int cont, bool select,  int idSector){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: (){
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
                              ?_sector(dataSectores[cont]['descripcion'], cont, true , dataSectores[cont]['id'] )
                              :_sector(dataSectores[cont]['descripcion'], cont, false, dataSectores[cont]['id'] ),
                              
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }



Future<void> _cargandoDatosCliente() async {
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cargando datos'),
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
        actions: <Widget>[
          // FlatButton(
          //   child: Text('Regret'),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
    },
  );
}

_agregarCliente() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/agregarNuevoCliente";
    print(url);
    print("datos:");

    print("${widget.tipoIdentidad}");
    print(widget.dnioruc);
    print(widget.nombre);
    print(codSectorSeleccionado);
    print(widget.socioId);
    print(cantDirecciones);
    print(telefonosList.length);
    print(correosList.length);

    print("TELEFONOS");
    print(telefonosList.length);
    print(telefonosList);
    print(telefonosPrefijo);
    print(listTelefonoPais);
    print(telefonosTipo);

    print("CORREOS");
    print(correosList.length);
    print(correosList);



    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "tipoIdentidad": "${widget.tipoIdentidad}",
                    "dni": "${widget.dnioruc}",
                    "nombre": "${widget.nombre}",
                    "idSector": "$codSectorSeleccionado",
                    "idSocio":"${widget.socioId}",
                    "contDirecciones":"${cantDirecciones}",
                    "contTelefonos":"${telefonosList.length}",
                    "contCorreos":"${correosList.length}",
                      for(int p = 0; p<cantDirecciones; p++)
                        if(calle[p] != null)
                        "direccion$p": calle[p],
                      for(int p = 0; p<cantDirecciones; p++)
                        if(ciudad[p] != null)
                        "direccionCiudad$p": ciudad[p],
                      for(int p = 0; p<cantDirecciones; p++)
                        if(codPostal[p] != null )
                        "direccionCodigoPostal$p": codPostal[p],
                      for(int p = 0; p<cantDirecciones; p++)
                        if(pais[p] != null)
                        "direccionPais$p": pais[p],
                      for(int p = 0; p<cantDirecciones; p++)
                        if(latitud[p] != null)
                        "direccionLatitud$p": "${latitud[p]}",
                      for(int p = 0; p<cantDirecciones; p++)
                        if(longitud[p] != null)
                        "direccionLongitud$p": "${longitud[p]}",

                        for(int x = 0; x<telefonosList.length; x++)
                        if(telefonosList[x] != null)
                        "telefono$x": telefonosList[x],
                      for(int x = 0; x<telefonosList.length; x++)
                        if(telefonosPrefijo[x] != null)
                        "telefonoPrefijo$x": telefonosPrefijo[x],
                      for(int x = 0; x<telefonosList.length; x++)
                        if(listTelefonoPais[x] != null)
                          "telefonoPais$x": listTelefonoPais[x],
                      for(int x = 0; x<telefonosList.length; x++)
                        if(telefonosTipo[x] != null)
                        "telefonoTipo$x": telefonosTipo[x],

                      for(int y = 0; y < correosList.length; y++)
                        if(correosList[y] != null)
                        "correo$y": correosList[y],
                      
                  });
    print(response.body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["estado"];
      final id = map["idClienteNuevo"];
      
      if(tmpFile != null){
        startUpload();
        upload(fileName, id);
      }

      if(estado){
        Navigator.of(context).pop();
        Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatoClientesPage(
                    value: widget.socioId
                  )
                )
              );
      }else{
        print("false");
      }
          
    }else{
      Navigator.of(context).pop();
    }          

}


Future<bool> showReview(context) {
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
                          child: Text('¿Estás seguro de agregar este nuevo cliente?', 
                                    style: TextStyle(color: Colors.white, 
                                    fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Color(0xfff7b633),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Agregar', style: TextStyle(color: Colors.white)),
                                  onPressed:  
                                    (){ 
                                      //miomio
                                      
                                      if(codSectorSeleccionado != null){
                                        _agregarCliente();
                                        Navigator.of(context).pop();
                                        _cargandoDatosCliente();
                                      }else{
                                        setState(() {
                                         camposCompletos = true; 
                                        });
                                        Navigator.of(context).pop();
                                        showReview(context);
                                      }
                                      
                                    }
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        if(camposCompletos == true)
                        Text('Falta seleccionar un sector', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold',fontSize: 15.0),)
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }

  bool camposCompletos = false;



  // GOOGLE MAPS BUSCADOR
  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: globalApiMaps,
      // onError: onError,
      mode: _mode,
      language: "es",
      components: [Component(Component.country, "$codePaisSeleccionado")],
    );

    buscarLugarGoogle(p,);
  }


  Future<Null> buscarLugarGoogle(Prediction p, ) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      

      var ciudadSeleccionada;
      if(widget.cantDirecciones != null){
              setState(() {
                pais.add("$paisSeleccionado");
                ciudad.add(null);
                calle.add(null);
                codPostal.add("$codigoPostalPaisSeleccionado");
                latitud.add(null);
                longitud.add(null);
                

              });
            }


      if(detail.result.vicinity != null){
        ciudadSeleccionada  =  detail.result.vicinity.split(",");
        print(ciudadSeleccionada.length);
        if(ciudadSeleccionada.length > 1){
          ciudad[cantDirecciones] = "${ciudadSeleccionada[1]}";
        }
        
      }

      setState(() {
        calle[cantDirecciones] = p.description;  
      });
      
      Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context ) => DatosMapaPage(
                  ubicacionLatitud: lat,
                  ubicacionLongitud: lng,
                  nombreUbicacion: p.description,

                  estatus: widget.estatus,
                  nombre: widget.nombre,
                  dnioruc: widget.dnioruc,
                  clienteId: widget.clienteId,
                  sectorId: widget.sectorId,
                  socioId: widget.socioId,
                  tipoIdentidad: widget.tipoIdentidad,
                  identidad: widget.identidad,
                  estado: 1,



                  pais: pais,
                  ciudad: ciudad,
                  calle: calle,
                  codPostal: codPostal,
                  latitud: latitud,
                  longitud: longitud,
                  cantDirecciones: cantDirecciones,
                )
              )
            );
    }
  }
}

// const kGoogleApiKey = "AIzaSyCIP0p6wU1IvM9ioCKjKQIG92dkO6-Dm0M";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: globalApiMaps);
Mode _mode = Mode.overlay;
