import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Calmission/services/employer_service.dart';

class Commission {
  Commission(
      {this.raw, this.commission, this.tip, this.total, this.id, this.date});
  double raw;
  double commission;
  double tip;
  double total;
  DateTime date;
  String id;
}

class CommissionService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future saveCommission(
      Employer currentEmployer, Commission comissionData, DateTime date) async {
    FirebaseUser _currentUser = await _firebaseAuth.currentUser();
    String id = _currentUser.uid;
    String employerId = currentEmployer.employerId;
    String pathString =
        'users/' + id + '/employers/' + employerId + '/commission';
    Map<String, dynamic> data = {
      'raw': comissionData.raw,
      'tip': comissionData.tip,
      'commission': comissionData.commission,
      'total': comissionData.total,
      'date': date,
    };

    Future future;
    if (comissionData.id == null) {
      future =
          Firestore.instance.collection(pathString).document().setData(data);
    } else {
      future = Firestore.instance
          .collection(pathString)
          .document(comissionData.id)
          .setData(data);
    }
    return future;
  }

  Future<Commission> getCommission(
      Employer currentEmployer, Commission comissionData, DateTime date) async {
    FirebaseUser _currentUser = await _firebaseAuth.currentUser();
    String currentEmployerId =
        currentEmployer != null ? currentEmployer.employerId : 'abc';
    String pathString = 'users/' +
        _currentUser.uid +
        '/employers/' +
        currentEmployerId +
        '/commission';

    DateTime dateOnly = _getDateOnly(date);
    final QuerySnapshot snapshot = await Firestore.instance
        .collection(pathString)
        .where('date', isEqualTo: dateOnly)
        .getDocuments();
    return _getCommissionData(snapshot);
  }

  Commission _getCommissionData(QuerySnapshot snapshot) {
    List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.length != 0) {   
      List<Commission> listCommission = documents.map((document) {
        return Commission(
          raw: document['raw'].toDouble(),
          commission: document['commission'].toDouble(),
          tip: document['tip'].toDouble(),
          total: document['total'].toDouble(),
          id: document.documentID,
        );
      }).toList();
      return listCommission[0];
    }
    return Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  }

  DateTime _getDateOnly(DateTime dateAndTime) {
    return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
  }
}
