import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:illapa/widgets.dart';
import 'package:intl/intl.dart';
import 'package:illapa/pages/gestiones/gestionCliente.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VencMesPage extends StatefulWidget {

  final int ano;
  final int mes;
  final int id;
  final String url;
  VencMesPage({Key key, this.ano, this.mes, this.id, this.url}) : super (key: key);
  
  
  @override
  _VencMesPageState createState() => _VencMesPageState();

}

class _VencMesPageState extends State<VencMesPage> {
  
  DateTime _currentDate;
  var moneyType = new NumberFormat("#,##0.00", "en_US");
  
  int limitador = 1;
  int contEvents = 0;

  var listNombre = new List();
  var listVencimiento = new List();
  var listSaldo = new List();
  var listImporte = new List();
  var listId = new List();
  var listIdCliente = new List();
  var listMoneda = new List();

  String _currentMonth = '';

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.red, width: 2.0)
    ),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
  

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;


  Widget _buildListDocumentos(String nombre, String fechaVenc,  String precio, int documentoId, String saldo, int idCliente ,String moneda){
    DateTime today = new DateTime.now();
    List fechaVencSeparada = fechaVenc.split("-");
    
    var ano = int.parse(fechaVencSeparada[0]);
    var mes = int.parse(fechaVencSeparada[1]);
    var dia = int.parse(fechaVencSeparada[2]);

    var fechaVencida = new DateTime.utc(ano,mes, dia+1);
    Duration difference = today.difference(fechaVencida);
    
    print(today);
    print(fechaVencida);
    print(difference.inDays);
    int vencida = difference.inDays;

    String tipoMoneda = moneda;
    // if(moneda == "PEN"){
    //   tipoMoneda = "S/";
    // }else if(moneda == "USD"){
    //   tipoMoneda = '\$';
    // }else if(moneda == "EUR"){
    //   tipoMoneda = "€";
    // }


    return 
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context ) => GestionClientePage(
                        value: idCliente,
                        
                      )
                    )
                  );


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
                                            nombre,
                                            style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                          ),
                                          Text(
                                            'Vencimiento $fechaVenc',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                          Text(
                                            'Vencida $vencida días',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                          
                                          Text(
                                            'Saldo $tipoMoneda ${moneyType.format(double.parse(saldo))}',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          vencida < 0
                                          ?Text(
                                            '$tipoMoneda ${moneyType.format(double.parse(precio))}',
                                            style: new TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'illapaBold'),
                                          )
                                          :Text(
                                            '$tipoMoneda ${moneyType.format(double.parse(precio))}',
                                            style: new TextStyle(color: Colors.red, fontSize: 16.0, fontFamily: 'illapaBold'),
                                          ),
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                            onPressed: () {
                                              Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context ) => GestionClientePage(
                                                      value: idCliente
                                                    )
                                                  )
                                                );
                                            }
                                          )
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


  var listFechasEspecificas;
  int cantFechasEspecificas = 0;

  EventList<Event> _eventsVencimientos = new EventList<Event>(
    events: {
      
    },
  );



  _getFechas() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    
    final url =
        "$urlVencimiento/${widget.url}/fechasEspecifica/${widget.id}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {

      final map = json.decode(response.body);
      final code = map["code"];
      final listFechasEspecificas = map["result"];
      final load = map["load"];

      setState(() {

        if(code == true){
          this.listFechasEspecificas = listFechasEspecificas;
          this.cantFechasEspecificas = this.listFechasEspecificas.length;


          for(var cont =0; cont < this.cantFechasEspecificas; cont++ ){
           DateTime x =  DateTime.parse(this.listFechasEspecificas[cont]['documentosVencimiento']);

             _eventsVencimientos.add(
                 x,
                new Event(
                  date: x,
                  title: "$cont",
                  icon: _eventIcon,
                ));
              
            
          }
          
        }

      });
    }
  }

  @override
  void initState() {
    _getFechas();
    _getVariables();
   
    super.initState();
    
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
      setState(() {
        tipoUsuario = int.parse(tipoUsuarioInt);
        idUsuario = int.parse(idUsuarioInt);
        imagenUsuario = imagenUsuarioString;  
      });
      
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");
      print("IMAGEN: $imagenUsuario");

  }

  // DECORACION DE LOS TEXT DETALLOS DE UN EVENTO
  BoxDecoration myBox(){
    return BoxDecoration(
      border: Border.all(
        width: 1
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    
    if(limitador == 1){
      _currentDate = DateTime(widget.ano, widget.mes, 1);
      limitador = limitador+1;
    }
    

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      locale: 'ES',
      todayBorderColor: Colors.green,

      onDayPressed: (DateTime date, List<Event> events) {
        print(date);
        this.setState(() => _currentDate = date);
        this.setState(() => listNombre.removeRange(0, contEvents));
        this.setState(() => listVencimiento.removeRange(0, contEvents));
        this.setState(() => listSaldo.removeRange(0, contEvents));
        this.setState(() => listImporte.removeRange(0, contEvents));
        this.setState(() => listId.removeRange(0, contEvents));
        this.setState(() => listIdCliente.removeRange(0, contEvents));
        this.setState(() => listMoneda.removeRange(0, contEvents));
        
        
        this.setState(() => contEvents = 0);
        this.setState(() => events.forEach((event) => contEvents = contEvents+1));
        
        this.setState(() => events.forEach((event) => listNombre.add(listFechasEspecificas[int.parse(event.title)]['personaNombre']) ));
        this.setState(() => events.forEach((event) => listVencimiento.add(listFechasEspecificas[int.parse(event.title)]['documentosVencimiento']) ));
        this.setState(() => events.forEach((event) => listSaldo.add(listFechasEspecificas[int.parse(event.title)]['documentoSaldo']) ));
        this.setState(() => events.forEach((event) => listImporte.add(listFechasEspecificas[int.parse(event.title)]['documentoImporte']) ));
        this.setState(() => events.forEach((event) => listId.add(listFechasEspecificas[int.parse(event.title)]['documentoId']) ));
        this.setState(() => events.forEach((event) => listIdCliente.add(listFechasEspecificas[int.parse(event.title)]['clienteId']) ));
        this.setState(() => events.forEach((event) => listMoneda.add(listFechasEspecificas[int.parse(event.title)]['documentoMoneda']) ));
        
                                                              
        events.forEach((event) => print(event.title));


      },  

      
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _eventsVencimientos,
      height: 420.0,  
      selectedDateTime: _currentDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal:
          false, 
      showHeader: true,
      headerTextStyle: TextStyle( color: Colors.black, fontSize: 20.0, fontFamily: 'illapaBold') ,
      showHeaderButton: true,
      prevMonthDayBorderColor: Colors.black,
      leftButtonIcon: Container(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),

      rightButtonIcon: Container(
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),

      // dayButtonColor: Colors.black,
      
      selectedDayButtonColor: Colors.black,

      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      
      todayButtonColor: Colors.red,
      selectedDayTextStyle: TextStyle(
        color: Colors.white, fontSize: 20.0
        
      ),
      
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
    );


    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Vencimientos'),
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
      // backgroundColor: Color(0xFF5893D4),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF070D59),
          ),
          child: Sidebar(
           
          )
        ),
      body: 
        Container(
          child: ListView(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                    ), 
                    Container(
                      margin: EdgeInsets.only(
                        // top: 5.0,
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      // child: Text('$_currentDate'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      // color: Colors.white,
                      child: _calendarCarouselNoHeader,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20.0,
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                    ),
                    
                
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          for (var i = 0; i < contEvents; i++)
                            _buildListDocumentos(listNombre[i], listVencimiento[i], listImporte[i], listId[i], listSaldo[i], listIdCliente[i], listMoneda[i]),

                          Padding(
                            padding: EdgeInsets.all(10.0),
                          )
                          
                        ],
                      ),
                    ),
              
                  
                  ],
                ),
              ),
              
            ],
          )
        ),
        
        // floatingActionButtonLocation: 
        //   FloatingActionButtonLocation.centerDocked,
        //   // backgroundColor: Color(0xff070d59),
          
        //   floatingActionButton: FloatingActionButton(
        //     child: 
        //           const Icon(
        //                 Icons.add
        //                 ), 
        //           onPressed: () {},
        //   ),

        // bottomNavigationBar: BottomAppBar(
        //   color: Color(0xff070d59),
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 4.0,
        //   child: new Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: () {},),
        //       IconButton(icon: Icon(Icons.computer, color: Colors.white,), onPressed: () {},),
        //     ],
        //   ),
        // ),
    );
  }
}