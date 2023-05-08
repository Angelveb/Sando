import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/componentes/my_button.dart';
import 'package:login/componentes/my_text_field.dart';
import 'package:login/componentes/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Controladores para el texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Autenticacion del usuario
  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      
      backgroundColor: Colors.grey[300],
      body:  SafeArea( 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const  SizedBox(height: 50),
        
              // logo 
              const Icon(Icons.reddit,
              size: 100,
              ),

              const SizedBox(height: 50),           

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

              const SizedBox(height: 10),

              // contraseña

              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscuredText: true,
              ),
            
              const SizedBox(height: 10),
              
              // olvido la contraseña

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Olvidó la contraseña?',
                    style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),

              // Botono de iniciar sesion

              MyButton(
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                //boton google
                SquareTile(imagePath: 'lib/imagenes/google.png'),

                SizedBox(width: 25),

                //boton apple
                SquareTile(imagePath: 'lib/imagenes/apple.png'),
              ],
              ),

               const SizedBox(height: 50),
              
              // Registrarse ahora
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No está registrado?',
                  style: TextStyle(color: Colors.grey[700]),
                    ),
                  const SizedBox(width: 4),
                  const Text('Registrese ahora',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
            ),
        ),
      )
    );
  }
}