import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamer_gram/pages/add_post_screen.dart';
import 'package:gamer_gram/pages/feed_screen.dart';
import 'package:gamer_gram/pages/profile_screen.dart';
import 'package:gamer_gram/pages/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("notif"),),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];