import 'package:flutter/material.dart';
import 'package:gamer_gram/models/user.dart';
import 'package:gamer_gram/resources/auth_method.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();


  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethods.getUSerDetail();
    _user = user;
    notifyListeners();
  }
}