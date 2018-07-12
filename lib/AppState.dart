import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AppState {
  AppState({this.currentUser});
  final FirebaseUser currentUser;

  //AppState.initialState() : items = [];
}

class LoginAction {
  final FirebaseUser currentUser;
  LoginAction(this.currentUser);
}

class CheckUserAction {
  final FirebaseUser user;
  CheckUserAction(this.user);
}

AppState addItem(AppState state, CheckUserAction action) {
  return AppState(currentUser: action.user);
}

AppState reducer(AppState prev, action) {
  if (action is CheckUserAction) {
    return AppState(currentUser: action.user);
  }

  return prev;
}