import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'dart:async';

import 'app_state.dart';
import '../models/employer.dart';

middleware(Store<AppState> store, action, NextDispatcher next) {
  print(action.runtimeType);
  if (action is InitEmployersAction) {
    _handleInitEmployers(store, action.getCurrentEmployer);
  }
  next(action);
}

_handleInitEmployers(Store<AppState> store, bool getCurrentEmployer) async {
  List<Employer> employers = await _getEmployers(store);
  if (employers != null) {
    store.dispatch(GetEmployersAction(employers));
    //store.dispatch(ChangeCurrentEmployerAction(employers[0]));
    if(getCurrentEmployer){
      store.dispatch(ChangeCurrentEmployerAction(employers[0]));
    }
  }
}

Future<List<Employer>> _getEmployers(Store<AppState> store) async {
  if (store.state.currentUser != null) {
    String id = store.state.currentUser.uid;
    String pathString = 'users/' + id + '/employers';
    QuerySnapshot stream =
        await Firestore.instance.collection(pathString).where('isDeleted', isEqualTo: false).getDocuments();
    if (stream.documents.length != 0) {
      return stream.documents.map((DocumentSnapshot document) {
        return Employer(name: document.data['name'], commissionRate: document.data['commission_rate'], employerId: document.documentID);
      }).toList();
    }
  }

  return null;
}
