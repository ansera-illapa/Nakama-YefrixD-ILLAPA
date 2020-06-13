import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/pages/datos/datosFree/datFreeMaps.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:illapa/pages/datos/datosFree/datFreeClientes.dart';

import 'package:image_picker/image_picker.dart';

// GOOGLE MAPS BUSCADOR
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';

// COUNTRY PICKER
import 'package:country_code_picker/country_code_picker.dart';



class DatFreeClienteEditarPage extends StatefulWidget {
  final String imagen;
  final String nombre;
  final String tipodnioruc;
  final String dnioruc;

  final int clienteId;
  final int socioId; 
  final int userId;
  

  final List pais;
  final List ciudad;
  final List calle;
  final List codPostal;
  final List latitud ;
  final List longitud;

  final int cantDireccionesAgregadas;

  DatFreeClienteEditarPage({
                  Key key, 
                  this.imagen, 
                  this.nombre, 
                  this.tipodnioruc, 
                  this.dnioruc,
                  this.clienteId, 
                  this.socioId,
                  this.userId,


                  this.pais,
                  this.ciudad,
                  this.calle,
                  this.codPostal,
                  this.latitud,
                  this.longitud,
                  this.cantDireccionesAgregadas

                  }) : super(key: key);

  @override
  _DatFreeClienteEditarPageState createState() => _DatFreeClienteEditarPageState();
}

class _DatFreeClienteEditarPageState extends State<DatFreeClienteEditarPage> {
  int contDireccion = 0;
  int contTelefonos = 0;
  int contCorreos = 0;
  
  
  TextEditingController direccion = TextEditingController();
  
  // var direcciones = new List(1);
  List<String> direccionesCiudad = [null];
  List<String> direccionesCodigoPostal = [null];
  List<String> direccionesList = [null];


  List<String> telefonosPrefijo = ["+51"];
  List<String> listTelefonoPais = ["Perú"];
  List<String> telefonosTipo = ["1"];
  List<String> telefonosList = [null];

  List<String> correosList = [null];
  

  Widget _buildListDatosCliente( int cont, String tipo, int y, var list, String primerCampo, String segundoCampo, String tercerCampo, var listPrimerCampo ,var listSegundoCampo){
  
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
                            if(y == 1)
                            Container(
                              width: 30.0,
                              child: IconButton(
                                iconSize: 10.0,
                                icon: Icon(FontAwesomeIcons.minus, color: Colors.white, ),
                                onPressed: (){
                                  print(contDireccion);
                                  setState(() {
                                    if(contDireccion >= 1){
                                      direccionesList.removeRange(contDireccion-1, contDireccion);
                                      direccionesCiudad.removeRange(contDireccion-1, contDireccion);
                                      direccionesCodigoPostal.removeRange(contDireccion-1, contDireccion);
                                      contDireccion = contDireccion-1;
                                    }
                                      // direcciones[contDireccion-1] = null;
                                      
                                    
                                      
                                  });
                                },
                              ),
                            ),
                            if(y == 2)
                              Container(
                                  width: 30.0,
                                    child: IconButton(
                                          iconSize: 10.0,
                                          icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                          onPressed: (){
                                            setState(() {
                                              if(contTelefonos >= 1){
                                                telefonosList.removeRange(contTelefonos-1, contTelefonos);
                                                telefonosPrefijo.removeRange(contTelefonos-1, contTelefonos);
                                                listTelefonoPais.removeRange(contTelefonos-1, contTelefonos);
                                                telefonosTipo.removeRange(contTelefonos-1, contTelefonos);
                                                contTelefonos = contTelefonos-1;
                                              }
                                                
                                                
                                            });
                                          },
                                        )

                                  ),
                              if(y == 3)
                                Container(
                                    width: 30.0,
                                      child: IconButton(
                                            iconSize: 10.0,
                                            icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                            onPressed: (){
                                              setState(() {
                                                if(contCorreos >= 1)
                                                  correosList.removeRange(contCorreos-1, contCorreos);
                                                if(contCorreos >= 1)
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
                                            if(y != 3)
                                            Row(
                                              children: <Widget>[
                                                // Expanded(
                                                //   child: Container(
                                                //     height: 30.0,
                                                //     child: TextField(
                                                //       onChanged: (text){
                                                //         listPrimerCampo[x] = text;
                                                //         // value = value+text;
                                                //       },
                                                //       decoration: InputDecoration(
                                                //         filled: true,
                                                //         hintText: primerCampo,
                                                //       ),
                                                //     ),
                                                //   ) 
                                                // ),
                                                 Expanded(
                                                  child: Container(
                                                    height: 30.0,
                                                    child: CountryCodePicker(
                                                            onChanged: (value){
                                                              print(value);
                                                              print(value.name);
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
                                                // Expanded(
                                                //   child: Container(
                                                //     height: 30.0,
                                                //     child: TextField(
                                                //       onChanged: (text){
                                                //         listSegundoCampo[x] = text;
                                                //         // value = value+text;
                                                //       },
                                                //       decoration: InputDecoration(
                                                //         filled: true,
                                                //         hintText: segundoCampo
                                                //       ),
                                                //     ),
                                                //   )
                                                // ),
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
                                            if(y==2)
                                                Container(
                                                  // height: 30.0,
                                                  child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLength: 11,
                                                      onChanged: (text){
                                                        list[x] = text;
                                                        // value = value+text;
                                                      },
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        hintText: tercerCampo,
                                                      ),
                                                  ),
                                                ),
                                            if(y==3)
                                              Container(
                                                // height: 30.0,
                                                child: TextField(
                                                  // keyboardType: TextInputType.number,
                                                  // maxLength: 11,
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
                                    if(y == 1)
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                                contDireccion = contDireccion+1;
                                              });
                                        if(contDireccion >= 1){
                                          direccionesList.add(null);
                                          direccionesCiudad.add(null);
                                          direccionesCodigoPostal.add(null);
                                        }
                                        
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            iconSize: 15.0,
                                            icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                            onPressed: (){
                                              setState(() {
                                                contDireccion = contDireccion+1;
                                              });
                                              
                                              if(contDireccion >= 1){
                                                direccionesList.add(null);
                                                direccionesCiudad.add(null);
                                                direccionesCodigoPostal.add(null);
                                              }
                                            },
                                          ),
                                          Text('Agregar Dirección', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
                                          
                                        ],
                                      ),
                                    ),
                                    if(y == 2)
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
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            iconSize: 15.0,
                                            icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                            onPressed: (){
                                              print(telefonosPrefijo);
                                              setState(() {
                                                contTelefonos = contTelefonos+1;
                                              });
                                              if(contTelefonos >= 1){
                                                telefonosList.add(null);
                                                telefonosPrefijo.add("+51");
                                                listTelefonoPais.add("Perú");
                                                telefonosTipo.add("1");
                                              }
                                            },
                                          ),
                                          Text('Agregar Telefono', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
                                          
                                        ],
                                      ),
                                    ),

                                    if(y == 3)
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          contCorreos = contCorreos+1;
                                        });
                                        if(contCorreos > 1){
                                          correosList.add(null);
                                        }
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
                                              if(contCorreos > 1){
                                                correosList.add(null);
                                              }
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

  Widget _buildClienteAsociado(String dato, int id, int tipo ){
    
    String x = '$dato'.replaceAll(new RegExp('null'), '-');

    return 
          GestureDetector(
          onTap: 
            (){
              return modalEliminar(context, id, tipo);
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
                  ),
            ),
          );
      
                  
  }

  List pais ;
  List ciudad;
  List calle;
  List codPostal;
  List latitud ;
  List longitud;

  int cantDirecciones = 0;
  int cantDireccionesAgregadas;


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
                                          child: Container(
                                            height: 40.0,
                                            child: CountryCodePicker(
                                              onChanged: (value){
                                                print(value.code); //WIUWIU
                                                setState(() {
                                                
                                                codigoPostalPaisSeleccionado = value.dialCode; 
                                                paisSeleccionado = value.name; 
                                                codePaisSeleccionado = value.code; 

                                                pais[cantDireccionesAgregadas] = value.name;
                                                codPostal[cantDireccionesAgregadas] = value.dialCode;
                                                });
                                              },
                                              initialSelection: 'PE',
                                              showCountryOnly: true,
                                              showOnlyCountryWhenClosed: true,
                                              alignLeft: true,
                                              favorite: ['+51', 'PE']),
                                          ),
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



  var listTelefonos;
  int cantTelefonos = 0;
  
  var listCorreos;
  int cantCorreos = 0;

  var listDirecciones;
  var listTiposTelefonos;

  
  _getDatosCliente() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDatFree/clienteDatos/${widget.clienteId}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag-datos-datosFree-datFreeClienteEditar${widget.clienteId}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();
    }


  }

  
  
  List<DropdownMenuItem<String>> dropwListTiposTelefonos = new List();

  




  @override
  void initState() {
    
    
    // TODO: implement initState
    if(widget.cantDireccionesAgregadas == null){
      pais = ["$paisSeleccionado"];
      ciudad = [null];
      calle = [null];
      codPostal = ["$codigoPostalPaisSeleccionado"];
      latitud  = [null] ;
      longitud = [null] ;
      cantDireccionesAgregadas = 0;
    }else{

      pais = widget.pais;
      ciudad = widget.ciudad;
      calle = widget.calle;
      codPostal = widget.codPostal;
      latitud = widget.latitud;
      longitud = widget.longitud;

      cantDireccionesAgregadas = widget.cantDireccionesAgregadas;
    }

    super.initState();
    _getVariables();
    _getDatosCliente();

  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {


      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pag-datos-datosFree-datFreeClienteEditar${widget.clienteId}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final codeTelefonos = map["codeTelefonos"];
        final telefonos = map["telefonos"];
        final codeDirecciones = map["codeDirecciones"];
        final direcciones = map["direcciones"];
        final codeCorreos = map["codeCorreos"];
        final correos = map["correos"];
        final tiposTelefonos = map["tiposTelefonos"];
        
        setState(() {

          if(codeTelefonos == true){
            this.listTelefonos = telefonos;
            this.cantTelefonos = this.listTelefonos.length;
          }
          if(codeCorreos == true){
            this.listCorreos = correos;
            this.cantCorreos = this.listCorreos.length;
          }
          if(codeDirecciones == true){
            this.listDirecciones = direcciones;
            this.cantDirecciones = this.listDirecciones.length;
          }

          listTiposTelefonos = tiposTelefonos;
          for(int cont = 0; cont < tiposTelefonos.length ; cont++){
              dropwListTiposTelefonos.add(new DropdownMenuItem(
                  value: tiposTelefonos[cont]['id'].toString(),
                  child: new Text(" "+tiposTelefonos[cont]['nombre'])
              ));
            }


        });
          
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
  

    File tmpFile;
    String base64Image;
    String fileName;

  upload(String fileName) async{
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url = '$urlSubirImagen/agregarImagenCliente' ;
    print("subir Imagen:");
    print(url);
    
    final response = await http.post(url, body: {
                      "api_token": apiToken,
                      "idCliente":"${widget.clienteId}",
                      "image":base64Image,
                      "nombre": fileName
                    });
    print("respuesta imagen");
    print(response.body);

    //miomio


  }

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
                              backgroundImage: new NetworkImage(widget.imagen),
                            );
        }
      },
    );
  }


  void _onCountryChange(CountryCode countryCode) {
    //Todo : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
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
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => DatFreeClientesPage(
                      value: widget.socioId //mioio
                    )
                  )
                );
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
      body:  WillPopScope(
        onWillPop: (){
          Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => DatFreeClientesPage(
                      value: widget.socioId //mioio
                    )
                  )
                );
          // exit(0);
        },
        child: Container(
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
                                  '${widget.tipodnioruc} ${widget.dnioruc}',
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
                // child: Text('Direcciones:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
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
                          

                            for(int cont = 0; cont < cantDirecciones; cont++)
                              _buildClienteAsociado(
                                                      // "Ciudad: "+"${listDirecciones[cont]['ciudad']}"+
                                                      // "("+"${listDirecciones[cont]['codigopostal']}"+")"+
                                                      "Calle: "+ "${listDirecciones[cont]['calle']}", listDirecciones[cont]['id'], 1),
                            
                            for(int cont= 0 ; cont < cantDireccionesAgregadas; cont++)
                              _buildClienteAsociado(
                                ""+ pais[cont]+"\n"+ciudad[cont]+ "("+"${codPostal[cont]}"+")"+ "\n"+
                                calle[cont],9,9 ),

                            _buildDireccion()
                            // _buildListDatosCliente(contDireccion, 'Dirección', 1, direccionesList, 'CIUDAD', 'CODIGO POSTAL', 'CALLE', direccionesCiudad ,direccionesCodigoPostal),
                            
                          ],
                        ),
                        
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                // child: Text('Telefonos:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
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
                            
                            for(int cont = 0; cont < cantTelefonos; cont++)
                              _buildClienteAsociado(
                                                      "${listTelefonos[cont]['tipo']}"+
                                                      ": ("+"${listTelefonos[cont]['prefijo']}"+") "+
                                                      "${listTelefonos[cont]['numero']}", listTelefonos[cont]['id'], 2),

                              _buildListDatosCliente(contTelefonos, 'Telefonos', 2, telefonosList, 'PREFIJO', 'TIPO', 'NUMERO', telefonosPrefijo, telefonosTipo),
                            
                          ],
                        ),
                        
                      ),
                    )
                  ],
                )
              ),

              Padding(
                padding: EdgeInsets.all(5.0),
                // child: Text('Correos:', style: TextStyle( color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),),
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
                            for(int cont = 0; cont < cantCorreos; cont++)
                              _buildClienteAsociado("${listCorreos[cont]['correo']}",listCorreos[cont]['id'], 3 ),

                            _buildListDatosCliente(contCorreos, 'Correos', 3, correosList, 'CORREO', 'CORREO', 'CORREO', correosList, correosList),
                            
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
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          modalConfirmacion(context);
          
        } ,
        tooltip: 'Agregar datos',
        
        child: Icon(FontAwesomeIcons.save),
      ),

    

    );
    
  }



//_handlePressButton

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

  _actualizarCliente() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/editarCliente";
    print(url);
    print("datos:");
    print("${widget.dnioruc}");
    print("${widget.nombre}");
    
    
    

    
    print(widget.clienteId);
    print(widget.userId);

    print("$cantDireccionesAgregadas");
    print("${telefonosList.length}");
    print("${correosList.length}"); 
    
    print("CANTIDAD");
    print("DIRECIONES: "+"$cantDireccionesAgregadas");
    print("TELEFONOS: "+"${telefonosList.length}");
    print(telefonosList.contains(null));
    print(telefonosPrefijo.contains(null));
    print(telefonosTipo.contains(null));
    print("CORREOS: ${correosList.length}");
    print(correosList.contains(null));


    // if(direccionesList.length == 1){
    //   if(direccionesList.contains(null) == true ){
    //     direccionesList.length = 0;
    //   }
    // }

    if(telefonosList.length == 1){
      if(telefonosList.contains(null) == true ){
        telefonosList.length = 0;
      }
    }
    if(correosList.length == 1){
      if(correosList.contains(null) == true ){
        correosList.length = 0;
      }
    }
    print(telefonosList.contains(null));

    if(tmpFile != null){
      startUpload();
      upload(fileName);
    }
    
    print("PAISES TELEFONOS:");
    print(listTelefonoPais);

    
    final response = await http.post(url, body: {

                    "api_token": apiToken,
                    "idCliente":"${widget.clienteId}",
                    "userId":"${widget.userId}",
                    // "contDirecciones":"${direccionesList.length}",
                    "contDirecciones": "$cantDireccionesAgregadas",
                    "contTelefonos":"${telefonosList.length}",
                    "contCorreos":"${correosList.length}",

                      // for(var p = 0; p<direccionesList.length; p++)
                      //   "direccion$p": direccionesList[p],
                      // for(var p = 0; p<direccionesList.length; p++)
                      //   "direccionCiudad$p": direccionesCiudad[p],
                      // for(var p = 0; p<direccionesList.length; p++)
                      //   "direccionCodigoPostal$p": direccionesCodigoPostal[p],
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
                        if(calle[p] != null)
                        "direccion$p": calle[p],
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
                        if(ciudad[p] != null)
                        "direccionCiudad$p": ciudad[p],
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
                        if(codPostal[p] != null)
                        "direccionCodigoPostal$p": codPostal[p],
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
                        if(pais[p] != null)
                        "direccionPais$p": pais[p],
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
                        if(latitud[p] != null)
                        "direccionLatitud$p": "${latitud[p]}",
                      for(int p = 0; p<cantDireccionesAgregadas; p++)
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
                        "telefonoTipo$x": "${telefonosTipo[x]}",

                        
                      for(int y = 0; y<correosList.length; y++)
                        if(correosList[y] != null)
                        "correo$y": correosList[y],
                    
                      
                    
                    // "idSocioSeleccionado": "${widget.value}" ,
                  });
    print("RESPUESTA");
    print(response.body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["estado"];
      print("este es: "+"$estado");
      if(estado){
        Navigator.of(context).pop();
        Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatFreeClientesPage(
                    value: widget.socioId //mioio
                  )
                )
              );
      }else{
        print('FAIL');
        Navigator.of(context).pop();
        Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatFreeClientesPage(
                    value: widget.socioId //mioio
                  )
                )
              );
      }
          
    }          

}

  _eliminarDatos(int id, int tipo) async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    String url;
    switch (tipo) {
      case 1: url = "$urlDato/eliminarDireccion"; 
        break;
      case 2: url = "$urlDato/eliminarTelefono";
        break;
      case 3: url = "$urlDato/eliminarCorreos";
        break;
      
      default:
    }

    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "id":"$id",
    });


    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["code"];

      if(estado){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context ) => DatFreeClienteEditarPage(
              imagen: widget.imagen,
              nombre: widget.nombre,
              dnioruc: widget.dnioruc,
              tipodnioruc: widget.tipodnioruc,
              clienteId: widget.clienteId,
              socioId: widget.socioId,
              userId: widget.userId


            )
          )
        );
        
      }else{
        print('error');
      }

    } 


  }


  Future<bool> modalEliminar(context, int id, int tipo) {
    return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 180.0,
                  color: Color(0xFFAA0000),
                  padding: EdgeInsets.all(10.0),
                  
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('¿Estás seguro de eliminar este dato?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                
                                Expanded(
                                  child: RaisedButton(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Eliminar', style: TextStyle(color: Colors.black, fontFamily: 'illapaBold', fontSize: 15.0,)),
                                    onPressed:  
                                      (){ 
                                        _eliminarDatos(id, tipo);
                                        Navigator.of(context).pop();
                                        _cargandoDatosCliente();

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

  Future<bool> modalConfirmacion(context) {
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
                            child: Text('¿Estás seguro de agregar estos nuevos datos?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                
                                Expanded(
                                  child: RaisedButton(
                                    color: Color(0xfff7b633),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Guardar', style: TextStyle(color: Colors.white)),
                                    onPressed:  
                                      (){ 
                                        _actualizarCliente();
                                        Navigator.of(context).pop();
                                        _cargandoDatosCliente();

                                      }
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.all(5.0),
                                // ),
                                // Expanded(
                                //   child: 
                                //     RaisedButton(
                                //       color: Colors.white,
                                //       padding: EdgeInsets.all(10.0),
                                //       child: Text('Cancelar'),
                                //       onPressed: (){},
                                //     )
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









  // GOOGLE MAPS BUSCADOR
  // void onError(PlacesAutocompleteResponse response) {
  //   homeScaffoldKey.currentState.showSnackBar(
  //     SnackBar(content: Text(response.errorMessage)),
  //   );
  // }

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
      final country = detail.result.name;
      print(country);
       
      
      
      
      var ciudadSeleccionada;

      if(widget.cantDireccionesAgregadas != null){
          setState(() {
            pais.add("$paisSeleccionado");
            // ciudad.add("${ciudadSeleccionada[cantDireccionesAgregadas]}");
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
            ciudad[cantDireccionesAgregadas] = "${ciudadSeleccionada[1]}";
          }
          
        }

        setState(() {
          calle[cantDireccionesAgregadas] = p.description;  
        });
        

        Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatFreeMapsPage(
                    ubicacionLatitud: lat,
                    ubicacionLongitud: lng,
                    nombreUbicacion: p.description,
                    imagen: widget.imagen,
                    nombre: widget.nombre,
                    tipodnioruc: widget.tipodnioruc,
                    dnioruc: "${widget.dnioruc}",
                    clienteId: widget.clienteId,
                    socioId: widget.socioId,
                    userId: widget.userId,


                    
                    

                    pais: pais,
                    ciudad: ciudad,
                    calle: calle,
                    codPostal: codPostal,
                    latitud: latitud,
                    longitud: longitud,
                    cantDirecciones: cantDireccionesAgregadas,
                  )
                )
              );
    }
  }


}

// const kGoogleApiKey = "AIzaSyCIP0p6wU1IvM9ioCKjKQIG92dkO6-Dm0M";
// final homeScaffoldKey = GlobalKey<ScaffoldState>();
// final searchScaffoldKey = GlobalKey<ScaffoldState>();

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: globalApiMaps);
Mode _mode = Mode.overlay;






