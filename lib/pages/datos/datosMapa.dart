
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:illapa/pages/datos/datoClienteEditar.dart';
import 'dart:async';

import 'package:illapa/pages/datos/datoNuevo.dart';

class DatosMapaPage extends StatefulWidget{

  final double ubicacionLatitud;
  final double ubicacionLongitud;
  final String nombreUbicacion;
  final int estatus;
  final String nombre;
  final String dnioruc;
  final int clienteId;
  final int sectorId;
  final int socioId; 
  final String tipoIdentidad;
  final String identidad;
  final String imagen;
  final String tipodnioruc;
  final int userId;
  final List pais;
  final List ciudad;
  final List calle;
  final List codPostal;
  final List latitud ;
  final List longitud;
  final int cantDirecciones;
  final int estado;

  DatosMapaPage({
                  this.ubicacionLatitud,
                  this.ubicacionLongitud,
                  this.nombreUbicacion,
                  this.estatus, 
                  this.nombre, 
                  this.dnioruc, 
                  this.clienteId, 
                  this.sectorId, 
                  this.socioId,
                  this.tipoIdentidad,
                  this.identidad,
                  
                  this.imagen,
                  this.tipodnioruc,
                  this.userId,

                  this.pais,
                  this.ciudad,
                  this.calle,
                  this.codPostal,
                  this.latitud,
                  this.longitud,
                  this.cantDirecciones,
                  this.estado,

                  Key key, 
                  }) : super(key: key);

  @override 
  _DatosMapaPageState createState() => _DatosMapaPageState();

}

class _DatosMapaPageState extends State<DatosMapaPage> {
  @override 
  void initState(){
    super.initState();
    _irUbicacionSugerida(widget.ubicacionLatitud, widget.ubicacionLongitud);
    _markers.add(
      Marker(
          markerId: MarkerId('Seleccion'),
          position: LatLng(widget.ubicacionLatitud, widget.ubicacionLongitud),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    setState(() {
      widget.latitud[widget.cantDirecciones] = widget.ubicacionLatitud;
      widget.longitud[widget.cantDirecciones] = widget.ubicacionLongitud; 
      campoPais.text = widget.pais[widget.cantDirecciones];
      campoCodigoPostal.text = widget.codPostal[widget.cantDirecciones];
      campoCiudad.text = widget.ciudad[widget.cantDirecciones];
      campoCalle.text = widget.calle[widget.cantDirecciones];

      print('pais');
      print(widget.pais[widget.cantDirecciones]);
    });
  }

  final Set<Marker> _markers = Set();
  String aviso = "Seleccione un punto";

  Future<void> _irUbicacionSugerida(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414
      )
    ));
  }

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
      -12.752720620680945, -76.62098150700331), 
    zoom: 10);
  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$aviso'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              
              onTap: (pos) {
                
                setState(() {
                  print(pos.latitude  );
                  aviso = "Agrega la Dirección";
                  widget.latitud[widget.cantDirecciones] = pos.latitude;
                  widget.longitud[widget.cantDirecciones] = pos.longitude;
                  _markers.remove(
                    Marker(
                        markerId: MarkerId('Seleccion'),
                        position: pos,
                        
                    ),
                  ); 
                  _markers.add(
                    Marker(
                        markerId: MarkerId('Seleccion'),
                        position: pos,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    ),
                  );
                  
                  
                });
                print("ONTAP: $pos");
              },
              onLongPress: (LatLng pos) {

                print("LONG: $pos");
              },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_markers.length > 0){
              agregarDireccion(context);
            }
        },
        tooltip: 'Agregar Dirección',
          
          child: Icon(FontAwesomeIcons.plus),
      ),
    );  
  }

  bool _validarTexto = false;
  TextEditingController campoPais = TextEditingController();
  TextEditingController campoCodigoPostal = TextEditingController();
  TextEditingController campoCiudad = TextEditingController();
  TextEditingController campoCalle = TextEditingController();
  Future<bool> agregarDireccion(context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 240.0,
                  color: Color(0xFF070D59),
                  padding: EdgeInsets.all(10.0),
                  
                    child: ListView(
                      children: <Widget>[
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text('Agregar dirección', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                                ),
                                Text(widget.nombreUbicacion, style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0, ), textAlign: TextAlign.center,),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        // textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          // Expanded(
                                          //   child: Column(
                                          //     children: <Widget>[
                                          //       Text('País', 
                                          //         style: 
                                          //           TextStyle(
                                          //             color: Colors.white, 
                                          //             fontFamily: 'illapaBold', 
                                          //             fontSize: 16.0, 
                                          //           ), textAlign: TextAlign.center,
                                          //         ),
                                          //         Container(              
                                          //           height: 40,
                                          //           child: TextField(
                                          //                   controller: campoPais,
                                          //                   onChanged: (text){
                                          //                     widget.pais[widget.cantDirecciones] = text;
                                          //                   },
                                          //                   decoration: InputDecoration(
                                                                
                                          //                     fillColor: Colors.white,
                                          //                     filled: true,
                                                             
                                          //                   ),
                                          //                 ),
                                          //         ),
                                          //     ],
                                          //   )
                                          // ),
                                          
                                          // Padding(
                                          //   padding: EdgeInsets.all(2.0),
                                          // ),
                                          // Expanded(
                                          //   child: Column(
                                          //     children: <Widget>[
                                          //       Text('Ciudad', 
                                          //         style: 
                                          //           TextStyle(
                                          //             color: Colors.white, 
                                          //             fontFamily: 'illapaBold', 
                                          //             fontSize: 16.0, 
                                          //           ), textAlign: TextAlign.center,),
                                          //       Container(              
                                          //           height: 40,
                                          //           child: TextField(
                                          //             controller: campoCiudad,
                                          //                   onChanged: (text){
                                          //                     widget.ciudad[widget.cantDirecciones] = text;
                                          //                   },
                                          //                   // keyboardType: TextInputType.number,
                                          //                   decoration: InputDecoration(
                                                                
                                          //                     fillColor: Colors.white,
                                          //                     filled: true,
                                          //                     // hintText: "25000.00",
                                          //                     // labelText: "25000.00",
                                          //                   ),
                                          //                 ),
                                          //         ),
                                          //     ],
                                          //   )
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.all(2.0),
                                          // ),
                                          // Expanded(
                                          //   child: Column(
                                          //     children: <Widget>[
                                          //       Text('Postal', 
                                          //         style: 
                                          //           TextStyle(
                                          //             color: Colors.white, 
                                          //             fontFamily: 'illapaBold', 
                                          //             fontSize: 16.0, 
                                          //           ), textAlign: TextAlign.center,),
                                          //       Container(              
                                          //           height: 40,
                                          //           child: TextField(
                                          //                   controller: campoCodigoPostal,
                                          //                   onChanged: (text){
                                          //                     widget.codPostal[widget.cantDirecciones] = text;
                                          //                   },
                                          //                   keyboardType: TextInputType.number,
                                          //                   decoration: InputDecoration(
                                          //                     fillColor: Colors.white,
                                          //                     filled: true,
                                          //                   ),
                                          //                 ),
                                          //         ),
                                          //     ],
                                          //   )
                                          // ),
                                          
                                        ],
                                      ),
                                     Text('Calle', 
                                                  style: 
                                                    TextStyle(
                                                      color: Colors.white, 
                                                      fontFamily: 'illapaBold', 
                                                      fontSize: 16.0, 
                                                    ), textAlign: TextAlign.center,),
                                      Container(              
                                        child: TextField(
                                            maxLines: 2,
                                            controller: campoCalle,
                                            onChanged: (text){
                                              widget.calle[widget.cantDirecciones] = text;
                                              
                                            },
                                            decoration: InputDecoration(
                                              
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                      ),
                                      if(_validarTexto)
                                        Text('Faltan llenar campos', 
                                          style: TextStyle(
                                                  color: Colors.red, 
                                                  fontFamily: 'illapaBold', 
                                                  fontSize: 15.0, ), textAlign: TextAlign.center,)
                                      
                                      
                                    ],
                                  )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      
                                      Expanded(
                                        child: RaisedButton(
                                          color: Color(0xfff7b633),
                                          padding: EdgeInsets.all(10.0),
                                          child: Text('Agregar', style: TextStyle(color: Colors.white,)), 
                                          onPressed: (){
                                            setState(() {
                                             widget.ciudad[widget.cantDirecciones] = "none";
                                             widget.pais[widget.cantDirecciones] = "none";
                                            });
                                            if(widget.calle[widget.cantDirecciones] != null && widget.ciudad[widget.cantDirecciones] != null && widget.pais[widget.cantDirecciones] != null){

                                              int cantDirecciones;
                                              setState(() {
                                                cantDirecciones = widget.cantDirecciones+1;
                                              });
                                              if(widget.estado == 1){
                                                Navigator.push(
                                                    context, 
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context ) => DatoNuevoPage(
                                                        estatus: widget.estatus,
                                                        nombre: widget.nombre,
                                                        dnioruc: widget.dnioruc,
                                                        clienteId: widget.clienteId,
                                                        sectorId: widget.sectorId,
                                                        socioId: widget.socioId,
                                                        tipoIdentidad: widget.tipoIdentidad,
                                                        identidad: widget.identidad,

                                                        pais: widget.pais,
                                                        ciudad: widget.ciudad,
                                                        calle: widget.calle,
                                                        codPostal: widget.codPostal,
                                                        latitud: widget.latitud,
                                                        longitud: widget.longitud,
                                                        cantDirecciones: cantDirecciones,
                                                      )
                                                    )
                                                  );

                                                }else{
                                                  Navigator.push(
                                                      context, 
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context ) => DatoClienteEditarPage(
                                                          imagen: widget.imagen,
                                                          nombre: widget.nombre,
                                                          tipodnioruc: widget.tipodnioruc,
                                                          dnioruc: "${widget.dnioruc}",
                                                          clienteId: widget.clienteId,
                                                          socioId: widget.socioId,
                                                          userId: widget.userId,

                                                          pais: widget.pais,
                                                          ciudad: widget.ciudad,
                                                          calle: widget.calle,
                                                          codPostal: widget.codPostal,
                                                          latitud: widget.latitud,
                                                          longitud: widget.longitud,
                                                          cantDireccionesAgregadas: cantDirecciones,
                                                        )
                                                      )
                                                    );
                                              }
                                              
                                            }else{
                                              print(_validarTexto);
                                              setState(() {
                                                _validarTexto = true;
                                              });
                                              Navigator.of(context).pop();
                                              agregarDireccion(context);

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
}