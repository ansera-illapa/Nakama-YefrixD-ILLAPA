import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/pages/datos/datoDocumento.dart';
import 'package:illapa/widgets.dart';

import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class DatoPagosPage extends StatefulWidget {
  
  
  final int idAnterior;
  final int tipoUsuario;
  final int valuePageDocumento;
  
  final int value;
  final String nombre;
  final String imagen;
  final String identificacion;

  final String idTipoDocumento;
  final String tipoDocumento;
  final String numeroDocumento;
  final String fechaEmision;
  final String fechaVencimiento;
  final int vencida;
  final String saldo;
  final String importe;
  final String idTipoMoneda;
  final String moneda;
  final String tipomoneda;
  final String vencidaPagadaVigente;
  final int nuevaVencida;
  final String saldoTotal;
  

  DatoPagosPage({Key key, 
                  this.idAnterior,
                  this.tipoUsuario,
                  this.valuePageDocumento,
                  this.value, 
                  this.nombre, 
                  this.imagen, 
                  this.identificacion,
                  this.idTipoDocumento,
                  this.tipoDocumento,
                  this.numeroDocumento,
                  this.fechaEmision,
                  this.fechaVencimiento,
                  this.vencida,
                  this.saldo,
                  this.idTipoMoneda,
                  this.moneda,
                  this.tipomoneda,
                  this.vencidaPagadaVigente,
                  this.nuevaVencida,
                  this.saldoTotal,
                  this.importe}) : super(key: key);

  @override
  _DatoPagosPageState createState() => _DatoPagosPageState();
}

class _DatoPagosPageState extends State<DatoPagosPage> {
  DateTime _dateVencimientoEditarDoc;
  DateTime _dateEmision;
  DateTime _dateEmisionEditar;
  DateTime now = new DateTime.now();
  
  bool editarPago = false;
  bool faltanLlenarCampos = false;

  bool editandoDoc = false;
  bool editandoPago = false;
  
  _agregarPago() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/agregarPago";

    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "documentoId": "${widget.value}",
                    "tipoPago": tipoPagoSeleccionadoDrop,
                    "numeroPago": "${nombreFactura.text}" ,
                    "emisionPago": "$_dateEmision",
                    "vencimientoPago": "$_dateVencimientoEditarDoc",
                    "monedaPago": tipoMonedaSelect ,
                    "importePago" : "${importeFactura.text}",
                    "saldoDocumento" : "$saldoDocumento"
                  });

    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.of(context).pop();
        _getPagos();
        setState(() {
          estadoAgregar = false;
          tipoPagoSeleccionado = "EFE";
          tipoPagoSeleccionadoVista = "EFECTIVO";
          selectPago = 1; 
          
          nombreFactura.text = "";
          
          _dateEmision = DateTime.now();
          _dateVencimientoEditarDoc = DateTime.now();
        });
        
      }else{
        Navigator.of(context).pop();
      }
    } 
  
  }

  // EDITAR PAGO
  bool faltanLlenarCamposEditar = false;
  String idPagoEditar;
  _editarPago() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/editarPago";
    print(url);
    print(apiToken);
    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "documentoId": "${widget.value}",
                    "pagoId": "$idPagoEditar",
                    "tipoPago": tipoPagoSeleccionadoDrop,
                    "numeroPago": "${numeroPagoEditar.text}" ,
                    "emisionPago": "$_dateEmisionEditar",
                    "importePago" : "${importePagoEditar.text}",
                    "saldoDocumento" : "$saldoDocumento"
                    
                  });

    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.of(context).pop();
        _getPagos();
        setState(() {
          estadoAgregar = false;
        });
        
      }else{
        Navigator.of(context).pop();
      }
    } 
  }



  // EDITAR DOCUMENTO

  bool faltanLlenarCamposEditarDoc = false;
  _editarDocumento() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/editarDocumento";
    print(url);
    print(apiToken);
    
    final response = await http.post(url, body: {
                    "api_token"     : apiToken,
                    "documentoId"   : "${widget.value}",
                    "tipoDoc"       : "$documentoSeleccionado",
                    "numeroDoc"     : "${numeroFacturaEditDoc.text}" ,
                    "tipoMonedaDoc" : "$monedaSeleccionada",
                    "importeDoc"    : "${importeFacturaEditDoc.text}",
                    "emisionDoc"    : "$_dateEmisionEditar",
                    "vencDoc"       : "$_dateVencimientoEditarDoc"
                    
                  });

    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.of(context).pop();
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>DatoDocumentoPage(
                idAnterior: widget.idAnterior,
                tipoUsuario: widget.tipoUsuario,

                value: widget.valuePageDocumento,
                nombre: widget.nombre,
                imagen: widget.imagen,
                identificacion: widget.identificacion,
            )));
        
      }else{
        Navigator.of(context).pop();
      }
    } 
  
  }

  TextEditingController numeroFacturaEditDoc = TextEditingController();
  TextEditingController importeFacturaEditDoc = TextEditingController();
  Future<bool> modalEditDocumento(context) {
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
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Editar el documento', 
                                  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
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
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    Text('Numero del documento', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(              
                                      height: 45,
                                      child: TextField(
                                              controller: numeroFacturaEditDoc,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
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
                                                    onChanged: seleccionarTipoMonedaEditDoc,
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
                                                          controller: importeFacturaEditDoc,
                                                          keyboardType: TextInputType.number,
                                                          decoration: InputDecoration(
                                                            fillColor: Colors.white,
                                                            filled: true,
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
                                                  onTap:_selectFechaEmisionEditar,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.0),
                                                          
                                                          child: Text('${_dateEmisionEditar.year}-${_dateEmisionEditar.month.toString().padLeft(2, '0')}-${_dateEmisionEditar.day.toString().padLeft(2, '0')}')
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
                                                  onTap:_selectFechaVencimientoEditarDoc,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.0),
                                                          child: Text('${_dateVencimientoEditarDoc.year}-${_dateVencimientoEditarDoc.month.toString().padLeft(2, '0')}-${_dateVencimientoEditarDoc.day.toString().padLeft(2, '0')}')
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
                              if(faltanLlenarCamposEditarDoc)
                                Text('Faltan llenar campos', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    
                                    Expanded(
                                      child: RaisedButton(
                                        color: Color(0xfff7b633),
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Editar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ),),
                                        onPressed: (){
                                          
                                          if(numeroFacturaEditDoc.text.length > 0 && importeFacturaEditDoc.text.length >0  ){

                                            _editarDocumento();
                                            Navigator.of(context).pop();
                                            _cargandoAgregarDocumento("Editando Documento");
                                            setState(() {
                                             faltanLlenarCamposEditarDoc = false; 
                                            });
                                          }else{
                                            setState(() {
                                              faltanLlenarCamposEditarDoc = true;
                                              Navigator.of(context).pop();
                                              modalEditDocumento(context);
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

  List<DropdownMenuItem<String>> listTipos = new List();
  List<DropdownMenuItem<String>> listTiposDocumento = new List();
  
  String monedaSeleccionada = '1';
  String documentoSeleccionado = '1';
  void seleccionarTipoMonedaEditDoc(String tipoMonedaSeleccionada) { 
    Navigator.of(context).pop();
    print(tipoMonedaSeleccionada);
    setState(() {
      monedaSeleccionada = tipoMonedaSeleccionada;
    });
    modalEditDocumento(context);
  }

  void seleccionarTipoDocumento(String tipoDocumentoSeleccionado){
    Navigator.of(context).pop();
    print(tipoDocumentoSeleccionado);
    setState(() {
      documentoSeleccionado = tipoDocumentoSeleccionado;
    });
    modalEditDocumento(context);
  }  
  
  







  String vencidaPagadaVigente = '';
  int nuevaVencida ;
  String saldoTotal;
  List partesSaldo;
 @override
  void initState() {

    if(widget.nombre != null){
      nombreCliente = widget.nombre;
      imagenCliente = widget.imagen;
      identificacion = widget.identificacion;

      nombreDocumento = widget.tipoDocumento +" "+ widget.numeroDocumento;
      vencimientoDocumento = widget.fechaVencimiento;
      vencida = widget.vencida;
      saldoDocumento = widget.saldo;
      importeDocumento = widget.importe;

      tipoMonedaSelect = widget.moneda;

      vencidaPagadaVigente = widget.vencidaPagadaVigente;
      nuevaVencida = widget.nuevaVencida;
      saldoTotal = widget.saldoTotal;
      partesSaldo = saldoTotal.split(" ");
        
    }


    super.initState();
    _getPagos();
    _dateVencimientoEditarDoc = DateTime.now();
    _dateEmision = DateTime.now();
    _getVariables();
    print("fechaacuta $now");
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuarioSelect = '';
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
      imagenUsuarioSelect = imagenUsuarioString;
      print("TIPOUSUARIO: $tipoUsuario");
      print("IDUSUARIO: $idUsuario");
      print("IMAGEN: $imagenUsuarioSelect");

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
            modalAddPago(context);
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

  void _selectFechaEmisionEditar() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: FlatButton(
          
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            if(editandoDoc){

              modalEditDocumento(context);
            }else if(editandoPago){

              modalEditPago(context);
            }
            
          },
          
          child: Text('Aceptar'),
        ),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2025-11-25'),
      initialDateTime: _dateEmisionEditar,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateEmisionEditar = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateEmisionEditar = dateTime;
        });
      },
    );
  }


  void _selectFechaVencimientoEditarDoc() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: FlatButton(
          
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            modalEditDocumento(context);
          },
          
          child: Text('Aceptar'),
        ),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2025-11-25'),
      initialDateTime: _dateVencimientoEditarDoc,
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.es,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateVencimientoEditarDoc = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateVencimientoEditarDoc = dateTime;
        });
      },
    );
  }
  
 
  var moneyType = new NumberFormat("#,##0.00", "en_US");

  Widget _buildListPagos(int idPago,int idTipoPago, String tipoPago, String numeroPago, String fechaVenc,  String precio){
    
  
  return Padding(
          padding: EdgeInsets.only(bottom: 1.0),
          child: Container(
                  color: Color(0xff1f3c88),
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
                                    tipoPago+ ' '+numeroPago,
                                    style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                  ),
                                  Text(
                                    'Emitida $fechaVenc',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                  if(editarPago == true)
                                  Text('${widget.moneda} ${moneyType.format(double.parse(precio))}',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),),
                                  
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  editarPago == true
                                  ?Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.pencilAlt, color: Colors.white,),
                                        onPressed: () {
                                          modalEditPago(context);
                                          setState(() {
                                            editandoDoc = false;
                                            editandoPago = true;
                                            idPagoEditar = "$idPago";
                                          tipoPagoSeleccionadoDrop = "$idTipoPago";
                                          numeroPagoEditar.text = "$numeroPago";
                                          importePagoEditar.text = "$precio";
                                          _dateEmisionEditar = DateTime.parse(fechaVenc);
                                          });
                                        }
                                      ),
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.trashAlt, color: Colors.redAccent,),
                                        onPressed: () {
                                          setState(() {
                                            idPagoEditar = "$idPago";
                                            modalEliminarPago(context, idPagoEditar);
                                          });
                                        }
                                      )
                                    ],
                                  )
                                  :Text('${widget.moneda} ${moneyType.format(double.parse(precio))}'),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          );
                  
  }


  Future<bool> modalEliminarPago(context, String idPago) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 170.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de eliminar este Pago?', 
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
                                  child: Text('Eliminar', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                                  onPressed: (){
                                    _eliminarPago(idPago);
                                    setState(() {
                                     _isLoading=false; 
                                    });
                                    Navigator.of(context).pop();
                                    _cargandoAgregarDocumento('Elimando Pago');
                                    
                                  },
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

  _eliminarPago(String idPago) async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/eliminarPago";
    print(url);
    print(apiToken);
    
    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "documentoId": "${widget.value}",
                    "pagoId": "$idPagoEditar",
                  });

    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.of(context).pop();
        _getPagos();
        setState(() {
        });
        
      }else{
        Navigator.of(context).pop();
      }
    } 
  
  }



  var data;
  String imagenCliente = '';
  String nombreCliente = '';

  String tipoDocumento = "";
  int numeroDocumento = 0;

  String nombreDocumento = '';

  String vencimientoDocumento = 'loading ...';
  String importeDocumento = 'loading ...';
  String saldoDocumento = 'loading ...';

  String tipoidentificador = "";
  var identificador;
  String identificacion = '';

  String email = '';

  int cantPagos = 0;
  int vencida=0;
  bool codes;
  bool estadoAgregar = true;
  _getPagos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlDato/clienteDocumentoPagos/${widget.value}?api_token="+apiToken;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {

      final map = json.decode(response.body);
      final code = map["code"];
      final clienteSeleccionado = map["cliente"];
      final documentoSeleccionado = map["documento"];
      final listTiposPagos = map["tipoPagos"];
      final listPagos = map["result"];

      final load = map["load"];
      
      final tipos = map["tipos"];
      final tiposDocumentos = map["tiposDocumentos"];
      
      setState(() {
        _isLoading = load;
        this.nombreCliente = clienteSeleccionado['personaNombre'];
        this.imagenCliente = urlImagenes+clienteSeleccionado['personaImagen'];
        
        this.tipoidentificador = clienteSeleccionado['personatipoDocumentoIdentidad_id'];
        
        if(estadoAgregar == true){
          for(int cont = 0; cont < listTiposPagos.length ; cont++){
            listTiposPagosMostar.add(new DropdownMenuItem(
                value: listTiposPagos[cont]['id'].toString(),
                child: new Text(" "+listTiposPagos[cont]['nombre'])
            ));
          }
        }

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




        
        this.identificador = clienteSeleccionado['personaNumeroIdentificacion'];
        identificacion ="${this.tipoidentificador}" +" " +"${this.identificador}";
        this.email = clienteSeleccionado['userEmail'];
        
        this.tipoDocumento = documentoSeleccionado['tipo'];
        this.numeroDocumento = documentoSeleccionado['numero'];
        this.nombreDocumento = "${this.tipoDocumento}"+" "+"${this.numeroDocumento}";
        this.vencimientoDocumento = documentoSeleccionado['fechavencimiento'];
        this.importeDocumento = documentoSeleccionado['importe'];
        this.saldoDocumento = documentoSeleccionado['saldo'];
        this.partesSaldo[2] = "${moneyType.format(double.parse(saldoDocumento))}"; 
        DateTime today = new DateTime.now();
        List fechaVencSeparada = vencimientoDocumento.split("-");
        
        var ano = int.parse(fechaVencSeparada[0]);
        var mes = int.parse(fechaVencSeparada[1]);
        var dia = int.parse(fechaVencSeparada[2]);

        this.data = listPagos;
        this.codes = code;
        if(codes){
          cantPagos = this.data.length;
        }else{
          cantPagos = 0;
        }
        
        var fechaVencida = new DateTime.utc(ano,mes, dia+1);
        Duration difference = today.difference(fechaVencida);
        vencida = difference.inDays;

        
        
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











  String tipoPagoSeleccionado = "EFE";
  String tipoPagoSeleccionadoVista = "EFECTIVO";
  String tipoMonedaSelect = "PEN";
  int selectPago = 1;
  int selectMoneda = 5;

  Widget _tiposPagos(String nombre,   int id, String codigoTipoPago ){
    var x = 0xff5893d4;
    if(id == selectPago || id == selectMoneda){
      x = 0xff1f3c88;
    }
    
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: (){
                
                setState(() {
                  if(id > 4){
                    
                    tipoMonedaSelect = nombre; 
                    selectMoneda = id;


                  }else{
                    tipoPagoSeleccionadoVista = nombre;
                    tipoPagoSeleccionado = codigoTipoPago; 
                    selectPago = id;
                    
                  }
                 
                });
                
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                modalAddPago(context);

              },
              textColor: Colors.white,
              color: Color(x),
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                nombre,
              ),
            ),
          );
  }

  void _selectTipoPago() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 150.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('SELECCIONAR TIPO DE PAGO', 
                              style: TextStyle(
                                            color: Colors.white, 
                                            fontFamily: 'illapaBold', 
                                            fontSize: 15.0
                                            ),
                                  )
                    ),
                    Wrap(
                          children: <Widget>[
                              _tiposPagos("EFECTIVO",  1 , "EFE" ),
                              _tiposPagos("CHEQUE",   2 , "CHE" ),
                              _tiposPagos("DEPOSITO",   3 , "DEP" ),
                              _tiposPagos("TRANSFERENCIA",   4 , "TRA" ),
                              
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
                              _tiposPagos("PEN", 5 , "" ),
                              _tiposPagos("USD", 6 , "" ),
                              _tiposPagos("EUR", 7 , "" ),
                              
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }

  TextEditingController nombreFactura = TextEditingController();
  TextEditingController importeFactura = TextEditingController();
  List<DropdownMenuItem<String>> listTiposPagosMostar = new List();
  String tipoPagoSeleccionadoDrop = '1';

  void seleccionarIdentidad(String tipoPagoValue) {
    Navigator.of(context).pop();
    print(tipoPagoValue);
    setState(() {
      tipoPagoSeleccionadoDrop = tipoPagoValue;
    });
    modalAddPago(context);
  }

  Future<bool> modalAddPago(context) {
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
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Agregar un nuevo pago', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Tipo de pago', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(
                                      color: Colors.white,
                                      child: DropdownButton(
                                        
                                        isExpanded: true,
                                        value: tipoPagoSeleccionadoDrop,
                                        items: listTiposPagosMostar,
                                        onChanged: seleccionarIdentidad,

                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    Text('Numero del pago', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(              
                                      height: 45,
                                      child: TextField(
                                              controller: nombreFactura,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  
                                                fillColor: Colors.white,
                                                filled: true,
                                                
                                              ),
                                            ),
                                    ),
                                    
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  ), textAlign: TextAlign.center,),
                                              GestureDetector(
                                                // onTap: _selectMoneda,
                                                child: Container(
                                                  color: Colors.white,
                                                  height: 30.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 10.0),
                                                        child: Text('$tipoMonedaSelect')
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
                                              
                                              Text('Importe', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                              Container(              
                                                  height: 33,
                                                  child: TextField(
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
                                        child: Text('Agregar', style: TextStyle(color: Colors.white)),
                                        onPressed: (){

                                          if(nombreFactura.text.length > 0 && importeFactura.text.length >0  ){

                                            _agregarPago();
                                            Navigator.of(context).pop();
                                            _cargandoAgregarDocumento('Creando Pago');
                                            setState(() {
                                             faltanLlenarCampos = false; 
                                            });
                                          }else{
                                            setState(() {
                                              faltanLlenarCampos = true;
                                              Navigator.of(context).pop();
                                              modalAddPago(context);
                                            });
                                          }

                                          
                                        },
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              )
                                
                              
                            ],
                          )
                    ],
                  ),
                ),
              
            );
        });
  }







  void selectTipoPagoEditar(String tipoPagoValue) {
    Navigator.of(context).pop();
    setState(() {
      tipoPagoSeleccionadoDrop = tipoPagoValue;
    });
    modalEditPago(context);
  }

  TextEditingController numeroPagoEditar = TextEditingController();
  TextEditingController importePagoEditar = TextEditingController();
  
  Future<bool> modalEditPago(context, ) {
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
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Editar un pago', 
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontFamily: 'illapaBold', 
                                              fontSize: 20.0, ), textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Tipo de pago', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(
                                      color: Colors.white,
                                      child: DropdownButton(
                                        
                                        isExpanded: true,
                                        value: tipoPagoSeleccionadoDrop,
                                        items: listTiposPagosMostar,
                                        onChanged: selectTipoPagoEditar,

                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    Text('Numero del pago', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                    Container(              
                                      height: 45,
                                      child: TextField(
                                              controller: numeroPagoEditar,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  
                                                fillColor: Colors.white,
                                                filled: true,
                                                
                                              ),
                                            ),
                                    ),
                                    
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                    ),
                                    
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  ), textAlign: TextAlign.center,),
                                              GestureDetector(
                                                // onTap: _selectMoneda,
                                                child: Container(
                                                  color: Colors.white,
                                                  height: 30.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 10.0),
                                                        child: Text('$tipoMonedaSelect')
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
                                              
                                              Text('Importe', 
                                                style: 
                                                  TextStyle(
                                                    color: Colors.white, 
                                                    fontFamily: 'illapaBold', 
                                                    fontSize: 16.0, 
                                                  ), textAlign: TextAlign.center,),
                                              Container(              
                                                  height: 33,
                                                  child: TextField(
                                                          controller: importePagoEditar,
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
                                                  onTap:_selectFechaEmisionEditar,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.0),
                                                          
                                                          child: Text(
                                                            '${_dateEmisionEditar.year}-${_dateEmisionEditar.month.toString().padLeft(2, '0')}-${_dateEmisionEditar.day.toString().padLeft(2, '0')}')
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
                              if(faltanLlenarCamposEditar)
                                Text('Faltan llenar campos', 
                                  style: TextStyle(color: Colors.red, fontFamily: 'illapaBold', fontSize: 15.0, ), 
                                  textAlign: TextAlign.center,),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: RaisedButton(
                                        color: Color(0xfff7b633),
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Editar', style: TextStyle(color: Colors.white)),
                                        onPressed: (){
                                          if(numeroPagoEditar.text.length > 0 && importePagoEditar.text.length >0  ){
                                            _editarPago();
                                            Navigator.of(context).pop();
                                            _cargandoAgregarDocumento('Editando Pago');
                                            setState(() {
                                             faltanLlenarCamposEditar = false; 
                                            });
                                          }else{
                                            setState(() {
                                              faltanLlenarCamposEditar = true;
                                              Navigator.of(context).pop();
                                              modalEditPago(context);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                    ],
                  ),
                ),
              
            );
        });
  }



























  Future<void> _cargandoAgregarDocumento(String texto) async {
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
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>DatoDocumentoPage(
                          idAnterior: widget.idAnterior,
                          tipoUsuario: widget.tipoUsuario,

                          value: widget.valuePageDocumento,
                          nombre: widget.nombre,
                          imagen: widget.imagen,
                          identificacion: widget.identificacion,
                      )));
                
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
            imagenUsuario: imagenUsuarioSelect,
            nombre : nombreUsuario
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
                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                          ),
                          Text(
                            'CLIENTE',
                            style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                          ),
                        ],
                      ),
                    ),
                    editarPago == false
                    ?IconButton(
                          icon: Icon(FontAwesomeIcons.pencilAlt, color: Colors.white,),
                          onPressed: () {
                            setState(() {
                             editarPago = true; 
                            });
                          }
                        )
                    :IconButton(
                          icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                          onPressed: () {
                            setState(() {
                             editarPago = false; 
                            });
                          }
                        )
                  ],
                ),
              ),
            ),
            
            Container(
              color: Colors.black,
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
                                      
                                      "$nombreDocumento",
                                      style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                    ),
                                    Text(
                                      'Vencimiento $vencimientoDocumento',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      '$vencidaPagadaVigente $nuevaVencida días',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      "${partesSaldo[0]} ${partesSaldo[1]} ${partesSaldo[2]}",
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    if(editarPago == true)
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            vencida < 0
                                            ?Text('${widget.tipomoneda} ${moneyType.format(double.parse(importeDocumento))}', style: TextStyle(color: Colors.black, fontFamily: 'illapaBold'))
                                            :Text('${widget.tipomoneda} ${moneyType.format(double.parse(importeDocumento))}', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold')),
                                          ],
                                        )
                                      ),
                                  ],
                                ),
                              ),
                              editarPago == true
                                  ?Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.pencilAlt, color: Colors.white,),
                                        onPressed: () {
                                          
                                          setState(() {
                                            editandoDoc = true;
                                            editandoPago = false;
                                            documentoSeleccionado = widget.idTipoDocumento;
                                            numeroFacturaEditDoc.text = widget.numeroDocumento;
                                            monedaSeleccionada = widget.idTipoMoneda;
                                            importeFacturaEditDoc.text = widget.importe;
                                            _dateEmisionEditar = DateTime.parse(widget.fechaEmision);
                                            _dateVencimientoEditarDoc = DateTime.parse(widget.fechaVencimiento);

                                            //miomio

                                          });
                                          modalEditDocumento(context);
                                        }
                                      ),
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.trashAlt, color: Colors.redAccent,),
                                        onPressed: () {
                                          setState(() {
                                            modalEliminarDocumento(context);
                                          });
                                        }
                                      )
                                    ],
                                  )
                                  :Container(
                                      child: Row(
                                        children: <Widget>[
                                          vencida < 0
                                          ?Text('${widget.tipomoneda} ${moneyType.format(double.parse(importeDocumento))}', style: TextStyle(color: Colors.black, fontFamily: 'illapaBold'))
                                          :Text('${widget.tipomoneda} ${moneyType.format(double.parse(importeDocumento))}', style: TextStyle(color: Colors.red, fontFamily: 'illapaBold')),
                                        ],
                                      )
                                    ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    width: 5.0,
                    color: Color(0xfff7b633),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xff070D59),
                      child: Column(
                        children: <Widget>[


                          for(var cont =0; cont<cantPagos; cont++ )
                          _buildListPagos(  data[cont]['idPago'],
                                            data[cont]['idTipoPago'],
                                            "${data[cont]['tipo']}",
                                            "${data[cont]['numero']}",
                                            data[cont]['fechavencimiento'],  
                                            data[cont]['importe']),
                          
                          
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
          setState(() {
            importeFactura.text = "$saldoDocumento";
            tipoPagoSeleccionadoDrop = "1";
          });
          modalAddPago(context);
        },
        tooltip: 'Agregar un pago',
        
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Future<bool> modalEliminarDocumento(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 170.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de eliminar este Documento?', 
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
                                  child: Text('Eliminar', 
                                    style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), 
                                    textAlign: TextAlign.center,),
                                  onPressed: (){
                                    _eliminarDocumento();
                                    
                                    Navigator.of(context).pop();
                                    _cargandoAgregarDocumento('Elimando Documento');
                                    
                                  },
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

  _eliminarDocumento() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    final url =
        "$urlDato/eliminarDocumento";
    print(url);
    print(apiToken);
    
    final response = await http.post(url, body: {
                    "api_token": apiToken,
                    "documentoId": "${widget.value}",
                  });
    print(response.body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);  
      final estado = map["load"];

      if(estado){
        Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>DatoDocumentoPage(
                          idAnterior: widget.idAnterior,
                          tipoUsuario: widget.tipoUsuario,

                          value: widget.valuePageDocumento,
                          nombre: widget.nombre,
                          imagen: widget.imagen,
                          identificacion: widget.identificacion,
                      )));
      }else{
        Navigator.of(context).pop();
      }
    } 
  
  }



}


