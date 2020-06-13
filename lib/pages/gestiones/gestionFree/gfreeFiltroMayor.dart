import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesSidebar.dart';
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

class GfreeFiltroMayorPage extends StatefulWidget {
  final int value;
  final String imagenGestor;
  final String nombreGestor;
  final int numeroDocumentos;
  final String sumaImportesDocumentos;
  final int numeroDocumentosVencidos;
  final String sumaImportesDocumentosVencidos;
  
  
  GfreeFiltroMayorPage({Key key, this.value,
                                  this.imagenGestor, 
                                  this.nombreGestor,
                                  this.numeroDocumentos, 
                                  this.sumaImportesDocumentos, 
                                  this.numeroDocumentosVencidos, 
                                  this.sumaImportesDocumentosVencidos}) : super(key: key);

  @override
  _GfreeFiltroMayorPageState createState() => _GfreeFiltroMayorPageState();
}

class _GfreeFiltroMayorPageState extends State<GfreeFiltroMayorPage> {
  var formato = new DateFormat('yyyy-MM-dd');
  DateTime fechaActual = new DateTime.now();

  String nombreGestor = '';
  String imagenGestor = '';

  int tipoIdentificacion;
  String tipoIden;
  int numeroIdentificacion;
  int idCliente;
  
  int cantDocumentos = 0;
  int cantPagos = 0;
  
  var listDocumentos;
  var listPagos;
  _getDocumentos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGestionFree/documentosTodos/${widget.value}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileData = File('${directory.path}/pag-gestiones-gestionFree-gfreeFiltroMayor${widget.value}.json');
        await fileData.writeAsString("${response.body}");
        _getVariables();
    }
  }
    @override
    void initState() {

      if(widget.nombreGestor != null){
        nombreGestor = widget.nombreGestor;
        imagenGestor = widget.imagenGestor;
      }

      // TODO: implement initState
      super.initState();
      _getDocumentos();
      _getVariables();
      
    }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pag-gestiones-gestionFree-gfreeFiltroMayor${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
          final map = json.decode(await fileData.readAsString());
          final code = map["code"];
          final listDocumentos = map["result"];
          final listPagos = map["pagos"];
          final load = map["load"];
          // print(clienteSeleccionado['nombre']);
          print(code);

          setState(() {
            // _isLoading = load;
            this.idCliente= widget.value;
            print("idcliente: $idCliente");
            
            
            if(tipoIdentificacion == 1){
              tipoIden = "DNI";
            }else{
              tipoIden = "RUC";
            }
            if(code == true){
              this.listDocumentos = listDocumentos;
              cantDocumentos = this.listDocumentos.length;

              this.listPagos = listPagos;
              cantPagos = this.listPagos.length;
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
                      backgroundImage: new NetworkImage(imagenUsuarioGlobal),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                               "$nombreGestor",
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                              ),
                              Text(
                                '${widget.numeroDocumentos} registros por ${widget.sumaImportesDocumentos}',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              Text(
                                '${widget.numeroDocumentosVencidos} vencidos por ${widget.sumaImportesDocumentosVencidos}',
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
            
            // if(!_isLoading)
            //   _loading(),
            /*Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: 
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.white,  size: 35.0,),
                                  onPressed: () async{
                                    
                                    await launch("https://www.google.com/maps/search/?api=1&query=-16.360700,-71.543544");
                                   
                                                  // Navigator.push(
                                                  //     context, 
                                                  //     MaterialPageRoute(
                                                  //       builder: (BuildContext context ) => GestionClienteAccionPage(
                                                  //         value: idCliente,
                                                  //         icon: 1,
                                                  //         nombre: nombreGestor,
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
                                      //       nombre: nombreGestor,
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
                                    //                       nombre: nombreGestor,
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
                                             
                                              seleccionarDatoAccion(context, 4);
                                                    
                                      // await FlutterLaunch.launchWathsApp(phone: "+51 987140650", message: "Pagame");
                                      
                                  }
                                    
                                                  
                                ),
                                
                              ),
                        ],
                      ),
                    ),
            ),
            */
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
                          
                          for(var cont =0; cont < cantDocumentos; cont++ )
                            _buildDocumentos("${listDocumentos[cont]['tipoDocumentoIdentidad']}"+" "+"${listDocumentos[cont]['numero']}", listDocumentos[cont]['fechavencimiento'], 5, listDocumentos[cont]['importe'], listDocumentos[cont]['saldo'], listDocumentos[cont]['id']),
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

      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        tooltip: '',
        child: Icon(FontAwesomeIcons.ellipsisH),
      ),
    );
    
  }
  





  var dataTelefonos;
  int cantTelefonos = 0;
  

  Future<bool> seleccionarDatoAccion(context, int tipo,  ) {

    String url;
    _tipoAccion(){
      switch (tipo) {
        case 1: url = '';
          break;
        case 2: url = 'sms:+987719398?body=Pagame%20!';
          break;
        case 3: url = 'tel://987719398';
          break;
        case 4: url = 'whatsapp://send?phone=';
          break;

        default:
      }
    }

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
                                        child: Text("${dataTelefonos[cont]['numero']}"),
                                        onPressed: () async{
                                            //miomio
                                            switch (tipo) {
                                              case 1: url = '';
                                                break;
                                              case 2: url = 'sms:+${dataTelefonos[cont]['numero']}?body=Pagame%20!';
                                                break;
                                              case 3: url = 'tel://${dataTelefonos[cont]['numero']}';
                                                break;
                                              case 4: url = 'whatsapp://send?phone=51 ${dataTelefonos[cont]['numero']}?body=Oee%20';
                                                break;

                                              default:
                                            }
                                             Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => GestionClienteAccionPage(
                                                        value: idCliente,
                                                        icon: tipo,
                                                        nombre: nombreGestor,
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










  int vencida = 0;

  Widget _buildDocumentos(String titulo, String fecha, int vencimiento, String cantidad, String saldo, int idDocumento ) {
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
                                  new Text("$titulo", style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0)),
                                  new Text("Vencimiento: "+fecha, style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
                                  new Text("Vencida: "+ "$vencida días", style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),
                                  new Text("Saldo: "+ "$saldo", style: TextStyle(fontFamily: 'illapaMedium', fontSize: 12.0)),

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
                                    ?new Text("$cantidad", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, color: Colors.red,),)
                                    :new Text("$cantidad", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, ))
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
                          trailing: new Text("${listPagos[x]['pagosImporte']}", style: TextStyle(fontFamily: 'illapaBold', fontSize: 12.0)),
                          title: new Text("${listPagos[x]['tipoPago']}"+" "+"${listPagos[x]['pagosNumero']}", style: TextStyle(fontFamily: 'illapaBold', fontSize: 15.0)),
                        )
                      )
              ],
              // children: t.children.map(_buildpago).toList()
            )
    ));
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







