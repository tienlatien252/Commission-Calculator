import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/employer.dart';

@immutable
class AppState {
  AppState({this.currentUser, this.employers, this.currentEmployer, this.currentDate});
  final FirebaseUser currentUser;
  final List<Employer> employers;
  final Employer currentEmployer;
  final DateTime currentDate;
  //AppState.initialState() : items = [];
}

class CheckUserAction {
  final FirebaseUser user;
  CheckUserAction(this.user);
}

class GetEmployersAction {
  final List<Employer> employers;
  GetEmployersAction(this.employers);
}

class AddNewEmployerAction {
  final Employer newEmployers;
  AddNewEmployerAction(this.newEmployers);
}

class ChangeCurrentEmployerAction {
  final Employer employer;
  ChangeCurrentEmployerAction(this.employer);
}

class InitEmployersAction {
  final bool getCurrentEmployer;
  InitEmployersAction({this.getCurrentEmployer});
}

class ChangeDateAction {
}

class LogoutAction{
}