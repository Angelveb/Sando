import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/componentes/my_button.dart';
import 'package:login/componentes/my_text_field.dart';
import 'package:login/componentes/square_tile.dart';
import 'package:login/services/auth.service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para el texto
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // Autenticacion del usuario
  void signUserIn() async {

    // Mostrar circulo de carga
    showDialog(
      context: context,
      builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
     }
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
      );
      // desaparecer circulo de carga
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // desaparecer circulo de carga
      Navigator.pop(context);
      // usuario incorrecto
      if (e.code == 'user-not-found'){
        //print('Usuario incorrecto');
        wrongEmailMessage();
      }
      // Constraseña incorrecta
      else if (e.code == 'wrong-password') { 
        wrongPasswordMessage();
      }
    } 
    }

  // Mensaje de correo incorrecto
  void wrongEmailMessage(){
    showDialog(
      context: context, 
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.teal,
          title: Center(
            child: Text('Correo incorrecto',
            style: TextStyle(color: Colors.white),
            ),
            ),
          );
      }
      );
  }

  // Mensaje de contraseña incorrecta
  void wrongPasswordMessage(){
    showDialog(
      context: context, 
      builder: (context) {
        return const AlertDialog(
          title: Text('Contraseña incorrecta'),
          );
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:  SafeArea( 
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const  SizedBox(height: 8),
                  
                // logo 
                ClipOval(
                    child: SizedBox(
                      height: 120.0,
                      width: 120.0,
                      child: Image.asset('lib/imagenes/sando.jpeg'),
                    ),
                  ),
          
                const SizedBox(height: 13),           
          
                // Titulo de la app
                const Text('SANDO',
                style: TextStyle(
                color: Color(0xFF592a2f),
                fontSize: 25,
                fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 30),   
          
                // Bienvenido de nuevo
          
                Text('Bienvenido de nuevo te hemos extrañado',
                style: TextStyle(color:Colors.grey[700],
                fontSize: 16,
                ),
                ),
          
                const SizedBox(height: 25),
                
                // Correo electronico texfield
          
                MyTextField(
                  controller: emailController,
                  hintText: 'Correo',
                  obscuredText: false,
                ),
          
                const SizedBox(height: 14),
          
                // contraseña
          
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscuredText: true,
                ),
              
                const SizedBox(height: 10),
                
                // olvido la contraseña
                
                const SizedBox(height: 25),
          
                // Botono de iniciar sesion
          
                MyButton(
                  text: ('Iniciar'),
                  onTap: signUserIn,
                ),
          
                const SizedBox(height: 50),
                
                // O ingrese con
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                      ),           
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('O ingrese con', 
                        style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // iniciar con botones google / apple
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //boton google
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/imagenes/google.png'
                    ),
          
                  const SizedBox(width: 25),
          
                  //boton apple
                  SquareTile(
                    onTap: (){},
                    imagePath: 'lib/imagenes/apple.png'
                    ),
                ],
                ),
          
                 const SizedBox(height: 40),
                
                // Registrarse ahora
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No está registrado?',
                    style: TextStyle(color: Colors.grey[700]),
                      ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Registrese ahora',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
              ),
          ),
        ),
      )
    );
  }
}