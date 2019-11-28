import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illapa/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UsuarioAgregarSectorPage extends StatefulWidget {
  @override
  _UsuarioAgregarSectorPageState createState() => _UsuarioAgregarSectorPageState();
}

class _UsuarioAgregarSectorPageState extends State<UsuarioAgregarSectorPage> {

 DateTime _dateVencimiento;
 bool selectSectorista = false;



 Widget _sectores(String sector){
    return Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: (){},
              textColor: Colors.white,
              color: Color(0xff5893d4),
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                sector,
              ),
            ),
          );
  }

 void _selectSectores() {
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
                      child: Text('SELECCIONAR SECTORES', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 15.0),)
                    ),
                    Wrap(
                          children: <Widget>[
                            _sectores('sector 1'),
                            _sectores('sector 2'),
                            _sectores('sector 3'),
                            _sectores('sector 4'),
                            _sectores('sector 5'),
                            _sectores('sector 6'),
                            _sectores('sector 7'),
                            _sectores('sector 8'),
                            _sectores('sector 9'),
                          ],
                        )
                    
                  ],
                ),
              ],
            )
          );
        });
    }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVariables();
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
 
   
 
       
  Future<bool> modalAddDocumento(context, ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 190.0,
                color: Color(0xFF070D59),
                padding: EdgeInsets.all(10.0),
                
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('¿Estás seguro de agregar este nuevo usuario?', style: TextStyle(color: Colors.white, fontFamily: 'illapaBold', fontSize: 20.0, ), textAlign: TextAlign.center,),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              
                              Expanded(
                                child: RaisedButton(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Agregar'),
                                  onPressed: (){},
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Expanded(
                                child: 
                                RaisedButton(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Cancelar'),
                                  onPressed: (){},
                                )
                              )
                            ],
                          ),
                        )
                          
                        
                      ],
                    ),
                ),
              
            );
        });
  }
 

Widget _buildUsuariosAsignados(String imagen, String nombre, int dniRuc, String correo, String usuario){
  return GestureDetector(
    // onTap: (){
    //   _selectSectores();
    // },
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
                        backgroundImage: new NetworkImage(imagen),
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
                                style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                              ),
                              Text(
                                'RUC: $dniRuc',
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
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                            
                              IconButton(
                                icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                // onPressed: () => Navigator.push(
                                //                     context, 
                                //                     MaterialPageRoute(
                                //                       builder: (BuildContext context ) => DatoPagosPage()
                                //                     )
                                //                   ),
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

  Widget _buildSectoresSelccionados(String imagen, String titulo, int contSelectsSectores){
    return GestureDetector(
      onTap: (){
        _selectSectores();
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
                          backgroundImage: new NetworkImage(imagen),
                        ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  titulo,
                                  style: new TextStyle(fontFamily: 'illapaBold', color: Colors.white,fontSize: 15.0 ),
                                ),
                                for(var x= 1; x<=contSelectsSectores; x++)
                                  Text(
                                    'Sector$x',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                  ),
                                
                                
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '$contSelectsSectores',
                                  style: new TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'illapaMedium'),
                                ),
                                // IconButton(
                                //   icon: Icon(FontAwesomeIcons.angleRight, color: Colors.white,),
                                //   // onPressed: () => Navigator.push(
                                //   //                     context, 
                                //   //                     MaterialPageRoute(
                                //   //                       builder: (BuildContext context ) => DatoPagosPage()
                                //   //                     )
                                //   //                   ),
                                // )
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
  int contSectores = 1;
  


Widget _buildCrearSectores( int cont, String tipo, int y){
  
  return 
    Container(
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
                                for(var x = 0; x< cont ; x++)
                                TextField(
                                  decoration: InputDecoration(
                                    // fillColor: Colors.white,
                                    filled: true,
                                    // hintText: "Illapa@hotmail.com",
                                    labelText: tipo,
                                  ),
                                ),
                                
                              ],
                            ),
                          ),

                          if(y == 1)
                            Container(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                  icon: Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                  onPressed: (){
                                    setState(() {
                                      contSectores = contSectores+1;
                                    });
                                  },
                                ),
                                IconButton(
                                      icon: Icon(FontAwesomeIcons.minus, color: Colors.white,),
                                      onPressed: (){
                                        setState(() {
                                          if(contSectores > 1)
                                          contSectores = contSectores-1;
                                        });
                                      },
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
      )
  );
                  
}




  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Usuarios'),
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
              padding: EdgeInsets.all(10.0),
              color: Color(0xff1f3c88),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 90.0,
                    height: 70.0,
                    child: Image.asset('assets/img/user.jpg'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0)
                  ),
                  Container(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Joses Ticona Saire Savedra', style: TextStyle( fontFamily: 'illapaBold', fontSize: 20.0, color: Colors.white ),),
                          Text('DNI: 73819654', style: TextStyle( fontFamily: 'illapaMedium', fontSize: 15.0 ),),
                          
                        ],
                      ),
                    ),
                  ),
                  

                ],
              ),
            ),
            
            
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  Expanded(
                    child: Container(
                      color: Color(0xff070D59),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('EMPRESA', 
                              textAlign: TextAlign.right,
                              style: 
                                TextStyle(
                                  color: Color(0xfff7b633),
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0
                                  
                                ),
                            ),
                          ),
                          _buildUsuariosAsignados('https://cdn.pixabay.com/photo/2016/02/19/10/56/man-1209494_1280.jpg', 'EMPRESA 1',73819654, 'empresa@hotmail.com', 'usuario'),
                          
                          

                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('SECTORES', 
                              textAlign: TextAlign.right,
                              style: 
                                TextStyle(
                                  color: Color(0xfff7b633),
                                  fontFamily: 'illapaBold',
                                  fontSize: 15.0
                                  
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
                                ),
                                Expanded(
                                  child: Container(
                                    // color: Colors.black,
                                    color: Color(0xff070D59),
                                    child: Column(
                                      children: <Widget>[
                                        _buildCrearSectores(contSectores, 'Sector', 1 ),
                                        
                                      ],
                                    ),
                                    
                                  ),
                                )
                              ],
                            )
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 80.0),
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
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          modalAddDocumento(context);
        },
        tooltip: 'Agregar usuario',
        
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }
  
   


}


 


