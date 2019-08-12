import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Employer {
  const Employer({this.name, this.commissionRate, this.employerId});
  final String name;
  final double commissionRate;
  final String employerId;
}

class EmployerService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Employer _currentEmployer;
  bool _seenSetup = false;

  Employer get currentEmployer => _currentEmployer;
  bool get seenSetup => _seenSetup;

  Future getPersistedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentEmployerId = prefs.getString('currentEmployerId');
    String currentEmployerName = prefs.getString('currentEmployerName');
    double currentEmployerCommissionRate =
        prefs.getDouble('currentEmployerCommissionRate');
    bool seenSetup = prefs.getBool('seenSetup');

    if (currentEmployerId != null) {
      Employer currentEmployer = new Employer(
          employerId: currentEmployerId,
          name: currentEmployerName,
          commissionRate: currentEmployerCommissionRate);
      _currentEmployer = currentEmployer;
    }

    _seenSetup = seenSetup != null ? seenSetup : false;
  }

  Future<List<Employer>> getListEmployers() async {
    List<DocumentSnapshot> documents = await getEmployersDocument();
    return documents.map((document) {
      return Employer(
          name: document.data['name'],
          commissionRate: document.data['commission_rate'],
          employerId: document.documentID);
    }).toList();
  }

  void finishSetup({bool seen}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (seen != null) {
      await prefs.setBool('seenSetup', seen);
      _seenSetup = seen;
    } else {
      await prefs.remove('seenSetup');
      _seenSetup = false;
    }
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> getEmployersDocument() async {
    FirebaseUser _currentUser = await _firebaseAuth.currentUser();
    String pathString = 'users/' + _currentUser.uid + '/employers';
    final QuerySnapshot result = await Firestore.instance
        .collection(pathString)
        .where('isDeleted', isEqualTo: false)
        .getDocuments();
    return result.documents;
  }

  Future<Null> setCurrentEmployer(Employer employer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentEmployerId', employer.employerId);
    await prefs.setString('currentEmployerName', employer.name);
    await prefs.setDouble(
        'currentEmployerCommissionRate', employer.commissionRate);
    _currentEmployer = Employer(
        employerId: employer.employerId,
        name: employer.name,
        commissionRate: employer.commissionRate);
    notifyListeners();
  }

  Future resetCurrentEmployer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('seenSetup');
    await prefs.remove('currentEmployerId');
    await prefs.remove('currentEmployerName');
    await prefs.remove('currentEmployerCommissionRate');
    _currentEmployer = null;
    _seenSetup = null;
    notifyListeners();
  }

  Future deleteCurrentEmployer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentEmployerId');
    await prefs.remove('currentEmployerName');
    await prefs.remove('currentEmployerCommissionRate');
    _currentEmployer = null;
    notifyListeners();
  }

  Future saveNewEmployer(
      double comissionRate, String employerName, Employer employer) async {
    FirebaseUser _currentUser = await _firebaseAuth.currentUser();
    String id = _currentUser.uid;
    String pathString = 'users/' + id + '/employers';
    Map<String, dynamic> data = {
      'name': employerName,
      'commission_rate': comissionRate.round() / 100,
      'isDeleted': false
    };
    Future future;
    if (employer == null) {
      future =
          Firestore.instance.collection(pathString).document().setData(data);
    } else {
      future = Firestore.instance
          .collection(pathString)
          .document(employer.employerId)
          .setData(data);
    }
    return future;
  }

  deleteEmployer(Employer employer) async {
    FirebaseUser _currentUser = await _firebaseAuth.currentUser();
    String id = _currentUser.uid;
    String pathString = 'users/' + id + '/employers';
    Map<String, dynamic> data = {
      'name': employer.name,
      'commission_rate': employer.commissionRate,
      'isDeleted': true
    };
    if (_currentEmployer != null &&
        currentEmployer.employerId == employer.employerId) {
      await deleteCurrentEmployer();
    }
    Firestore.instance
        .collection(pathString)
        .document(employer.employerId)
        .setData(data)
        .whenComplete(() {
      notifyListeners();
      //employers.remove(widget.employer.employerId);
    }).catchError((e) => print(e));
  }

  @override
  void dispose() {}
}
