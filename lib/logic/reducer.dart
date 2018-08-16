import 'package:firebase_auth/firebase_auth.dart';

import '../models/employer.dart';
import 'app_state.dart';

AppState reducer(AppState prev, action) {
  if (action is LogoutAction){
    return AppState();
  }
  FirebaseUser currentUser = _handleCheckUserAction(prev, action);
  List<Employer> employers = _handleGetEmployersAction(prev, action);
  employers = _handleAddNewEmployerAction(employers, action);
  Employer currentEmployer = _handleChangeCurrentEmployerAction(prev, action);

  return  AppState(
    currentUser: currentUser,
    employers: employers,
    currentEmployer: currentEmployer
  );
}

FirebaseUser _handleCheckUserAction (AppState prev, action){
  if(action is CheckUserAction){
      return action.user;
  }
  return prev.currentUser;
}

List<Employer> _handleGetEmployersAction (AppState prev, action){
  if(action is GetEmployersAction){
      return action.employers;
  }
  return prev.employers;
}

List<Employer> _handleAddNewEmployerAction (List<Employer> employers, action){
  if(action is AddNewEmployerAction){
    if(employers == null){
      employers =  List<Employer>();
    }
    employers.add(action.newEmployers);
  }

  return employers;
}

Employer _handleChangeCurrentEmployerAction (AppState prev, action){
  if(action is ChangeCurrentEmployerAction){
      return action.employer;
  }
  return prev.currentEmployer;
}