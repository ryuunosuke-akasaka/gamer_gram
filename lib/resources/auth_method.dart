import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamer_gram/resources/storage_methods.dart';
import 'package:gamer_gram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUSerDetail() async{
   User currentUser = _auth.currentUser!;

   DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

   return model.User.fromSnap(snap);
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage(
            'profilePics', file, false);

        //add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
    // 'username': username,
    // 'uid': cred.user!.uid,
    // 'email': email,
    // 'bio': bio,
    // 'followers': [],
    // 'following': [],
    // 'photoUrl': photoUrl,
        //
        // await _firestore.collection('users').add({
        //   'username':username,
        //   'uid':cred.user!.uid,
        //   'email':email,
        //   'bio':bio,
        //   'followers':[],
        //   'following':[],
        // });

        res = "success";
      }
    }
    // } on FirebaseAuthException catch(err) {
    //   if(err.code == 'invalid-email'){
    //     res = 'The email is badly formatted';
    //   }
    //   else if(err.code == 'weak-passowrd') {
    //     res = 'Password is weak';
    //   }
    // }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  //Logging in
  Future<String> loginUser({
    required String email,
    required String password,
  }) async{
    String res = "Some error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = "success";
      }else{
        res = "Please enter all the fields";
      }
    }catch(err){
      res =  err.toString();
    }

    return res;

  }

  Future<void> signOut() async{
    await _auth.signOut();
  }



}
