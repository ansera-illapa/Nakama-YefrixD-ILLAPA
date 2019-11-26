import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';

import 'package:illapa/widgets.dart';
import 'dart:ui' as ui;
import 'package:illapa/pages/gestiones/gestionCliente.dart';

import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

// NOTIFICACIONES LOCALES
// import 'package:illapa/extras/local_notificaciones/flutter_local_notifications.dart';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class GestionClienteAccionPage extends StatefulWidget {
  final String imagenCliente;
  final int value;
  final int icon;
  final String nombre;
  final String tipoIdentificacion;
  final int numeroIdentificacion;

  GestionClienteAccionPage({Key key, this.imagenCliente, this.value, this.icon, this.nombre, this.tipoIdentificacion, this.numeroIdentificacion}) : super(key: key);

  @override
  _GestionClienteAccionPageState createState() => _GestionClienteAccionPageState();
}

class _GestionClienteAccionPageState extends State<GestionClienteAccionPage> {
  bool esCompromiso = false;
  bool esProrroga = false;
  bool esAlerta = false;
  DateTime fechaActual = new DateTime.now();
  TextEditingController _formatCtrl = TextEditingController();



  DateTime _dateCompromiso;
  DateTime _dateProrroga;
  DateTime _dateAlerta;
  DateTime _horaAlerta;

  var icon;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _formatCtrl.text = 'yyyy-MMMM-dd';
    _dateCompromiso = fechaActual;
    _dateProrroga = fechaActual;
    _dateAlerta = fechaActual;
    _horaAlerta = fechaActual;
    _getSocios();
    _getVariables();
    
    if(widget.icon == 1){
      icon = FontAwesomeIcons.mapMarkedAlt;
    }else if(widget.icon == 2){
      icon = FontAwesomeIcons.sms;
    }else if(widget.icon == 3){
      icon = Icons.phone;
    }else if(widget.icon == 4){
      icon = FontAwesomeIcons.whatsapp;
    }
    
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

  String nombreCliente = '';
  String imagenCliente = '';
  
  int tipoIdentificacion;
  String tipoIden;
  int numeroIdentificacion;
  int idCliente;

  int cantDocumentos = 0;
  var listDocumentos;
  _getSocios() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/formularAccionCliente/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final code = map["code"];
      final listDocumentos = map["result"];
      final clienteSeleccionado = map["cliente"];
      final load = map["load"];
      // print(clienteSeleccionado['nombre']);
      
      setState(() {
        // _isLoading = load;
        this.idCliente= widget.value;
        this.nombreCliente = clienteSeleccionado['personaNombre'];
        this.imagenCliente = urlImagenes+clienteSeleccionado['personaImagen'];
        this.tipoIdentificacion = clienteSeleccionado['personaTipoIdentificacion'];
        this.numeroIdentificacion = clienteSeleccionado['personaNumeroIdentificacion'];
        
        if(tipoIdentificacion == 1){
          tipoIden = "DNI";
        }else{
          tipoIden = "RUC";
        }

        if(code == true){
          this.listDocumentos = listDocumentos;
          cantDocumentos = this.listDocumentos.length;
          
        }
      });
    }
  }
   
  
  

  String descripcionAccion = "";
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
          tipousuario: tipoUsuario,
          idusuario: idUsuario,
          imagenUsuario: imagenUsuario,
          nombre : nombreUsuario
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
                      backgroundImage: new NetworkImage(widget.imagenCliente),
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
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                              ),
                              Text(
                                '${widget.tipoIdentificacion} ${widget.numeroIdentificacion}',
                                style: new TextStyle(color: AppTheme.naranja, fontSize: 15.0, fontFamily: 'illapaMedium'),
                              ),
                              
                              
                            ],
                          ),
                        ),

                        new IconButton(
                              icon: Icon(icon  , color: Colors.white,),
                              onPressed:  (){},
                            )
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Container(
              child:Column(
                children: <Widget>[
                    Container(
                      child: TextField(
                        maxLines: 3,
                        // backgroundColor: Color(0xff2ECC71),
                        decoration: InputDecoration(
                          fillColor: Color(0xff5893d4),
                          filled: true,
                          hintText: "",
                          labelText: "Resultado de la Acción:",
                          
                        ),
                        onChanged: (text){
                                    setState(() {
                                      descripcionAccion = text;
                                    });
                                  },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Color(0xff5893d4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.handshake, size: 20, color: Colors.white),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0)
                              ),
                              Text('Compromiso de Pago', style: TextStyle( fontFamily: 'illapaBold', color: Colors.white ),),
                            ],
                          ),
                          
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          
                                          Switch(
                                              value: esCompromiso,
                                              onChanged: (value) {
                                                setState(() {
                                                  esCompromiso = value;
                                                });
                                              },
                                              // activeTrackColor: Colors.black, 
                                              activeColor: Colors.black,
                                            ),
                                            
                                        
                                      ],
                                    )
                                  ),
                                 
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: esCompromiso == false 
                                              ? null 
                                              :_selectFechaCompromiso,
                                      child: 
                                      esCompromiso == false
                                      ?Text(
                                        '${_dateCompromiso.year}-${_dateCompromiso.month.toString().padLeft(2, '0')}-${_dateCompromiso.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(color: Colors.blueGrey, fontFamily: 'illapaBold'),textAlign: TextAlign.right,
                                      )
                                      :Text(
                                        '${_dateCompromiso.year}-${_dateCompromiso.month.toString().padLeft(2, '0')}-${_dateCompromiso.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(fontFamily: 'illapaBold'),textAlign: TextAlign.right,
                                      )
                                    )
                                    
                                   
                                  ),

                                  
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: esCompromiso == false 
                                              ? null 
                                              :(){ ingresarImporteCompromiso();},

                                        child: 
                                        esCompromiso == false 
                                        ?Text("$nombreDocumentoSeleccionado \n S/. $importeCompromiso",  textAlign: TextAlign.right, style: TextStyle( color: Colors.blueGrey, fontFamily: 'illapaBold'),)
                                        :Text("$nombreDocumentoSeleccionado \n S/. $importeCompromiso",  textAlign: TextAlign.right, style: TextStyle(fontFamily: 'illapaBold'),)
                                    ),
                                    
                                  ),
                              ],
                            ),
                          )
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Color(0xff5893d4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.calendarAlt, size: 20, color: Colors.white),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0)
                              ),
                              Text('Prórroga', style: TextStyle( fontFamily: 'illapaBold', color: Colors.white ),),
                            ],
                          ),
                          
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          
                                          Switch(
                                              value: esProrroga,
                                              onChanged: (value) {
                                                setState(() {
                                                  esProrroga = value;
                                                });
                                              },
                                              // activeTrackColor: Colors.black, 
                                              activeColor: Colors.black,
                                            ),
                                            
                                        
                                      ],
                                    )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: esProrroga == false 
                                              ? null 
                                              :_selectFechaProrroga,
                                      child: 
                                      esProrroga == false 
                                      ?Text(
                                        '${_dateProrroga.year}-${_dateProrroga.month.toString().padLeft(2, '0')}-${_dateProrroga.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(color: Colors.blueGrey, fontFamily: 'illapaBold'), textAlign: TextAlign.right,
                                      )
                                      :Text(
                                        '${_dateProrroga.year}-${_dateProrroga.month.toString().padLeft(2, '0')}-${_dateProrroga.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(fontFamily: 'illapaBold'), textAlign: TextAlign.right,
                                      ),
                                    )
                                  ),

                                  
                                  
                              ],
                            ),
                          )
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Color(0xff5893d4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.clock, size: 20, color: Colors.white),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0)
                              ),
                              Text(' Alerta', style: TextStyle( fontFamily: 'illapaBold', color: Colors.white ),),
                            ],
                          ),
                          
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          
                                          Switch(
                                              value: esAlerta,
                                              onChanged: (value) {
                                                setState(() {
                                                  esAlerta = value;
                                                });
                                              },
                                              // activeTrackColor: Colors.black, 
                                              activeColor: Colors.black,
                                            ),
                                            
                                        
                                      ],
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: esAlerta == false 
                                              ? null 
                                              :_showTimePicker,
                                          child: 
                                          esAlerta == false 
                                          ?Text(
                                            '${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}',
                                            style:  TextStyle( color: Colors.blueGrey, fontFamily: 'illapaBold'), textAlign: TextAlign.right,)
                                          :Text(
                                            '${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}',
                                            style:  TextStyle(fontFamily: 'illapaBold'), textAlign: TextAlign.right,)
                                        ),
                                        
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                        ),
                                        GestureDetector(
                                          onTap: esAlerta == false 
                                              ? null 
                                              :_selectFechaAlerta,
                                          child: 
                                          esAlerta == false 
                                          ?Text(
                                            '${_dateAlerta.year}-${_dateAlerta.month.toString().padLeft(2, '0')}-${_dateAlerta.day.toString().padLeft(2, '0')}',
                                            style: TextStyle( color: Colors.blueGrey, fontFamily: 'illapaBold'), textAlign: TextAlign.right,
                                          )
                                          :Text(
                                            '${_dateAlerta.year}-${_dateAlerta.month.toString().padLeft(2, '0')}-${_dateAlerta.day.toString().padLeft(2, '0')}',
                                            style: TextStyle(fontFamily: 'illapaBold'), textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    )

                                    
                                  ),
                              ],
                            ),
                          )
                          
                        ],
                      ),
                    )
                ],
              ) ,
            ),
        
          ],
        ),
        
      ),
          floatingActionButton: FloatingActionButton(
              // onPressed:()async{
              //   // await _checkPendingNotificationRequests();
              //   await _scheduleNotification();
              // },
              onPressed:
                descripcionAccion.length > 0
                ? () async{
                    confirmacionAgregar(context);
                    
                  }
                : () async{
                    alerta(context);
                  },


              tooltip: '',
              child: Icon(FontAwesomeIcons.save),
            ),
    );
  
  }


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  


  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    print(scheduledNotificationDateTime);
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 
        'your channel name', 
        'your channel description',
        importance: Importance.Max, 
        icon: 'secondary_icon',
        sound: 'slow_spring_board',
        vibrationPattern: vibrationPattern,
        priority: Priority.High, 
        ticker: 'ticker');
    
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }


  _agregarAcccion() async{

      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api.txt');
      String apiToken = await file.readAsString();
      final url =
          "$urlGlobal/api/agregarAccion";
      print(url);
      print(widget.value);
      print(descripcionAccion);
      print(idDocumentoSeleccionado);
      print(esCompromiso);
      print(_dateCompromiso);
      print(importeCompromiso);

      print(esProrroga);
      print(_dateProrroga);

      print(esAlerta);
      print('${_dateAlerta.year}-${_dateAlerta.month.toString().padLeft(2, '0')}-${_dateAlerta.day.toString().padLeft(2, '0')}');
      // print('${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}');
      
      
    DateTime fechaAcutalSistema = new DateTime.now();
    print(fechaAcutalSistema);
    print('${fechaAcutalSistema.year}-${fechaAcutalSistema.month.toString().padLeft(2, '0')}-${fechaAcutalSistema.day.toString().padLeft(2, '0')} ${fechaAcutalSistema.hour.toString().padLeft(2, '0')}:${fechaAcutalSistema.minute.toString().padLeft(2, '0')}:${fechaAcutalSistema.second.toString().padLeft(2, '0')}');
    print("ALARMA:");
    print(_dateAlerta);

    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "clienteId": "${widget.value}",
                    "tipoAccion": "${widget.icon}",
                    "descripcion": "$descripcionAccion",
                    "fechaActualSistema":'${fechaAcutalSistema.year}-${fechaAcutalSistema.month.toString().padLeft(2, '0')}-${fechaAcutalSistema.day.toString().padLeft(2, '0')} ${fechaAcutalSistema.hour.toString().padLeft(2, '0')}:${fechaAcutalSistema.minute.toString().padLeft(2, '0')}:${fechaAcutalSistema.second.toString().padLeft(2, '0')}',
                    // "documentoId": "$idDocumentoSeleccionado",
                    "compromisoPago": "$esCompromiso",
                    "fechaCompromiso": "$_dateCompromiso",

                    "importeCompromiso": "$importeCompromiso",
                    "prorroga": "$esProrroga",
                    "fechaProrroga": "$_dateProrroga",
                    "alerta": "$esAlerta",
                    "fechaAlerta": '${_dateAlerta.year}-${_dateAlerta.month.toString().padLeft(2, '0')}-${_dateAlerta.day.toString().padLeft(2, '0')} ${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}',
                    // "horaAlerta": '${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}',

                  });
      // print(json.decode(response.body));
    if(esAlerta){
      var scheduledNotificationDateTime = DateTime.parse("${_dateAlerta.year}-${_dateAlerta.month.toString().padLeft(2, '0')}-${_dateAlerta.day.toString().padLeft(2, '0')} ${_horaAlerta.hour.toString().padLeft(2, '0')}:${_horaAlerta.minute.toString().padLeft(2, '0')}");
      print("alarma ---------------- "+"$scheduledNotificationDateTime");
      var vibrationPattern = Int64List(4);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 1000;
      vibrationPattern[2] = 5000;
      vibrationPattern[3] = 2000;

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Alarma Accion', 
          'ILLAPA', 
          'Notificacion creada para la accion de alarma',
          importance: Importance.Max, 
          icon: 'secondary_icon',
          sound: 'slow_spring_board',
          vibrationPattern: vibrationPattern,
          priority: Priority.High, 
          ticker: 'ticker');
      
      var iOSPlatformChannelSpecifics =
          IOSNotificationDetails(sound: "slow_spring_board.aiff");
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.schedule(
          0,
          widget.nombre,
          descripcionAccion,
          scheduledNotificationDateTime,
          platformChannelSpecifics);
    }
    Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context ) => GestionClientePage(
                  value: widget.value,
                  nombreCliente: widget.nombre,
                  imagenCliente: widget.imagenCliente,



                )
              )
            );


  }          

  Future<bool> confirmacionAgregar(context) {
    return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 160.0,
                  color: Color(0xFF070D59),
                  padding: EdgeInsets.all(10.0),
                  
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('¿Estás seguro de agregar esta acción?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                
                                Expanded(
                                  child: RaisedButton(
                                    color: Color(0xfff7b633),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Agregar', style: TextStyle(color: Colors.white),),
                                    onPressed:  
                                      (){ 

                                        _agregarAcccion();
                                        Navigator.of(context).pop();
                                        // _cargandoDatosCliente();

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


  Future<bool> alerta(context) {
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
                            child: Text('El campo de "Resultado de la Acción" es obligatorio', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                
                                Expanded(
                                  child: RaisedButton(
                                    color: Color(0xfff7b633),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Aceptar', style: TextStyle(color: Colors.white),),
                                    onPressed:  
                                      (){ 
                                        Navigator.of(context).pop();
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

 

  Future<bool> modalVerDocumentos(context, int tipo) {


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
                padding: EdgeInsets.all(10.0),
                
                  child: ListView(
                    children: <Widget>[
                        Column(
                          
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Lista de Documentos', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('Seleccione documentos', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                  
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                  ],
                                )
                              ),
                            ],
                          ),
                          Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              
                                  for(var cont =0; cont < cantDocumentos; cont++ )
                                    _documentos(listDocumentos[cont]['tipo']+" "+"${listDocumentos[cont]['numero']}", listDocumentos[cont]['id'], cont, tipo ),
                               
                              
                            ],
                          )
                    ],
                  ),
                ),
              
            );
        });
  }




  String importeCompromiso = "";

  Future<void> ingresarImporteCompromiso() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingresar importe de compromiso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: TextField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            onChanged: (text){
                                    importeCompromiso = text;
                                    
                                    // value = value+text;
                                  },
                            
                          ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int idDocumentoSeleccionado = 0;
  int contDocumentSeleccionado;
  String nombreDocumentoSeleccionado = 'Seleccionar cantidad pago';

  Widget _documentos(String titulo,  int idDocumento, int contSeleccionado, int tipo ) {
    var x = 0xff5893d4;
    if(contSeleccionado == contDocumentSeleccionado){
      x = 0xff1f3c88;
    }
    
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: RaisedButton(
        onPressed: (){
          setState(() {
            contDocumentSeleccionado = contSeleccionado;
            nombreDocumentoSeleccionado = titulo;
            idDocumentoSeleccionado = idDocumento;
          });
          
          print("nombre " +nombreDocumentoSeleccionado);
          Navigator.of(context).pop();
          
          if(tipo == 1){
            ingresarImporteCompromiso();
          }
          
        },
        textColor: Colors.white,
        color: Color(x),
        // padding: const EdgeInsets.all(8.0),
        child: new Text(
          titulo
        ),
      ),
    );
  }




  // Display date picker.
  void _selectFechaCompromiso() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Aceptar', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: fechaActual,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateCompromiso = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateCompromiso = dateTime;
        });
      },
    );
  }

  void _selectFechaProrroga() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Aceptar', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: _dateProrroga,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateProrroga = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateProrroga = dateTime;
        });
      },
    );
  }

  void _selectFechaAlerta() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Aceptar', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: fechaActual,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateAlerta = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateAlerta = dateTime;
        });
      },
    );
  }

   /// Display time picker.
  void _showTimePicker() {
    DatePicker.showDatePicker(
      context,
      
      minDateTime: DateTime.parse('2010-05-12 00:00:00'),
      maxDateTime: DateTime.parse('2021-11-25 23:59:59'),
      initialDateTime: fechaActual,
      dateFormat: 'HH:mm',
      pickerMode: DateTimePickerMode.time, // show TimePicker
      pickerTheme: DateTimePickerTheme(
        // title: Container(
        //   decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
        //   width: double.infinity,
        //   height: 56.0,
        //   alignment: Alignment.center,
        //   child: Text(
        //     'Asignar Hora',
        //     style: TextStyle(color: Colors.black, fontSize: 24.0),
        //   ),
        // ),
        showTitle: true,
        confirm: Text('Aceptar', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
        // titleHeight: 56.0,
      ),
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _horaAlerta = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _horaAlerta = dateTime;
        });
      },
    );
  }
}
