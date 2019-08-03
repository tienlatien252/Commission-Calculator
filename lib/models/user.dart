import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User   {
  const User({this.uid, this.name, this.photoUrl});
  final String uid;
  final String name;
  final String photoUrl;
}

class UserModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  User _user = new User();
  User get user => _user;

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(FirebaseUser newuser) {
    _user = new User(uid: newuser.uid, name: newuser.displayName, photoUrl: newuser.photoUrl); 
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
  void logout() {
    _user = null;
  }
}
