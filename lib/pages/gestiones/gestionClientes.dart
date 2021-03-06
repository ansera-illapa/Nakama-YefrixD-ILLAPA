import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:illapa/extras/appTema.dart';
import 'package:illapa/extras/globals/variablesGlobales.dart';
import 'package:illapa/pages/gestiones/gestionCliente.dart';
import 'package:illapa/widgets.dart';


import 'package:illapa/extras/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestionClientesPage extends StatefulWidget {
  final int value;
  final String nombre;
  final String imagen;
  final int numeroDocumentos;
  final String sumaImportesDocumentos;
  final int numeroDocumentosVencidos;
  final String sumaImportesDocumentosVencidos;

  GestionClientesPage({Key key, this.value,
                                this.nombre,
                                this.imagen,
                                this.numeroDocumentos,
                                this.sumaImportesDocumentos,
                                this.numeroDocumentosVencidos,
                                this.sumaImportesDocumentosVencidos}) : super(key: key);
  
  @override
  _GestionClientesPageState createState() => _GestionClientesPageState();

}

class _GestionClientesPageState extends State<GestionClientesPage> {

  bool _buscar = false;
  bool _sectorSelect = false;
  bool _gestorSelect = false;
  String textoBusqueda = '' ;
  bool ordenAZ = true;
  bool ordenZA = false;
  bool orden19 = false;
  bool orden91 = false;
  var moneyType = new NumberFormat("#,##0.00", "en_US");

  Widget _buildListGestionEmpresas(String imagen, 
                                    String nombre, 
                                    int numeroDocumentos, 
                                    String sumaImportesDocumentos, 
                                    int numeroDocumentosVencidos, 
                                    String sumaImportesDocumentosVencidos, 
                                    int idCliente){
    return 
      GestureDetector(
        onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context ) => GestionClientePage(
                          value: idCliente,
                          nombreCliente:nombre,
                          imagenCliente: urlImagenes+imagen,
                          numeroDocumentosVencidos: numeroDocumentosVencidos,
                          sumaImportesVencidos: "$sumaImportesDocumentosVencidos",
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
                          leading: new CircleAvatar(
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey,
                            backgroundImage: new NetworkImage(urlImagenes+imagen),
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      nombre,
                                      style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0  ),
                                    ),
                                    Text(
                                      '$numeroDocumentos registros por ${moneyType.format(double.parse(sumaImportesDocumentos))}',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                    Text(
                                      '$numeroDocumentosVencidos vencidos por ${moneyType.format(double.parse(sumaImportesDocumentosVencidos))}',
                                      style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                    ),
                                  ],
                                ),
                              ),
                              new IconButton(
                                    icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                    onPressed: () => Navigator.push(
                                                        context, 
                                                        MaterialPageRoute(
                                                          builder: (BuildContext context ) => GestionClientePage(
                                                            value: idCliente,
                                                            nombreCliente:nombre,
                                                            imagenCliente: urlImagenes+imagen,
                                                            numeroDocumentosVencidos: numeroDocumentosVencidos,
                                                            sumaImportesVencidos: "$sumaImportesDocumentosVencidos",
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
          )
      );
  }



  Widget _sectores(String sector, int cont, bool select,  int idSector, int cant){
    var x = 0xff5893d4;
    if(select == true){
      x = 0xff1f3c88;
    }

    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: (){
                
                setState(() {
                  if(sectorSeleccionado[cont] == true){
                    // DEJAMOS DE SELECCIONAR UN SECTOR
                    if(cant > 0){
                      cantSectoresSeleccionados = cantSectoresSeleccionados-1;
                    }
                    
                    sectorSeleccionado[cont] = false;
                    Navigator.of(context).pop();
                    _mostrarSectores();
                    print("cantidad: $cantSectoresSeleccionados");
                  }else{
                    // SELECCIONAMOS UN SECTOR
                    nombresSectoresSeleccionados[cantSectoresSeleccionados] = idSector;
                    cantSectoresSeleccionados = cantSectoresSeleccionados+1;
                    
                    _getSectores();
                    Navigator.of(context).pop();
                    _mostrarSectores();
                    sectorSeleccionado[cont] = true;
                    sectorNombre = sector;
                    codSectorSeleccionado = idSector;
                    print("cantidad: $cantSectoresSeleccionados");

                  }
                  
                });
                print(sectorSeleccionado[cont]);
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

  // int sectorSeleccionado = new(99);
  var nombresSectoresSeleccionados = new List(99);
  var sectorSeleccionado = new List(99);
  String sectorNombre = '';
  int codSectorSeleccionado;
  int cantSectoresSeleccionados = 0;

  void _mostrarSectores() {

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 300.0,
            color: Color(0xFF070D59),
            child: ListView(
              
              children: <Widget>[
                Column(
                
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('FILTROS POR SECTORES', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                            for(var cont =0; cont < cantSectores; cont++ )
                              sectorSeleccionado[cont] == true
                              ?_sectores(dataSectores[cont]['descripcion'], cont, true , dataSectores[cont]['id'], cantSectoresSeleccionados )
                              :_sectores(dataSectores[cont]['descripcion'], cont, false, dataSectores[cont]['id'], cantSectoresSeleccionados ),

                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }






  void _mostrarFiltros() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 100.0,
            color: Color(0xFF070D59),
            child: Container(
              
              child: Column(
                
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text('FILTROS', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                  ),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      
                      
                      cantSectoresSeleccionados > 0

                      // UNO O VARIOS SECTORES SELECCIONADOS
                      ?Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              _mostrarSectores();
                              setState(() {
                                  
                                  _sectorSelect = false;
                              });
                            },
                            textColor: Colors.white,
                            color: Color(0xff1f3c88),
                            // padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "Sector",
                            ),
                          ),
                        )
                      )

                      // NINGUN SECTOR SELECCIONADO
                      :Expanded(
                        
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            onPressed: (){
                              
                              Navigator.of(context).pop();
                              _mostrarSectores();
                              setState(() {
                                  _sectorSelect = true;
                                  _gestorSelect = false;
                                  
                              });
                            },
                            textColor: Colors.white,
                            color: Color(0xff5893d4),
                            // padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "Sector",
                            ),
                          ),
                        )
                      ),
                      


                      _gestorSelect

                      ?Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child:RaisedButton(
                              onPressed: (){
                                setState(() {
                                  _gestorSelect = false;
                                });
                                Navigator.of(context).pop();
                              },
                              textColor: Colors.white,
                              
                              color: Color(0xff1f3c88),
                              // padding: const EdgeInsets.all(8.0),
                              child: new Text(
                                "Gestor",
                              ),
                            ),
                          )
                        )

                      :Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child:RaisedButton(
                              onPressed: (){
                                setState(() {
                                  _gestorSelect = true  ;
                                  _sectorSelect = false;
                                });
                                Navigator.of(context).pop();
                              },
                              textColor: Colors.white,
                              color: Color(0xff5893d4),
                              // padding: const EdgeInsets.all(8.0),
                              child: new Text(
                                "Gestor",
                              ),
                            ),
                          )
                        )
                    ],
                  )
                  
                ],
              ),
            )
          );
        });
    }



  var data;
  String nombreSocio = '';
  String imagenSocio = '';
  int numeroDocumentos = 0;
  String sumaImportesDocumentos = '0.00';
  int numeroDocumentosVencidos = 0;
  String sumaImportesDocumentosVencidos = '0.00';

  int cantClientes = 0;
  bool codes;
  bool _isLoading = false;
  int pagina = 1;
  
  _getClientes(String buscarNombreCliente, int numeroPagina ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    // print(apiToken);
    final url =
        "$urlGlobal/api/clientesTodos/${widget.value}/$buscarNombreCliente?api_token="+apiToken+"&page="+"$numeroPagina";
    print(url);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionClientesData${widget.value}.json');
      await fileData.writeAsString("${response.body}");
      await _getVariables();
    }
  }

  int orderAZ(var a,var b){
    return a.compareTo(b);
  }

  int order19(String a,String b){
    int numeroA = double.parse(a).round();
    int numeroB = double.parse(b).round();
    if(numeroA < numeroB){
      return -1;
    }
    if(numeroA > numeroB){
      return 1;
    }
    return 0;
  }


  Widget _loading(){
      barrierDismissible: true;
      return Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                ),
              );
    
  }

  var dataSectores;
  int cantSectores = 0;

  
  _getSectores() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/api.txt');
    String apiToken = await file.readAsString();
    

    final url =
        "$urlGlobal/api/sectoresTodos/${widget.value}?api_token="+apiToken;
        // "$urlGlobal/sectoresTodos/${widget.value}?api_token="+apiToken;
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {

      final map = json.decode(response.body);
      final code = map["code"];
      final load = map["load"];
      final listSectores = map["sectores"];

      setState(() {
        this.dataSectores = listSectores;
        cantSectores = this.dataSectores.length;
      });
        
    }
    
  }

  final scrollController = ScrollController();

  @override
  void initState() {
    setState(() {
      // VARIABLES GLOBALES PARA PINTAR DATOS
      if(pagGestGestClientesDataGlobal[0]['${widget.value}'] != null ){
        data                = pagGestGestClientesDataGlobal[0]['${widget.value}'];
        cantClientes          = data.length;
        if(cantClientes > 0){
          _isLoading = true;
        }
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
            print('jalaaa');
            setState(() {
              _isLoading = false;
             pagina = pagina+1; 
            });
            if(textoBusqueda == ''){
              _getClientes(null, pagina);
            }else{
              _getClientes(textoBusqueda, pagina);
            }

            print(pagina);
      }
    });

    if(widget.nombre != null){
      nombreSocio = widget.nombre;
      imagenSocio = widget.imagen;
      numeroDocumentos = widget.numeroDocumentos;
      sumaImportesDocumentos = widget.sumaImportesDocumentos;
      numeroDocumentosVencidos = widget.numeroDocumentosVencidos;
      sumaImportesDocumentosVencidos = widget.sumaImportesDocumentosVencidos;
    }

    // TODO: implement initState
    super.initState();
    _getClientes(null, 1);
    _getVariables();
    _getSectores();
  }

  int tipoUsuario;
  int idUsuario;
  String imagenUsuario;
  String nombreUsuario;
  
  _getVariables() async {
      final directory = await getApplicationDocumentsDirectory();
      final fileData = File('${directory.path}/pagGestGestionClientesData${widget.value}.json');
      try{
        print(await fileData.readAsString());
        final map = json.decode(await fileData.readAsString());
        final code = map["code"];
        final socioSeleccionado = map["socio"];
        final socioVencido = map["socioVencido"];
        final listClientes = map["result"];
        final load = map["load"];
        // print(socioSeleccionado['nombre']);
        print("CODIGO:"+"$code");
        setState(() {
          this._isLoading = load;
          this.nombreSocio = socioSeleccionado['personaNombre'];
          this.imagenSocio = socioSeleccionado['personaImagen'];
          this.numeroDocumentos = socioSeleccionado['numeroDocumentos'];
          this.sumaImportesDocumentos = socioSeleccionado['sumaImportesDocumentos'];

          this.numeroDocumentosVencidos = socioVencido['numeroDocumentosVencidos'];
          this.sumaImportesDocumentosVencidos = socioVencido['sumaImportesDocumentosVencidos'];
          
          if(code){
            cantClientes = listClientes.length;
            // VARIABLES GLOBALES PARA PINTAR DATOS
            pagGestGestClientesDataGlobal[0]['${widget.value}'] = this.data;
          }else{
            print("no hay datos");
          }

          if(data == null){
            this.data = listClientes;
          }else{
            if(listClientes == null){
              print("Ya no hay mas");
            }else{
              this.data += listClientes;
            }
            
          }
          
          // print("--------------------------------");
          // print(listClientes);
          // print(listClientes.length);

          // this.codes = code;
          
          
        });


        
      }catch(error){
        print(error);
      }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        
      },
      child: new Scaffold(
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
                              ],
                            ),
                          ),
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
                        if(text == ''){
                          _getClientes(null, 1);
                        }else{
                          _getClientes(text, 1);
                        }
                        
                        setState(() {
                            textoBusqueda = text;
                            print(textoBusqueda);
                        });
                      },
                    ),
                  ),
                ),

              Container(
                color: Color(0xfff7b633),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 5.0,
                      color: Color(0xfff7b633),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.black,
                        color: Color(0xff070D59),
                        child: Column(
                          children: <Widget>[
                            
                            if(cantSectoresSeleccionados == 0)
                              for(int cont =0; cont < cantClientes; cont++ )
                                if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1)
                                  if(data[cont]['numeroDocumentosVencidos'] > 0)
                                    _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                              data[cont]['personaNombre'], 
                                                              data[cont]['numeroDocumentos'], 
                                                              data[cont]['sumaImportesDocumentos'], 
                                                              data[cont]['numeroDocumentosVencidos'], 
                                                              data[cont]['sumaImportesDocumentosVencidos'], 
                                                              data[cont]['clienteId']),
                            
                            if(cantSectoresSeleccionados > 0) //MIOMIO
                              for(var cont =0; cont < cantClientes; cont++ )
                                for(var contAr =0; contAr < cantSectoresSeleccionados; contAr++ )
                                  if(nombresSectoresSeleccionados[contAr] == data[cont]['sectorId'])
                                    if(data[cont]['personaNombre'].indexOf(textoBusqueda.toUpperCase()) != -1 || data[cont]['personaNombre'].indexOf(textoBusqueda.toLowerCase()) != -1)
                                      if(data[cont]['numeroDocumentosVencidos'] > 0)
                                        _buildListGestionEmpresas(data[cont]['personaImagen'], 
                                                                data[cont]['personaNombre'], 
                                                                data[cont]['numeroDocumentos'], 
                                                                data[cont]['sumaImportesDocumentos'], 
                                                                data[cont]['numeroDocumentosVencidos'], 
                                                                data[cont]['sumaImportesDocumentosVencidos'], 
                                                                data[cont]['clienteId']),
                            
                            
                            
                          ],
                          
                        ),
                        
                      ),
                    ),
                    
                  ],
                )
              ),
              if(!_isLoading)
                _loading(),
              Padding(
                padding: EdgeInsets.only(bottom: 40.0),
              )

              
            ],
          ),
        ),
        floatingActionButtonLocation: 
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff1f3c88),
            child: 
              const Icon(
                    FontAwesomeIcons.ellipsisH,
                    ), 
              onPressed: () {
                _mostrarFiltros();
              },
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
                    tooltip: "Ordenar de la Z a la A",
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
                      orden19 = true;
                    });
                    data.sort((a, b) {
                      return orderAZ(a['personaNombre'],b['personaNombre']);
                    });
                  },
                  tooltip: "Ordenar de la A a la Z",
                ),
                if(orden19)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortNumericDown, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      orden19 = false;
                      orden91 = true;
                    });
                    data.sort((a, b) {
                      return order19("${a['sumaImportesDocumentosVencidos']}","${b['sumaImportesDocumentosVencidos']}");
                    });
                  },
                  tooltip: "Ordenar de importe vencido de menor a mayor",
                ),
                if(orden91)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.sortNumericUp, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      orden91 = false;
                      ordenAZ = true;
                    });
                    data.sort((a, b) {
                      return order19("${b['sumaImportesDocumentosVencidos']}","${a['sumaImportesDocumentosVencidos']}");
                    });
                  },
                  tooltip: "Ordenar de importe vencido de mayor a menor",
                )
              ],
            ),
          ),
      ),
    );
    
  }
}


