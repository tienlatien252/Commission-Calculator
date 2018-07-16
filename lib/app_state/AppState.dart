import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Employer.dart';

@immutable
class AppState {
  AppState({this.currentUser, this.employers});
  final FirebaseUser currentUser;
  final List<Employer> employers;

  //AppState.initialState() : items = [];
}

class CheckUserAction {
  final FirebaseUser user;
  CheckUserAction(this.user);
}

class ChangeEmployersAction {
  final List<Employer> employers;
  ChangeEmployersAction(this.employers);
}

class InitEmployersAction {
}

class LogoutAction{
}


AppState addItem(AppState state, CheckUserAction action) {
  return AppState(currentUser: action.user);
}

AppState reducer(AppState prev, action) {
  if (action is CheckUserAction) {
    return AppState(currentUser: action.user);
  }
  if (action is ChangeEmployersAction) {
    return AppState(currentUser: prev.currentUser, employers: action.employers);
  }
  if (action is LogoutAction){
    return AppState();
  }

  return prev;
}