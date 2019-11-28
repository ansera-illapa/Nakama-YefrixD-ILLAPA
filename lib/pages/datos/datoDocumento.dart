import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesGlobales.dart';
import 'package:illapa/pages/datos/datoPagos.dart';
import 'package:illapa/pages/datos/datosClientes.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/pages/datos/datosFree/datFreeClientes.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class DatoDocumentoPage extends StatefulWidget {
  final int idAnterior;
  final int tipoUsuario;

  final int value;
  final String nombre;
  final String imagen;
  final String identificacion;

  DatoDocumentoPage({Key key, this.value, this.nombre, this.imagen, this.identificacion, this.idAnterior, this.tipoUsuario}) : super(key: key);

  @override
  _DatoDocumentoPageState createState() => _DatoDocumentoPageState();
}

class _DatoDocumentoPageState extends State<DatoDocumentoPage> {
 DateTime _dateVencimiento;
 DateTime _dateEmision;
 DateTime now = new DateTime.now();
var moneyType = new NumberFormat("#,##0.00", "en_US");


 @override
  void initState() {
    setState(() {
        // VARIABLES GLOBALES PARA PINTAR DATOS
      if(pagDatDatDocumentGlobal[0]['${widget.value}'] != null ){
        data                = pagDatDatDocumentGlobal[0]['${widget.value}'];
        cantDocumentos          = data.length;
        if(cantDocumentos > 0){
          _isLoading = true;
        }
      }
    });
    
    if(widget.nombre != null){
      nombreCliente = widget.nombre;
      imagenCliente = widget.imagen;
      identificacion = widget.identificacion;

    }

    super.initState();
    _getCliente();
    _dateVencimiento = DateTime.now();
    _dateEmision = DateTime.now();
    _getVariables();
    
  }
  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;

  _getVariables() async {
      
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagDatosDatoDocumento${widget.value}.json');

      // GET SOCIOS
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final clienteSeleccionado = map["cliente"];
        final listDocumentos = map["result"];
        final load = map["load"];
        final tipos = map["tipos"];
        final tiposDocumentos = map["tiposDocumentos"];

        // print(clienteSeleccionado['nombre']);
        print(code);
        setState(() {
          _isLoading = load;
          
          this.nombreCliente = clienteSeleccionado['personaNombre'];
          this.imagenCliente = urlImagenes+clienteSeleccionado['personaImagen'];
    
          this.tipoidentificador = clienteSeleccionado['tipoDocumentoIdentidad'];
          
          this.data = listDocumentos;
          
          this.codes = code;
          if(codes){
            cantDocumentos = this.data.length;
            // VARIABLES GLOBALES PARA PINTAR DATOS
            pagDatDatDocumentGlobal[0]['${widget.value}'] = listDocumentos;
          }else{
            cantDocumentos = 0;
          }

          this.identificador = clienteSeleccionado['personaNumeroIdentificacion'];
          this.identificacion = this.tipoidentificador+" "+"${this.identificador}";
          this.email = clienteSeleccionado['userEmail'];
          if(estadoAgregar == true){
            for(int cont = 0; cont < tipos.length ; cont++){
              listTipos.add(new DropdownMenuItem(
                  value: tipos[cont]['id'].toString(),
                  child: new Text(" "+tipos[cont]['nombre'])
              ));
            }
          } 
          
          if(estadoAgregar == true){
            for(int cont = 0; cont < tiposDocumentos.length ; cont++){
              listTiposDocumento.add(new DropdownMenuItem(
                  value: tiposDocumentos[cont]['id'].toString(),
                  child: new Text(" "+tiposDocumentos[cont]['nombre'])
              ));
            }
          }

          
        
      });
          
      }catch(error){
        print(error);
      
      }

  }
 
  void _selectFechaEmision() { 
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: FlatButton(
          
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            modalAddDocumento(context);
          },
          
          child: Text('Aceptar'),
        ),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: _dateEmision,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateEmision = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateEmision = dateTime;
        });
      },
    );
  }


  void _selectFechaVencimiento() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: FlatButton(
          
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            modalAddDocumento(context);
          },
          
          child: Text('Aceptar'),
        ),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: _dateVencimiento,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateVencimiento = dateTime;
        });
      },

      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateVencimiento = dateTime;
        });
      },
    );
  }

  String tipoDocumentoSelect = "FAC";
  String tipoDocumentoSelectVista = "FACTURA";
  String tipoMonedaSelect = "PEN";
  int selectDocumento = 1;
  int selectMoneda = 5;

  Widget _tipos(String sector,   int id, String codigoDocumento ){
    var x = 0xff5893d4;
    if(id == selectDocumento || id == selectMoneda){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: (){
                
                setState(() {
                  if(id > 4){
                    
                    tipoMonedaSelect = sector; 
                    selectMoneda = id;
                  }else{
                    tipoDocumentoSelectVista = sector;
                    tipoDocumentoSelect = codigoDocumento; 
                    selectDocumento = id;
                    
                  }
                 
                });
                
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                modalAddDocumento(context);

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

  void _selectDocumento() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 100.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR TIPO DE DOCUMENTO', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                              _tipos("FACTURA",  1 , "FAC" ),
                              _tipos("BOLETA",   2 , "BOL" ),
                              _tipos("RECIBO",   3 , "REC" ),
                              _tipos("LETRAS",   4 , "LET" ),
                              
                              
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }

    void _selectMoneda() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 100.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR TIPO DE DOCUMENTO', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                              _tipos("PEN", 5 , "" ),
                              _tipos("USD", 6 , "" ),
                              _tipos("EUR", 7 , "" ),
                              
                              
                              
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }

    List<DropdownMenuItem<String>> listTipos = new List();
    List<DropdownMenuItem<String>> listTiposDocumento = new List();
    
    String monedaSeleccionada = '1';
    String documentoSeleccionado = '1';
    void seleccionarIdentidad(String tipoMonedaSeleccionada) { //miomio
      Navigator.of(context).pop();
      print(tipoMonedaSeleccionada);
      setState(() {
        monedaSeleccionada = tipoMonedaSeleccionada;
      });
      modalAddDocumento(context);
    }

    void seleccionarTipoDocumento(String tipoDocumentoSeleccionado){
      Navigator.of(context).pop();
      print(tipoDocumentoSeleccionado);
      setState(() {
        documentoSeleccionado = tipoDocumentoSeleccionado;
      });
      modalAddDocumento(context);
    }

  TextEditingController nombreFactura = TextEditingController();
  TextEditingController importeFactura = TextEditingController();
  Future<bool> modalAddDocumento(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 450.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: ListView(
                    children: <Widget>[
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Agregar un nuevo documento', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Tipo de documento', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    
                                    Container(
                                      height: 30.0,
                                      color: Colors.white,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: documentoSeleccionado,
                                        items: listTiposDocumento,
                                        onChanged: seleccionarTipoDocumento,

                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: _selectDocumento,
                                    //   child: Container(
                                    //     color: Colors.white,
                                    //     height: 40.0,
                                    //     child: Row(
                                    //       children: <Widget>[
                                    //         Padding(
                                    //           padding: EdgeInsets.only(left: 10.0),
                                    //           child: Text('$tipoDocumentoSelectVista')
                                    //         )
                                    //       ],
                                    //     ),
                                      
                                    //   )
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(top:15.0),
                                    ),
                                    Text('Numero del documento', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(              
                                      // height: 45,
                                      child: TextField(
                                              controller: nombreFactura,
                                              // keyboardType: TextInputType.number,
                                              maxLength: 15,
                                              decoration: InputDecoration(
                                                
                                                fillColor: Colors.white,
                                                filled: true,
                                                // hintText: "FAC Nº 00000099",
                                                // labelText: "Factura",
                                              ),
                                            ),
                                    ),
                                    
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // textDirection: TextDirection.ltr,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text('Moneda', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,
                                                ),
                                                Container(
                                                  height: 30.0,
                                                  color: Colors.white,
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    value: monedaSeleccionada,
                                                    items: listTipos,
                                                    onChanged: seleccionarIdentidad,

                                                  ),
                                                ),
                                            ],
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              
                                              Text('Importe', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                              Container(              
                                                  height: 48,
                                                  child: TextField(
                                                          maxLength:  8,
                                                          controller: importeFactura,
                                                          keyboardType: TextInputType.number,
                                                          decoration: InputDecoration(
                                                              
                                                            fillColor: Colors.white,
                                                            filled: true,
                                                            // hintText: "25000.00",
                                                            // labelText: "25000.00",
                                                          ),
                                                        ),
                                                ),
                                              
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      // textDirection: TextDirection.ltr,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text('Emisión', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                              
                                              GestureDetector(
                                                  onTap:_selectFechaEmision,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.0),
                                                          
                                                          child: Text('${_dateEmision.year}-${_dateEmision.month.toString().padLeft(2, '0')}-${_dateEmision.day.toString().padLeft(2, '0')}')
                                                        )
                                                      ],
                                                    ),
                                                  
                                                  )
                                                ),
                                            ],
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              
                                              Text('Vencimiento', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                              GestureDetector(
                                                  onTap:_selectFechaVencimiento,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.0),
                                                          child: Text('${_dateVencimiento.year}-${_dateVencimiento.month.toString().padLeft(2, '0')}-${_dateVencimiento.day.toString().padLeft(2, '0')}')
                                                        )
                                                      ],
                                                    ),
                                                  
                                                  )
                                                ),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),

                                    
                                  ],
                                )
                              ),
                              if(faltanLlenarCampos)
                                Text('Faltan llenar campos', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    
                                    Expanded(
                                      child: RaisedButton(
                                        color: Color(0xfff7b633),
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Agregar', style: TextStyle(color: Colors.white,)), //miomio
                                        onPressed: (){
                                          
                                          if(nombreFactura.text.length > 0 && importeFactura.text.length >0  ){

                                            _agregarDocumento();
                                            Navigator.of(context).pop();
                                            _cargandoAgregarDocumento();
                                            setState(() {
                                             faltanLlenarCampos = false; 
                                            });
                                          }else{
                                            setState(() {
                                              faltanLlenarCampos = true;
                                              Navigator.of(context).pop();
                                              modalAddDocumento(context);
                                            });
                                          }
                                          

                                        },
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                              
                                
                              
                            ],
                          )
                    ],
                  ),
                ),
              
            );
        });
  }
  
  Future<void> _cargandoAgregarDocumento() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Creando documento'),
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


  bool faltanLlenarCampos = false;
  _agregarDocumento() async{
    print(widget.value);
    print(tipoDocumentoSelect);
    print(nombreFactura.text);
    
    print(_dateEmision);
    print(_dateVencimiento);
    print(tipoMonedaSelect);
    print(importeFactura.text);
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/agregarDocumento";

    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "idCliente": "${widget.value}",
                    "tipoDocumento": documentoSeleccionado, //MIOMIO
                    "nombreDocumento": "${nombreFactura.text}" ,
                    "emisionDocumento": "$_dateEmision",
                    "vencimientoDocumento": "$_dateVencimiento",
                    "monedaDocumento": monedaSeleccionada ,
                    "importeDocumento" : "${importeFactura.text}"
                  });

    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.of(context).pop();
        _getCliente();
        setState(() {
          estadoAgregar = false;
          tipoDocumentoSelect = "FAC";
          tipoDocumentoSelectVista = "FACTURA";
          tipoMonedaSelect =  "PEN";
          selectDocumento = 1;
          selectMoneda = 5;
          nombreFactura.text = "";
          
          _dateEmision = DateTime.now();
          _dateVencimiento = DateTime.now();
          
          importeFactura.text = "";

        });
        
      }else{
        Navigator.of(context).pop();
      }
    }  
    
  }

  Widget _buildListDocumentos(  String idTipoDocumento, 
                                String tipoDocumento, 
                                String numeroDocumento, 
                                String fechaEmision, 
                                String fechaVenc, 
                                int vencida, 
                                String importe, 
                                int documentoId, 
                                String saldo, 
                                String idTipoMoneda,
                                String moneda){

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
    vencida = difference.inDays;

    String vencidaPagadaVigente = 'S';
    String saldoTotal = "Saldo $moneda ${moneyType.format(double.parse(saldo))}";
    int nuevaVencida = vencida;
    if(double.parse(saldo) <= 0 ){
      saldoTotal = "PAGADO: "+ "$moneda ${moneyType.format(double.parse(saldo))}";

    }
    if(vencida > 0){
      vencidaPagadaVigente = "VENCIDA: ";
    }else{
      vencidaPagadaVigente = "VIGENTE: ";
      nuevaVencida = vencida - vencida - vencida;
    }

    return 
            GestureDetector(
              onTap: (){Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (BuildContext context ) => DatoPagosPage(
                              idAnterior: widget.idAnterior,
                              tipoUsuario: widget.tipoUsuario,
                              valuePageDocumento: widget.value,

                              
                              value: documentoId,
                              nombre: widget.nombre,
                              imagen:  imagenCliente,
                              identificacion: widget.identificacion,
                              
                              idTipoDocumento: "$idTipoDocumento",
                              tipoDocumento: "$tipoDocumento",
                              numeroDocumento: "$numeroDocumento",
                              fechaEmision: fechaEmision,
                              fechaVencimiento: fechaVenc,
                              vencida: vencida,
                              saldo: saldo,
                              importe: importe,
                              idTipoMoneda: idTipoDocumento,
                              moneda: moneda,
                              tipomoneda : moneda,
                              vencidaPagadaVigente: vencidaPagadaVigente,
                              nuevaVencida: nuevaVencida,
                              saldoTotal: saldoTotal

                            )
                          )
                        );},
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
                                            "$tipoDocumento $numeroDocumento",
                                            style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                          ),
                                          Text(
                                            'Vencimiento $fechaVenc',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                          Text(
                                            '$vencidaPagadaVigente $nuevaVencida días',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                          
                                          Text(
                                            '$saldoTotal',
                                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          vencida <= 0
                                          ?Text(
                                            '$moneda ${moneyType.format(double.parse(importe))}',
                                            style: new TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'illapaBold'),
                                          )
                                          :Text(
                                            '$moneda ${moneyType.format(double.parse(importe))}',
                                            style: new TextStyle(color: Colors.red, fontSize: 16.0, fontFamily: 'illapaBold'),
                                          ),
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                            onPressed: () => Navigator.push(
                                                                context, 
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext context ) => DatoPagosPage(

                                                                    idAnterior: widget.idAnterior,
                                                                    tipoUsuario: widget.tipoUsuario,
                                                                    valuePageDocumento: widget.value,

                                                                    value: documentoId,
                                                                    nombre: widget.nombre,
                                                                    imagen:  imagenCliente,
                                                                    identificacion: widget.identificacion,
                                                                    
                                                                    idTipoDocumento: idTipoDocumento,
                                                                    tipoDocumento: tipoDocumento,
                                                                    numeroDocumento: numeroDocumento,
                                                                    fechaEmision: fechaEmision,
                                                                    fechaVencimiento: fechaVenc,
                                                                    vencida: vencida,
                                                                    saldo: saldo,
                                                                    importe: importe,
                                                                    idTipoMoneda: idTipoDocumento,
                                                                    moneda: moneda,
                                                                    tipomoneda : moneda,
                                                                    vencidaPagadaVigente : vencidaPagadaVigente,
                                                                    nuevaVencida: nuevaVencida,
                                                                    saldoTotal: saldoTotal
                                                                  )
                                                                )
                                                              ),
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


  var data;
  String imagenCliente = '';
  String nombreCliente = '';
  String tipoidentificador = "";
  var identificador;
  String identificacion = '';

  String email = '';

  
  int cantDocumentos = 0;
  bool codes;
  bool estadoAgregar = true;
  _getCliente() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlDato/clienteDocumentos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagDatosDatoDocumento${widget.value}.json');
      await fileData.writeAsString("${response.body}");
       _getVariables();

      
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



  _rutaAnterior(){
    print(widget.tipoUsuario);
      
     
      if(widget.tipoUsuario == 5){
        return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>DatFreeClientesPage(
            value: widget.idAnterior
          )));
      }else{
        return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => DatoClientesPage(
            value: widget.idAnterior
          )));
      }
      
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
                
                _rutaAnterior();

                // Navigator.of(context).pop();
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
              padding: EdgeInsets.all(10.0),
              color: Color(0xff1f3c88),
              child: ListTile(
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
                            nombreCliente,
                            style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white, fontSize: 15.0 ),
                          ),
                          Text(
                            '$identificacion',
                            style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                          ),
                          Text(
                            'CLIENTE',
                            style: new TextStyle(color: AppTheme.naranja, fontSize: 12.0, fontFamily: 'illapaMedium'),
                          ),
                        ],
                      ),
                    ),
                    // new IconButton(
                    //       icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                    //       onPressed: () {}
                    //     )
                  ],
                ),
              ),
            ),
            if(!_isLoading)
              _loading(), 
            Container(
              color: Color(0xfff7b633),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    width: 5.0,
                    // height: MediaQuery.of(context).size.height/100,
                    // height: double.,
                    color: Color(0xfff7b633),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[
                          
                        for(int cont =0; cont<cantDocumentos; cont++ )

                          _buildListDocumentos( "${data[cont]['idTipoDocumento']}",
                                                "${data[cont]['tipo']}", 
                                                "${data[cont]['numero']}",
                                                data[cont]['fechaEmision'], 
                                                data[cont]['fechavencimiento'], 
                                                33, 
                                                "${data[cont]['importe']}", 
                                                data[cont]['id'],  
                                                "${data[cont]['saldo']}",
                                                "${data[cont]['idTipoMoneda']}",
                                                data[cont]['moneda']),
                          
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
          modalAddDocumento(context);
        },
        tooltip: 'Agregar Documento',
        
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }
  
   


}


 


