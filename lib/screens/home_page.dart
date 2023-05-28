import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/componentes/drawer.dart';
import 'package:login/componentes/wall_post.dart';
import 'package:login/helper/helper_methods.dart';
import 'package:login/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    // Usuario
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Controlador texto
  final textController = TextEditingController();

  // Metodo de cierre de sesion
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Metodo para publicar
  void postMessage() {
    // Only post if there is something in the textfield
    if ( textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }
    
    // clear the textField
    setState(() {
      textController.clear();
    });
  }

  // navigate to profile page
  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
        ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          widthFactor: 2.5,
          child: 
          Text('SandCastle',
          style: TextStyle(color: Color(0xFF592a2f)
          ),
          )
          ),
        backgroundColor: const Color(0xFFfad8b2),        
      ),
      drawer:  MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // El muro
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy(
                    "TimeStamp",
                    descending: true,
                  )
                .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // obtener el mensage
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'], 
                          postId: post.id,
                          likes: List<String>.from(post["Likes"] ?? []),
                          time: formatDate(post["TimeStamp"]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                    );
                },
                ), 
              ),
      
            // Publicar mensaje
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // TextField
                  Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe cualquier cosa...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),


            
                  // Boton para postear
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.send_rounded),
                      color: const Color(0xFF592a2f),
                    ),
                  ),

                ],
            
              ),
            ),
            // Logged in as
            Text("Enlazado con: ${currentUser.email!}",
            style:const TextStyle(color: Color(0xFF592a2f)),
            ),

            const SizedBox(height: 13)
          ],
        ),
      ), 
    );
  }
}