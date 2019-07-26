import 'package:flutter/material.dart';
import 'package:illapa/behaviors/hiddenScrollBehavior.dart';
import 'package:illapa/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ConfirmacionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _ConfirmacionPageState();
}

class _ConfirmacionPageState extends State<ConfirmacionPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _passowrd;




  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      key: _scaffoldKey,
      body: Container(
        
        padding: EdgeInsets.all(30.0),
      
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/fondo.jpeg"),
            fit: BoxFit.cover
          ),
        ),
        child: ScrollConfiguration(
          behavior: HiddenScrollBehavior(),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                LogoImg(),
                Container(
                  padding: EdgeInsets.only(top: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Introduce tu correo electrónico y contraseña para enviar el correo de confirmación.\n',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
                      Text('Correo Electronico',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
                      Container(
                        height: 33.0,
                        child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (val){
                              if(val.isEmpty){
                                return 'email incorrecto';
                              }else{
                                return null;
                              }
                            },

                            onSaved: (val){
                              setState((){
                                _email = val;
                              });
                            },
                          ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),  

                      Text('Contraseña',  style: TextStyle(color: Colors.white, fontFamily: 'illapaBold',),),
                      Container(
                        height: 33.0,
                        child: TextFormField(
                            controller:  contrasena,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (val){
                              if(val.isEmpty){
                                return 'Falta la contraseña';
                              }else{
                                return null;
                              }
                            },
                             
                             
                            
                          ),
                      ),
                      




                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new RaisedButton(
                          child: new Text("Enviar"),
                          color: Color(0xffF7B633), 
                          onPressed: (){
                            _enviarConfirmacion();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text('Cancelar', style: TextStyle(color: Colors.black,)),
                          color: Colors.grey,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                
                
                
                
                
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                ),
                
                

              ],
            ),
          ),
        ),
      )
    );
  }

  TextEditingController email = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  _enviarConfirmacion() async{
    
    FirebaseUser  user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: contrasena.text);
    
    if(user.isEmailVerified){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Tu correo ya fue validado'),
      ));
    }else{
      await user.sendEmailVerification();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Se te envío el correo de confirmación '),
      ));
    }
    
    
  }

}