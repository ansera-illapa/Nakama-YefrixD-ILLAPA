import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesGlobales.dart';
import 'package:illapa/pages/datos/datoClienteEditar.dart';
import 'package:illapa/pages/datos/datoDocumento.dart';
import 'package:illapa/pages/datos/datoNuevo.dart';
import 'package:illapa/widgets.dart';
import 'package:intl/intl.dart';
import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DatoClientesPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;

  DatoClientesPage({Key key, this.value,
                              this.nombre,
                              this.imagen}) : super(key: key);
  @override
  _DatoClientesPageState createState() => _DatoClientesPageState();
}

class _DatoClientesPageState extends State<DatoClientesPage> {
  bool _buscar = false;
  String textoBusqueda = '';
  bool ordenAZ = true;
  bool ordenZA = false;

  double tamanoModalBuscarClienteHeight = 320;
  double tamanoModalBuscaClienteWidth = 290.0;

  var moneyType = new NumberFormat("#,##0.00", "en_US");

  Widget _buildListClientes(String imagen, String nombre, String tipo, String identif, String correo, String usuario, int idCliente, int userId, int cont){

    if(correo == null){
      correo = "-";
    }
    return
      Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Container(
                color: Color(0xff5893d4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: GestureDetector(
                        onTap: (){
                              Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (BuildContext context ) => DatoClienteEditarPage(
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
                              onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (BuildContext context ) => DatoDocumentoPage(
                                      idAnterior: widget.value,
                                      tipoUsuario: tipoUsuario,


                                      value: idCliente,
                                      nombre: nombre,
                                      imagen:  urlImagenes+imagen,
                                      identificacion: '$tipo $identif',
                                    )
                                  )
                                );
                              },
                              child: Column(
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
                                  // Text(
                                  //   '$correo',
                                  //   style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  // ),
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
                                                        tipoUsuario: tipoUsuario,


                                                        value: idCliente,
                                                        nombre: nombre,
                                                        imagen:  urlImagenes+imagen,
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
  String imagenSocio = '';
  String tipoidentificador = "";
  String identificador = '';
  String email = '';
  int cantClientes = 0;
  bool codes;

  int numeroDocumentos = 0;
  String sumaImportesDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  List<DropdownMenuItem<String>> listTipos = new List();
  _getClientes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlDato/clientesTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {

      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagDatosDatosClientes${widget.value}.json');
      await fileData.writeAsString("${response.body}");
      _getVariables();

      
    }
  }

  


  int orderAZ(var a,var b){
    return a.compareTo(b);
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

  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
            print("jalaa");
            if(limitarBucle < cantClientes ){
              print("jalaa if");
              setState(() {
                
                limitarBucle = limitarBucle + 20;
                // _isLoading = false;
              });
              
            }
      }
    });
    setState(() {
      // VARIABLES GLOBALES PARA PINTAR DATOS
      if(pagDatDatClientDataGlobal[0]['${widget.value}'] != null ){
        data                = pagDatDatClientDataGlobal[0]['${widget.value}'];
        cantClientes          = data.length;
        if(cantClientes > 0){
          _isLoading = true;
        }
      }
    });

    if(widget.nombre != null){
      nombreSocio = widget.nombre;
      imagenSocio = widget.imagen;
      

    }
    // TODO: implement initState
    super.initState();
    _getClientes();
    _getVariables();
    
  }

  
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  _getVariables() async {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagDatosDatosClientes${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final socioSeleccionado = map["socio"];
        final socioVencido = map["socioVencido"];
        final listClientes = map["result"];
        final tipos = map["tipos"];
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

          if(socioSeleccionado['personaTipoIdentificacion'] == 1){
            this.tipoidentificador = "DNI";
          }else{
            this.tipoidentificador = "RUC";
          }

          this.identificador = "${socioSeleccionado['personaNumeroIdentificacion']}";
          this.email = socioSeleccionado['userEmail'];

          this.data = listClientes;
          
          this.codes = code;
          if(code){
            cantClientes = this.data.length;
            // VARIABLES GLOBALES PARA PINTAR DATOS
            pagDatDatClientDataGlobal[0]['${widget.value}'] = listClientes;
          }else{
            cantClientes = 0;
          }
          listTipos = new List();
          for(int cont = 0; cont < tipos.length ; cont++){
              listTipos.add(new DropdownMenuItem(
                  value: tipos[cont]['id'].toString(),
                  child: new Text(" "+tipos[cont]['nombre'])
              ));
          } 
        });
          
      }catch(error){
        print(error);
      
      }

  }

  int limitarBucle = 20;

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
          controller: scrollController,
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
                      backgroundImage: new NetworkImage(imagenSocio),
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
                                '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))}',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                'Socio',
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
                        //                             builder: (BuildContext context ) => DatoClientesPage()
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
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[                          
                          // for(int cont =0; cont < cantClientes; cont++ )
                          for(int cont =0; cont < cantClientes; cont++ )
                            
                            if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1  )
                            if(cont < limitarBucle)
                            _buildListClientes(data[cont]['personaImagen'], 
                                                  data[cont]['personaNombre'], 
                                                  data[cont]['tipoDocumentoIdentidad'], 
                                                  "${data[cont]['personaNumeroIdentificacion']}", 
                                                  data[cont]['userEmail'], 
                                                  'Cliente', 
                                                  data[cont]['clienteId'],
                                                  data[cont]['userId'],
                                                  limitarBucle 
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
                    ordenAZ = true;
                  });
                  data.sort((a, b) {
                    return orderAZ(a['personaNombre'],b['personaNombre']);
                  });
                },
                tooltip: "Ordenar de la Z a la A",
              ),
            ],
          ),
        ),
    );
    
  }

  
  String clienteExiste = "";
  _buscarCliente() async{
    setState(() {
      dniExiste = false;
    });
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    print(apiToken);
    var url =
          "$urlDato/buscarClientes";

    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "dni": dniBuscar.text,
                    "tipoIdentificacion": identidadSeleccionada,
                    "nombre": nombreEstaticoCliente.text,
                    "idSocioSeleccionado": "${widget.value}" ,
                  });

    print(response.body);
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
      

      setState(() {
        loadBuscadorDni = load;
      });

      if(exis){
        if(code){
              setState(() {
                // dniExiste = load;
                Navigator.of(context).pop();
              });
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatoNuevoPage(
                      estatus: 0,
                      nombre: nombreApells,
                      dnioruc:  dniBuscar.text,
                      socioId: widget.value,
                      clienteId: clienteId,
                      sectorId: sectorId,
                      
                    )
                  )
              );
          }else{
            setState(() {
              // dniExiste = load;
              Navigator.of(context).pop();
            });
            Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context ) => DatoNuevoPage(
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

  void seleccionarIdentidad(String tipoIdentidad) {
    Navigator.of(context).pop();
    print(tipoIdentidad);
    setState(() {
      identidadSeleccionada = tipoIdentidad;
      if(tipoIdentidad == "1" || tipoIdentidad == "2"){
        tamanoModalBuscarClienteHeight = 280;
        tamanoModalBuscaClienteWidth = 200;
      }else{
        tamanoModalBuscarClienteHeight = 320;
        tamanoModalBuscaClienteWidth = 290;
      }

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
              borderRadius: BorderRadius.circular(
                10.0
              )
            ),
            child: Container(
                color: Color(0xFF070D59),
                height: tamanoModalBuscarClienteHeight,
                width: tamanoModalBuscaClienteWidth,
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
                            if(identidadSeleccionada != "1" && identidadSeleccionada != "2")
                            Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text( 
                                'Nombre completo del cliente:', 
                                style: TextStyle(
                                    color: Colors.white, 
                                    fontFamily: 'illapaBold', 
                                    fontSize: 15.0, 
                                    ), textAlign: TextAlign.left,
                              ),
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
                            dniExiste == false
                            ?Text('')
                            :Text(
                              'Este numero de identificación no existe',
                              style: TextStyle(
                                fontFamily: 'illapaBold',
                                fontSize: 12.0,
                                color: Colors.red
                              ),
                            )
                            
                          ],
                        )
                    ),
                    // SizedBox(height: 15.0),
                    !loadBuscadorDni
                    ?_loading()
                    :Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
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
                              _buscarCliente();
                              loadBuscadorDni = false;
                              Navigator.of(context).pop();
                              usuarioBuscar(context);
                              // usuarioValido(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )));
      });
  }

}