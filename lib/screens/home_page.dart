import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/componentes/my_text_field.dart';
import 'package:login/componentes/wall_post.dart';

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

  setState(() {
    textController.clear();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title:const Center(
          child: 
          Text('Muro Sandro')),
        backgroundColor: Colors.teal,
        actions: [
          // sign out button
          IconButton(
          onPressed: signOut, 
          icon: const Icon(Icons.logout)
          )
          ],          
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
                    descending: false,
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
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // TextField
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Escribe cualquier cosa en el muro...',
                      obscuredText: false,
                    ), 
                  ),
            
                  // Boton para postear
                  IconButton(
                    onPressed: postMessage, 
                    icon: const Icon(Icons.send_rounded)
                    )
                ],
            
              ),
            ),
            // Logged in as
            Text("Enlazado con: " + currentUser.email!,
            style:const TextStyle(color: Colors.teal),
            ),

            const SizedBox(height: 50)
          ],
        ),
      ), 
    );
  }
}