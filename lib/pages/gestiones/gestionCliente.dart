import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesGlobales.dart';
import 'package:illapa/pages/gestiones/gestionClienteAccion.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';

class GestionClientePage extends StatefulWidget {
  final int value;
  final String imagenCliente;
  final String nombreCliente;
  final int numeroDocumentosVencidos;
  final String sumaImportesVencidos;

  GestionClientePage({Key key,this.value,
                              this.imagenCliente, 
                              this.nombreCliente,
                              this.numeroDocumentosVencidos,
                              this.sumaImportesVencidos}) : super(key: key);

  @override
  _GestionClientePageState createState() => _GestionClientePageState();
}

class _GestionClientePageState extends State<GestionClientePage> {
  var formato = new DateFormat('yyyy-MM-dd');
  DateTime fechaActual = new DateTime.now();
  var moneyType = new NumberFormat("#,##0.00", "en_US");

  String nombreCliente = '';
  String imagenCliente = '';

  int tipoIdentificacion = 0;
  String tipoIden = '';
  var numeroIdentificacion;
  int idCliente;
  
  int cantDocumentos = 0;
  int cantPagos = 0;
  
  var listDocumentos;
  var listDocumentosOrdenados;

  var listPagos;
  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/documentosTodos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionClienteData${widget.value}.json');
      await fileData.writeAsString("${response.body}");
      _getVariables();

    }
  }
    @override
    void initState() {
      setState(() {
        // VARIABLES GLOBALES PARA PINTAR DATOS

        if(pagGestGestClienteDataGlobal[0]['${widget.value}'] != null ){
          listDocumentos    = pagGestGestClienteDataGlobal[0]['${widget.value}'];
          cantDocumentos    = listDocumentos.length;
          if(cantDocumentos > 0){
            _isLoading = true;
          }
        }
    });
      if(widget.nombreCliente != null){
        nombreCliente = widget.nombreCliente;
        imagenCliente = widget.imagenCliente;
      }

      // TODO: implement initState
      super.initState();
      _getVariables();
      _getSocios();
      _getDatosCliente();
    }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  _getVariables() async {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionClienteData${widget.value}.json');
    // GET SOCIOS
    try{
      print(await fileData.readAsString());
      final map = json.decode(await fileData.readAsString());
      final code = map["code"];
      
      final clienteSeleccionado = map["cliente"];
      final listDocumentos = map["result"];
      final listDocumentosOrdenados = map["resultOrdenados"];
      final listPagos = map["pagos"];
      final load = map["load"];
      // print(clienteSeleccionado['nombre']);
      print(code);

      setState(() {
        _isLoading = load;
        this.idCliente= widget.value;
        print("idcliente: $idCliente");
        this.nombreCliente = clienteSeleccionado['personaNombre'];
        this.imagenCliente = urlImagenes+clienteSeleccionado['personaImagen'];
        
        this.tipoIden = clienteSeleccionado['tipoDocumentoIdentidad'];
        this.numeroIdentificacion = clienteSeleccionado['personaNumeroIdentificacion'];
        
        if(code == true){
          this.listDocumentos = listDocumentos;
          cantDocumentos = this.listDocumentos.length;
          // VARIABLES GLOBALES PARA PINTAR DATOS
          pagGestGestClienteDataGlobal[0]['${widget.value}'] = this.listDocumentos;

          this.listDocumentosOrdenados = listDocumentosOrdenados;

          this.listPagos = listPagos;
          cantPagos = this.listPagos.length;
        }
        
        
      });
    }catch(error){
      print(error);
    }

    // GET DATOS CLIENTE
    final fileDataAcciones = File('${directory.path}/pagGestGestionClienteDataAcciones${widget.value}.json');
    try{
      print(await fileDataAcciones.readAsString());
      final map = json.decode(await fileDataAcciones.readAsString());
      final code                      = map["code"];
      final load                      = map["load"];
      final codeTelefono              = map["codeTelefono"];
      final listTelefonos             = map["telefonos"];
      final codeAcciones              = map["codeAcciones"];
      final codeNada                  = map["codeNada"];
      final listAcciones              = map["acciones"];
      final listDirecciones           = map["direcciones"];
      final codeTelefonosAcciones     = map["codeTelefonosAcciones"];
      final codeDireccionesAcciones   = map["codeDireccionesAcciones"];
      final codeDireccionesTelefonos  = map["codeDireccionesTelefonos"];

      final codeDirecciones = map["codeDirecciones"];
      setState(() {

        if(code == true){
          this.dataTelefonos = listTelefonos;
          this.cantTelefonos = this.dataTelefonos.length;

          this.dataAcciones = listAcciones;
          this.cantAcciones = this.dataAcciones.length;

          this.dataDirecciones = listDirecciones;
          this.cantDirecciones = this.dataDirecciones.length;
        }else if(codeTelefonosAcciones == true){
            this.dataTelefonos = listTelefonos;
            this.cantTelefonos = this.dataTelefonos.length;

            this.dataAcciones = listAcciones;
            this.cantAcciones = this.dataAcciones.length;
        }else if(codeDireccionesAcciones == true){
            this.dataDirecciones = listDirecciones;
            this.cantDirecciones = this.dataDirecciones.length;

            this.dataAcciones = listAcciones;
            this.cantAcciones = this.dataAcciones.length;

        }else if(codeDireccionesTelefonos == true){
            this.dataDirecciones = listDirecciones;
            print(dataDirecciones);
            this.cantDirecciones = this.dataDirecciones.length;

            this.dataTelefonos = listTelefonos;
            this.cantTelefonos = this.dataTelefonos.length;

        }else if(codeAcciones == true){

          this.dataAcciones = listAcciones;
          this.cantAcciones = this.dataAcciones.length;

        }else if(codeTelefono == true){
          this.dataTelefonos = listTelefonos;
          this.cantTelefonos = this.dataTelefonos.length;
        }else if(codeDirecciones == true){
          this.dataDirecciones = listDirecciones;
          this.cantDirecciones = this.dataDirecciones.length;
        }

        print("ESTE: $cantTelefonos");
      });
        
    }catch(error){
      print(error);
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
  Widget build(BuildContext context) {
    return new Scaffold(
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
                      backgroundImage: new NetworkImage(imagenCliente),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                               "$nombreCliente",
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                              ),
                              numeroIdentificacion == null
                              ?Text(
                                '$tipoIden -',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              )
                              :Text(
                                '$tipoIden $numeroIdentificacion',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
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
            

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: 
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.white,  size: 35.0,),
                                  onPressed: () async{
                                    seleccionarDireccion(context);
                                    
                                   
                                                  // Navigator.push(
                                                  //     context, 
                                                  //     MaterialPageRoute(
                                                  //       builder: (BuildContext context ) => GestionClienteAccionPage(
                                                  //         value: idCliente,
                                                  //         icon: 1,
                                                  //         nombre: nombreCliente,
                                                  //         tipoIdentificacion: tipoIden,
                                                  //         numeroIdentificacion: numeroIdentificacion,
                                                  //       )
                                                  //     )
                                                  //   );

                                  }
                                    
                                ),
                                
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.sms, color: Colors.white,  size: 35.0,),
                                  onPressed: () async{

                                      // Navigator.push(
                                      //   context, 
                                      //   MaterialPageRoute(
                                      //     builder: (BuildContext context ) => GestionClienteAccionPage(
                                      //       value: idCliente,
                                      //       icon: 2,
                                      //       nombre: nombreCliente,
                                      //       tipoIdentificacion: tipoIden,
                                      //       numeroIdentificacion: numeroIdentificacion,
                                      //     )
                                      //   )
                                      // );
                                    seleccionarDatoAccion(context, 2);
                                            // await launch("sms:+987719398?body=Pagame%20!");
                                            
                                  }
                                  
                                  
                                                     
                                ),

                                
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.phone, color: Colors.white,  size: 35.0,),
                                  onPressed: ()async {
                                    // Navigator.push(
                                    //                   context, 
                                    //                   MaterialPageRoute(
                                    //                     builder: (BuildContext context ) => GestionClienteAccionPage(
                                    //                       value: idCliente,
                                    //                       icon: 3,
                                    //                       nombre: nombreCliente,
                                    //                       tipoIdentificacion: tipoIden,
                                    //                       numeroIdentificacion: numeroIdentificacion,
                                    //                     )
                                    //                   )
                                    //                 );
                                    seleccionarDatoAccion(context, 3);
                                    

                                        // await launch("tel://987719398");
                                        
                                  }
                                  
                                  
                                                
                                ),
                                
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white,  size: 35.0,),
                                  onPressed: () {
                                          // Navigator.push(
                                          //           context, 
                                          //           MaterialPageRoute(
                                          //             builder: (BuildContext context ) => GestionClienteAccionPage(
                                          //               value: idCliente,
                                          //               icon: 4,
                                          //               nombre: nombreCliente,
                                          //               tipoIdentificacion: tipoIden,
                                          //               numeroIdentificacion: numeroIdentificacion,
                                          //             )
                                          //           )
                                          //         );
                                      seleccionarDatoAccion(context, 4); //miomio
                                      
                                  }
                                    
                                                  
                                ),
                                
                              ),
                        ],
                      ),
                    ),
            ),
            
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
                          if(!_isLoading)
                          _loading(),
                          if(ordenar == false)
                            for(var cont =0; cont < cantDocumentos; cont++ )
                              _buildDocumentos("${listDocumentos[cont]['tipoDocumentoIdentidad']}"+" "+"${listDocumentos[cont]['numero']}", 
                                                listDocumentos[cont]['fechavencimiento'], 5, 
                                                listDocumentos[cont]['importe'], 
                                                listDocumentos[cont]['saldo'], 
                                                listDocumentos[cont]['id'], listDocumentos[cont]['moneda']),

                          if(ordenar == true)
                            for(var cont =0; cont < cantDocumentos; cont++ )
                              _buildDocumentos("${listDocumentosOrdenados[cont]['tipoDocumentoIdentidad']}"+" "+"${listDocumentosOrdenados[cont]['numero']}", 
                                              listDocumentosOrdenados[cont]['fechavencimiento'], 5, 
                                              listDocumentosOrdenados[cont]['importe'], 
                                              listDocumentosOrdenados[cont]['saldo'], 
                                              listDocumentosOrdenados[cont]['id'], 
                                              listDocumentosOrdenados[cont]['moneda']),                          
                          
                        ],
                      ),
                      
                    ),
                  ),
                  
                ],
              )
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 50.0),
              ),
            Container(
              color: Color(0xff5893d4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    width: 5.0,
                    
                    color: Color(0xff5893d4),
                    
                  
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          for(int cont = 0; cont < cantAcciones; cont++)
                            _buildAcciones(dataAcciones[cont]['created_at'], 
                                            dataAcciones[cont]['tipoAccion'],  
                                            dataAcciones[cont]['descripcion'], 
                                            "${dataAcciones[cont]['fechacompromiso']}"+"  -  "+"${dataAcciones[cont]['importecompromiso']}", 
                                            dataAcciones[cont]['fechaprorroga'],
                                            dataAcciones[cont]['fechahoraalarma'] )
                        ],
                      ),
                      
                    ),
                  ),
                  
                ],
              )
            ),

            
            Padding(
                padding: EdgeInsets.only(bottom: 50.0),
              )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(ordenar == true){
              ordenar = false;
            }else{
              ordenar = true;
            }
            
            //miomio
          });
        },
        tooltip: '',
        child: Icon(FontAwesomeIcons.ellipsisH),
      ),
    );
    
  }
  
  bool ordenar = false;




  var dataTelefonos;
  int cantTelefonos = 0;

  var dataAcciones;
  int cantAcciones = 0;

  var dataDirecciones;
  int cantDirecciones= 0;

  _getDatosCliente() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlGlobal/api/datosCliente/${widget.value}?api_token="+apiToken;
    print(url);
  
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionClienteDataAcciones${widget.value}.json');
      await fileData.writeAsString("${response.body}");
      _getVariables();
      
    }
    
  }

  Future<bool> seleccionarDatoAccion(context, int tipo,  ) {

    String url;
    

    return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {

            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 400.0,
                  color: Color(0xFF070D59),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for(var cont= 0; cont< cantTelefonos; cont++)
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                                      child: RaisedButton(
                                        child: Text("${dataTelefonos[cont]['pais']} ${dataTelefonos[cont]['prefijo']} ${dataTelefonos[cont]['numero']}"),
                                        onPressed: () async{

                                            Navigator.of(context).pop();
                                            switch (tipo) {
                                              case 1: url = ''; 
                                                break;
                                              case 2: url = 'sms:${dataTelefonos[cont]['prefijo']} ${dataTelefonos[cont]['numero']}?body=Estimado '+nombreCliente+': A la fecha tiene '+'${widget.numeroDocumentosVencidos}'+' documento(s) vencidos por ${moneyType.format(double.parse(widget.sumaImportesVencidos))}! .Agradeceremos regularizar su situación';
                                                break;
                                              case 3: url = 'tel://${dataTelefonos[cont]['prefijo']} ${dataTelefonos[cont]['numero']}';
                                                break;
                                              case 4: url = 'whatsapp://send?phone= ${dataTelefonos[cont]['prefijo']} ${dataTelefonos[cont]['numero']}&text=Estimado '+nombreCliente+': A la fecha tiene '+'${widget.numeroDocumentosVencidos}'+' documento(s) vencidos por ${moneyType.format(double.parse(widget.sumaImportesVencidos))}! .Agradeceremos regularizar su situación';
                                                break;

                                              default:
                                            }
                                             Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GestionClienteAccionPage(
                                                        imagenCliente: imagenCliente,
                                                        value: idCliente,
                                                        icon: tipo,
                                                        nombre: nombreCliente,
                                                        tipoIdentificacion: tipoIden,
                                                        numeroIdentificacion: numeroIdentificacion,
                                                      )
                                                    )
                                                  );
                                            await launch("$url");
                                        },
                                      ),
                                    )
                                  )
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                ),
                
              );
          });
  }

  Future<bool> seleccionarDireccion(context,) {

    
    

    return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {

            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 400.0,
                  color: Color(0xFF070D59),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for(var cont= 0; cont< cantDirecciones; cont++)
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                                      child: RaisedButton(
                                        child: Text("${dataDirecciones[cont]['calle']}"),
                                        onPressed: () async{
                                            
                                            Navigator.of(context).pop();
                                             Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GestionClienteAccionPage(
                                                        imagenCliente: imagenCliente,
                                                        
                                                        value: idCliente,
                                                        icon: 1,
                                                        nombre: nombreCliente,
                                                        tipoIdentificacion: tipoIden,
                                                        numeroIdentificacion: numeroIdentificacion,
                                                      )
                                                    )
                                                  );
                                            await launch("https://www.google.com/maps/search/?api=1&query=${dataDirecciones[cont]['latitud']},${dataDirecciones[cont]['longitud']}");
                                        },
                                      ),
                                    )
                                  )
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                ),
                
              );
          });
  }

  int vencida = 0;

  Widget _buildDocumentos(String titulo, String fecha, int vencimiento, String cantidad, String saldo, int idDocumento, String moneda ) {
    bool importeVencido = false;  
    List fechas = fecha.split("-");
    var ano = int.parse(fechas[0]);
    var mes = int.parse(fechas[1]);
    var dia = int.parse(fechas[2]);
    
    int anoFechaActual = fechaActual.year;
    int mesFechaActual = fechaActual.month;
    int diaFechaActual = fechaActual.day;
    // print(" fecha: $fechaActual");

    if(anoFechaActual == ano){   
      if(mesFechaActual == mes){
        if(diaFechaActual <= dia){
          
        }else{
          importeVencido = true;    
        }
      }else{
        if(mesFechaActual < mes){  

        }else{
          importeVencido = true;
        }
      }

    }else{
      if(anoFechaActual < ano){  

       }else{
         importeVencido = true;
       }

    }


    // SACAR DIAS VENCIDOS : 
    var fechaVencida = new DateTime.utc(ano,mes, dia+1); //OJOJOJO
    
    Duration diferencia = fechaActual.difference(fechaVencida);
    vencida = diferencia.inDays;
    String tipoMoneda = moneda;
    
    String vencidaPagadaVigente = 'S';
    String saldoTotal = "Saldo: "+ "$tipoMoneda ${moneyType.format(double.parse(saldo))}";
    int nuevaVencida = vencida;
    if(double.parse(saldo) <= 0 ){
      saldoTotal = "PAGADO: "+ "$tipoMoneda ${moneyType.format(double.parse(saldo))}";

    }
    if(vencida > 0){
      vencidaPagadaVigente = "VENCIDA: ";
    }else{
      vencidaPagadaVigente = "VIGENTE: ";
      nuevaVencida = vencida - vencida - vencida;
    }

    return 
    Padding(
      padding: EdgeInsets.only(bottom: 1.0),
    
    child: Container(
      
      color: Colors.white,
      child: 
            ExpansionTile(
              key: new PageStorageKey<int>(3),
              title: Container(
                // padding: EdgeInsets.only(bottom: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // color: Colors.orange,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("$titulo ", style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0)),
                                  new Text("Vencimiento: "+fecha, style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
                                  new Text("$vencidaPagadaVigente: "+ "$nuevaVencida días", style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
                                  new Text(saldoTotal, style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),

                                ],
                              ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    
                                    child: 
                                    importeVencido == true
                                    ?new Text("$tipoMoneda ${moneyType.format(double.parse(cantidad))}", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, color: Colors.red,),)
                                    :new Text("$tipoMoneda ${moneyType.format(double.parse(cantidad))}", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, ))
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
              children: <Widget>[
                for(var x=0; x < cantPagos; x++)
                  if(listPagos[x]['documentosId'] == idDocumento )
                    if(listPagos[x]['pagosDocumentoId'] != null )
                      
                      Container(
                        // color: Color(0xFF1F3C88),
                        color: Color(0xFF5893D4),
                        child: ListTile(
                          // dense: true,
                          // enabled: true,
                          // isThreeLine: false,
                          // onLongPress: () => print("long press"),
                          // onTap: () => print("tap"),
                          subtitle: new Text("Fecha: "+"${listPagos[x]['pagosFechaEmision']}", style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
                          // leading: new Text("Leading"),
                          // selected: false,
                          trailing: new Text("$tipoMoneda  ${moneyType.format(double.parse(listPagos[x]['pagosImporte']))} ", style: TextStyle(fontFamily: 'illapaBold', fontSize: 12.0)),
                          title: new Text("${listPagos[x]['tipo']}"+" "+"${listPagos[x]['pagosNumero']}", style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0)),
                        )
                      )
              ],
              // children: t.children.map(_buildpago).toList()
            )
    ));
  }

  
  Widget _buildAcciones(String fechaHora, String tipoAccion, String descripcionAccion, String compromisoPago, String prorroga, String alerta){
    fechaHora = '$fechaHora'.replaceAll(new RegExp('null'), '-');
    fechaHora = '$fechaHora'.replaceAll(new RegExp(' '), ' - ');
    tipoAccion = '$tipoAccion'.replaceAll(new RegExp('null'), '-');
    descripcionAccion = '$descripcionAccion'.replaceAll(new RegExp('null'), '-');
    compromisoPago = '$compromisoPago'.replaceAll(new RegExp('null'), '-');
    prorroga = '$prorroga'.replaceAll(new RegExp('null'), '-');
    alerta = '$alerta'.replaceAll(new RegExp('null'), '-');

    return Padding(
            padding: EdgeInsets.only(bottom: 1.0),
            child: Container(
                    color: Color(0xfff7b633), 
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
                                    Center(
                                      child: Text(
                                                  fechaHora + " - "+tipoAccion,textAlign: TextAlign.center,
                                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0  ),
                                                ),
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom: 5.0),),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.handshake, 
                                          size: 15, 
                                          color: Colors.white
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.0)
                                        ),
                                        Text(
                                          "$compromisoPago", 
                                          style: TextStyle(
                                            fontFamily: 'illapaBold', 
                                            color: Colors.white 
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 15.0,
                                            
                                          )
                                        ),

                                        Icon(
                                          FontAwesomeIcons.calendarAlt, 
                                          size: 15, 
                                          color: Colors.white
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.0)
                                        ),
                                        Text(
                                          '$prorroga', 
                                          style: TextStyle(
                                            fontFamily: 'illapaMedium', 
                                            color: Colors.white,
                                            fontSize: 15
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 15.0,
                                            
                                          )
                                        ),


                                        Icon(
                                          FontAwesomeIcons.clock, 
                                          size: 15, 
                                          color: Colors.white),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 15.0,
                                            
                                          )
                                        ),
                                        Text(
                                          '$alerta', 
                                          style: TextStyle(
                                            fontFamily: 'illapaBold', 
                                            color: Colors.white,
                                            fontSize: 10
                                          ),
                                        ),

                                      ],
                                    ),
                                    // Padding(padding: EdgeInsets.only(bottom: 5.0),),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Icon(FontAwesomeIcons.calendarAlt, size: 20, color: Colors.white),
                                    //     Padding(
                                    //       padding: EdgeInsets.only(left: 15.0)
                                    //     ),
                                    //     Text('$prorroga', style: TextStyle( fontFamily: 'illapaBold', color: Colors.white ),),
                                    //   ],
                                    // ),
                                    // Padding(padding: EdgeInsets.only(bottom: 5.0),),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Icon(FontAwesomeIcons.clock, size: 20, color: Colors.white),
                                    //     Padding(
                                    //       padding: EdgeInsets.only(left: 15.0)
                                    //     ),
                                    //     Text('$alerta', style: TextStyle( fontFamily: 'illapaBold', color: Colors.white ),),
                                    //   ],
                                    // ),
                                    Padding(padding: EdgeInsets.only(bottom: 5.0),),
                                    Text(
                                      descripcionAccion,
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
          );
  }


  Widget _buildpago() {
    print("children");
      return new Container(
        // color: Color(0xFF1F3C88),
        color: Color(0xFF5893D4),
        child: ListTile(
          // dense: true,
          // enabled: true,
          // isThreeLine: false,
          // onLongPress: () => print("long press"),
          // onTap: () => print("tap"),
          subtitle: new Text("t.fecha", style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
          // leading: new Text("Leading"),
          // selected: false,
          trailing: new Text("t.cantidad", style: TextStyle(fontFamily: 'illapaBold', fontSize: 12.0)),
          title: new Text("t.title", style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0)),
        )
      ); 
  }
}







