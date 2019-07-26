import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/datos/datoDocumento.dart';
import 'package:illapa/pages/datos/datoNuevo.dart';
import 'package:illapa/pages/datos/datosFree/datFreeClienteEditar.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:illapa/pages/datos/datosFree/datFreeNuevo.dart';


import 'package:shared_preferences/shared_preferences.dart';

class DatFreeClientesPage extends StatefulWidget {
  final int value;
  DatFreeClientesPage({Key key, this.value}) : super(key: key);
  @override
  _DatFreeClientesPageState createState() => _DatFreeClientesPageState();
}

class _DatFreeClientesPageState extends State<DatFreeClientesPage> {

  bool _buscar = false;
  Widget _buildListClientes(String imagen, String nombre, String tipo, var identif, String correo, String usuario, int idCliente, int userId){
    
    if(correo == null){
      correo = "-";
    }
    return
        
          Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Container(
                    color: Color(0xff5893d4),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: GestureDetector(
                            onTap: (){
                              print(imagen);
                              print(nombre);
                              print(identif);
                              print(tipo);
                              print(idCliente);
                              print(widget.value);
                              print(userId);
                              Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (BuildContext context ) => DatFreeClienteEditarPage(
                                              imagen: urlImagenes+imagen,
                                              nombre: nombre,
                                              dnioruc: "$identif",
                                              tipodnioruc: tipo,
                                              clienteId: idCliente,
                                              socioId: widget.value,
                                              userId: userId,


                                            )
                                          )
                                        );
                            },
                            child: new CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey,
                              backgroundImage: new NetworkImage(urlImagenes+imagen),
                            ),
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                child: GestureDetector(
                                onTap: (){Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (BuildContext context ) => DatoDocumentoPage(
                                              //miomioidAnterior: widget.value,
                                              tipoUsuario: 5,

                                              value: idCliente,
                                              imagen: urlImagenes+imagen,
                                              nombre: nombre,
                                              identificacion: '$tipo $identif',


                                            )
                                          )
                                        );},
                                        child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    nombre,
                                                    style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                                                  ),
                                                  Text(
                                                    '$tipo $identif',
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
                                        )
                                
                                
                                
                              ),
                              new IconButton(
                                    icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                    onPressed: () => Navigator.push(
                                                        context, 
                                                        MaterialPageRoute(
                                                          builder: (BuildContext context ) => DatoDocumentoPage(
                                                            idAnterior: widget.value,
                                                            tipoUsuario: 5,
                                                            value: idCliente,
                                                            imagen: urlImagenes+imagen,
                                                            nombre: nombre,
                                                            identificacion: '$tipo $identif',
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
            );
        
  }

  var data;
  String nombreSocio = '';
  String tipoidentificador = "";
  int identificador = 0;
  String email = '';

  int cantClientes = 0;
  bool codes;


  int numeroDocumentos = 0;
  String sumaImporteDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  _getClientes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlDatFree/clientesTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final sectoristaSeleccionado = map["sectorista"];
      final listClientes = map["result"];
      final numeroDocumentos = map["numeroDocumentos"];
      final sumaImporteDocumentos = map["sumaImporteDocumentos"];
      final numeroDocumentosVencidos = map["numeroDocumentosVencidos"];
      final sumaImportesDocumentosVencidos = map["sumaImportesDocumentosVencidos"];
      final tipos = map["tipos"];
      final load = map["load"];
      // print(sectoristaSeleccionado['nombre']);
      print(code);
      setState(() {
        _isLoading = load;
        this.nombreSocio = sectoristaSeleccionado['personaNombre'];
        if(sectoristaSeleccionado['personaTipoIdentificacion'] == 1){
          this.tipoidentificador = "DNI";
        }else{
          this.tipoidentificador = "RUC";
        }

        this.identificador = sectoristaSeleccionado['personaNumeroIdentificacion'];
        this.email = sectoristaSeleccionado['userEmail'];

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
        
        for(int cont = 0; cont < tipos.length ; cont++){
            listTipos.add(new DropdownMenuItem(
                value: tipos[cont]['id'].toString(),
                child: new Text(" "+tipos[cont]['nombre'])
            ));
          }

      });
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
    _getClientes();
    _getVariables();
  }

  var textoBusqueda = '' ;
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario = '';
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
        title: new Text('Datos'),
        
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
                                '$numeroDocumentos registros por $sumaImporteDocumentos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por $sumaImportesDocumentosVencidos',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                            ],
                          ),
                        ),
                        // new IconButton(
                        //       icon: Icon(Icons.cloud, color: Colors.white,),
                        //       onPressed: (){}
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
                    // height: MediaQuery.of(context).size.height,
                    color: Color(0xfff7b633),
                    
                  
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[

                          for(int cont =0; cont<cantClientes; cont++ )
                            if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1)
                              _buildListClientes(data[cont]['personaImagen'], 
                                                  data[cont]['personaNombre'], 
                                                  data[cont]['tipoDocumentoIdentidad'], 
                                                  "${data[cont]['personaNumeroIdentificacion']}", 
                                                  data[cont]['userEmail'], 'Cliente', 
                                                  data[cont]['clienteId'],
                                                  data[cont]['userId'] ),
                            
                              
                          
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
                        FontAwesomeIcons.plus,
                        ), 

                  onPressed: (){
                    usuarioBuscar(context);
                  },
                  // onPressed: () => Navigator.push(
                  //   context, 
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context ) => DatoNuevoPage()
                  //   )
                  // ),
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

              IconButton(icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white,), onPressed: () {},),
            ],
          ),
        ),
    );
    
  }


  _buscarCliente() async{
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    print('tipoIdentificador'+identidadSeleccionada);

    var url =
          "$urlDatFree/buscarClientes";

    var response = await http.post(url, body: {
                    "api_token": apiToken,
                    "dni": dniBuscar.text,
                    "tipoIdentificacion": identidadSeleccionada,
                    "idsectoristaSeleccionado": "${widget.value}",
                    "nombre": nombreEstaticoCliente.text,
                  });
        
      print("buscarcliente " +url);
      print(apiToken);
      print(dniBuscar.text);
      print(identidadSeleccionada);
      print("${widget.value}");

      if (response.statusCode == 200) {
        final map = json.decode(response.body);  
        final exis = map["existente"];
        final code = map["code"];
        final load = map["load"];
        final nombreApells = map["nombre"];
        final clienteId = map["clienteId"];
        final sectorId = map["sectorId"];
        final userId = map["userId"];
        final imagen = map["image"];
        final tipoDocumentoIdentidad = map["tipoDocumentoIdentidad"];
      

      
      print(load);
      print("el exis"+"$exis");
      

      setState(() {
        loadBuscadorDni = load;
      });

      

      if(exis){
        if(code){
          setState(() {
              dniExiste = load;
              Navigator.of(context).pop();
              
            });

            print(imagen);
            print(nombreApells);
            print("${dniBuscar.text}");
            print(tipoDocumentoIdentidad);
            print(clienteId);
            print(widget.value);
            print(userId);

              Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context ) => DatFreeClienteEditarPage(
                      imagen: imagen,
                      nombre: nombreApells,
                      dnioruc: "${dniBuscar.text}",
                      tipodnioruc: tipoDocumentoIdentidad,
                      clienteId: clienteId,
                      socioId: widget.value,
                      userId: userId,


                    )
                  )
                );

              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(
              //     builder: (BuildContext context ) => DatFreeNuevoPage( //MIOMIO
              //         estatus: 0,
              //         nombre: nombreApells,
              //         dnioruc:  dniBuscar.text,
              //         socioId: widget.value,
              //         clienteId: clienteId,
              //         sectorId: sectorId,
              //         tipoIdentidad : identidadSeleccionada,
                      
                      
              //       )
              //     )
              // );
          }else{
            setState(() {
              dniExiste = load;
              Navigator.of(context).pop();
            });
            
            Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatFreeNuevoPage(
                      estatus: 1,
                      nombre: nombreApells,
                      dnioruc: dniBuscar.text,
                      socioId: widget.value,
                      clienteId: clienteId,
                      sectorId: sectorId,
                      tipoIdentidad : identidadSeleccionada,
                      
                    )
                  )
              );

          }
      }else{
        setState(() {
          dniExiste = load;
          Navigator.of(context).pop();
          usuarioBuscar(context);
        });
        
      }
          
    }

  }

  TextEditingController dniBuscar = TextEditingController();
  TextEditingController nombreEstaticoCliente = TextEditingController();
  
  bool dniExiste = false;
  bool loadBuscadorDni = true;


  String identidadSeleccionada;
  
  List<DropdownMenuItem<String>> listTipos = new List();

  void seleccionarIdentidad(String tipoIdentidad) {
    Navigator.of(context).pop();
    print(tipoIdentidad);
    setState(() {
      identidadSeleccionada = tipoIdentidad;
    });
    usuarioBuscar(context);
    
  }

  Future<bool> usuarioBuscar(context) {
    
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                color: Color(0xFF070D59),
                height: 280.0,
                width: 200.0,
                padding: EdgeInsets.all(10.0),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: ListView(
                  children: <Widget>[
                    
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.only(bottom: 1.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Busca a tu cliente',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 15.0,
                                color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            Text(
                              'Tipos de identificación: ', 
                              style: TextStyle(
                                  color: Colors.white, 
                                  fontFamily: 'illapaBold', 
                                  fontSize: 15.0, 
                                  ), textAlign: TextAlign.left,
                            ),
                            Container(
                              height: 35.0,
                              color: Colors.white,
                              child: DropdownButton(
                                isExpanded: true,
                                value: identidadSeleccionada,
                                items: listTipos,
                                onChanged: seleccionarIdentidad,

                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Text( 
                              'Numero de identificación:', 
                              style: TextStyle(
                                  color: Colors.white, 
                                  fontFamily: 'illapaBold', 
                                  fontSize: 15.0, 
                                  ), textAlign: TextAlign.left,
                            ),
                            Container(
                              height: 35.0,
                              child: TextField(
                                controller: dniBuscar,
                                keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "",
                                    labelText: "",
                                  ),
                                ),
                            ),
                            dniExiste
                            ?Text(
                              'Este DNI no existe',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                color: Colors.red
                              ),
                            )
                            :Text(''),
                            if(identidadSeleccionada != "1" && identidadSeleccionada != "2")
                            Text( 
                              'Nombre completo del cliente:', 
                              style: TextStyle(
                                  color: Colors.white, 
                                  fontFamily: 'illapaBold', 
                                  fontSize: 15.0, 
                                  ), textAlign: TextAlign.left,
                            ),
                            if(identidadSeleccionada != "1" && identidadSeleccionada != "2")
                            Container(
                              height: 35.0,
                              child: TextField(
                                controller: nombreEstaticoCliente,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "",
                                    labelText: "",
                                  ),
                                ),
                            ),
                          ],
                        )
                    ),
                    
                    !loadBuscadorDni
                    ?_loading()
                    :Column(
                      children: <Widget>[
                         FlatButton(
                            color: Color(0xFF1f3c88),
                            child: Center(
                              child: Text(
                                'BUSCAR',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.white,)
                              ),
                            ),
                            onPressed: () {
                              loadBuscadorDni = false;
                              Navigator.of(context).pop();
                              usuarioBuscar(context);
                              // usuarioValido(context);
                              _buscarCliente();
                              
                            },
                          )
                        // FlatButton(
                        //     color: Color(0xFF1f3c88),
                        //     child: Center(
                        //       child: Text(
                        //         'Agregar',
                        //         style: TextStyle(
                        //             fontFamily: 'Montserrat',
                        //             fontSize: 14.0,
                        //             color: Colors.white,)
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //       Navigator.push(
                        //         context, 
                        //         MaterialPageRoute(
                        //           builder: (BuildContext context ) => DatFreeNuevoPage(
                        //               estatus: 1,
                        //               nombre: nombreEstaticoCliente.text,
                        //               dnioruc:  dniBuscar.text,
                        //               socioId: widget.value,
                        //               tipoIdentidad : identidadSeleccionada,
                        //               // clienteId: clienteId,
                        //               // sectorId: sectorId,
                                      
                        //             )
                        //           )
                        //       );
                        //       // usuarioBuscar(context);
                              
                              
                        //     },
                        //   )

                        // Padding(
                        //   padding: EdgeInsets.all(5.0),
                        // ),
                        // Expanded(
                        //   child: FlatButton(
                        //     color: Color(0xFF1f3c88),
                        //     child: Center(
                        //       child: Text(
                        //         'CANCELAR',
                        //         style: TextStyle(
                        //             fontFamily: 'Montserrat',
                        //             fontSize: 14.0,
                        //             color: Colors.white,)
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                            
                        //   )
                        // )
                        
                      ],
                    )


                  ],
                )));
      });
  }

}