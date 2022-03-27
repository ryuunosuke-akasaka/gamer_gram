import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamer_gram/models/posts.dart';
import 'package:gamer_gram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String uid,
    Uint8List file,
    String description,
    String username,
    String profImage,
  ) async {
    String res = "Some error has occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        uid: uid,
        description: description,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        username: username,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async{
    try {
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }
    } catch(e){
      print(e.toString());
    }
  }


  Future<void> postComment(String postId,String text, String uid, String name, String profilePic) async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now(),
        });
      }
      else{
        print("Text is empty");
      }
    }
    catch(e){
      print(e.toString());
    }
  }
  //delete post
  Future<void> deletepost(String postId) async{
    try{
    await _firestore.collection('psots').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
    
  }

  //follow user
  Future<void> followUser(
      String uid,
      String followId
      ) async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(uid)){
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayUnion([uid]),
        });
      }

    }catch(e){
      print(e.toString());
    }
  }

  

  //unLike function with another animation maybe
}
