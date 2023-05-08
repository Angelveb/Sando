import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/screens/home_page.dart';
import 'package:login/screens/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Usuario logueado
          if(snapshot.hasData){
            return HomePage();
          }
          // Usuario no logueado
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}