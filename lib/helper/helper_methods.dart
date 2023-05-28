// return a formatted data as a string
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // Tiemstamp in the object we retrieve from firebase
  // so to display it, lets convert it to a String
  DateTime dateTime = timestamp.toDate();

  // get year 
  String year = dateTime.year.toString();
  // get month
  String month = dateTime.month.toString();
  // get day
  String day = dateTime.day.toString();

  // final fomrmated date
  String formattedData = '$day/$month/$year';

  return formattedData;
}

/*
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection("User Posts")
    .doc(widget.postId)
    .collection("Comments")
    .orderBy("CommentTime", descending: true)
    .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No comments');
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: snapshot.data!.docs.map((doc) {
        final commentData = doc.data() as Map<String, dynamic>;
        return Comment(
          text: commentData["CommentText"],
          user: commentData["CommentedBy"],
          time: formatDate(commentData["CommentTime"]),
        );
      }).toList(),
      */

      /*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/componentes/comment.dart';
import 'package:login/componentes/comment_button.dart';
import 'package:login/componentes/like_button.dart';
import 'package:login/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes; 

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {  
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked; 
    });

    // access the document in Firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the "Likes" field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });    
    }
  }

  // add a comment
  void addComment(String commentText) {
    // write the comment to Firestore under the comments collection for this post
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add({
      "CommentText" : commentText,
      "CommentedBy": currentUser.email,
      "CommentTime" : Timestamp.now(), // remember to format this when displaying
    });
  }

  // show a dialog box for adding a comment
  void showCommentDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Escribe un comentario.."),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            }, 
            child: const Text("Cancelar"),
          ),

          // Post button
          TextButton(
            onPressed: () {
              // add comment
              addComment(_commentTextController.text);

              // pop box
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            },
            child: const Text("Postear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // wallpost
          Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // message
              Text(widget.message),

              const SizedBox(height: 5),

              // user
              Row(
            children: [
              Text(
              widget.user, 
              style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                " • ", 
              style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
              widget.time,
              style: TextStyle(color: Colors.grey[400]),
              ),
            ],
            ),
            ],
          ),
          
          const SizedBox(height: 20),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Like            
              Column(
                children: [
                  // Like button
                  LikeButton(
                    isLiked: isLiked, 
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),
                
                  // Like count
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Comment         
              Column(
                children: [
                  // Comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),
                
                  // Comment count
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("User Posts")
              .doc(widget.postId)
              .collection("Comments")
              .orderBy("CommentTime", descending: true)
              .snapshots(),
            builder: (context, snapshot) {

              // show loadign circle if no data yet
              if (snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  final doc = snapshot.data?.docs[index];
                  if (doc != null) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  } else {
                    return const SizedBox(); // Placeholder widget when data is null
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
      */