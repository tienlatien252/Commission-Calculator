import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';

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
    future = Firestore.instance.collection(pathString).document().setData(data);
  } else {
    future = Firestore.instance
        .collection(pathString)
        .document(comissionData.id)
        .setData(data);
  }
  return future;
}

Future<Commission> getDayCommission(
    Employer currentEmployer, DateTime date) async {
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

Future<Commission> getMonthCommission(
    Employer currentEmployer, DateTime date) async {
  FirebaseUser _currentUser = await _firebaseAuth.currentUser();
  String currentEmployerId =
      currentEmployer != null ? currentEmployer.employerId : 'abc';
  String pathString = 'users/' +
      _currentUser.uid +
      '/employers/' +
      currentEmployerId +
      '/commission';

  DateTime beginMonth = _getDateOnly(beginOfMonth(date));
  DateTime endMonth = _getDateOnly(endOfMonth(date));

  final QuerySnapshot snapshot = await Firestore.instance
      .collection(pathString)
      .where('date', isGreaterThanOrEqualTo: beginMonth)
      .where('date', isLessThanOrEqualTo: endMonth)
      .getDocuments();
  return _getCommissionData(snapshot);
}

Future<Commission> getWeekCommission(
    Employer currentEmployer, DateTime date) async {
  FirebaseUser _currentUser = await _firebaseAuth.currentUser();
  String currentEmployerId =
      currentEmployer != null ? currentEmployer.employerId : 'abc';
  String pathString = 'users/' +
      _currentUser.uid +
      '/employers/' +
      currentEmployerId +
      '/commission';

  DateTime beginWeek = _getDateOnly(beginOfWeek(date));
  DateTime endWeek = _getDateOnly(endOfWeek(date));

  final QuerySnapshot snapshot = await Firestore.instance
      .collection(pathString)
      .where('date', isGreaterThanOrEqualTo: beginWeek)
      .where('date', isLessThanOrEqualTo: endWeek)
      .getDocuments();
  return _getCommissionData(snapshot);
}

Future<Commission> getYearCommission(
    Employer currentEmployer, DateTime date) async {
  FirebaseUser _currentUser = await _firebaseAuth.currentUser();
  String currentEmployerId =
      currentEmployer != null ? currentEmployer.employerId : 'abc';
  String pathString = 'users/' +
      _currentUser.uid +
      '/employers/' +
      currentEmployerId +
      '/commission';

  DateTime beginYear = _getDateOnly(beginOfYear(date));
  DateTime endYear = _getDateOnly(endOfYear(date));

  final QuerySnapshot snapshot = await Firestore.instance
      .collection(pathString)
      .where('date', isGreaterThanOrEqualTo: beginYear)
      .where('date', isLessThanOrEqualTo: endYear)
      .getDocuments();
  return _getCommissionData(snapshot);
}

Future getRangeCommission(
  Employer currentEmployer, DateTime startDate, DateTime endDate) async {
  DateTime formatedStartDate = _getDateOnly(startDate);
  DateTime formatedEndDate = _getDateOnly(endDate);

  FirebaseUser _currentUser = await _firebaseAuth.currentUser();
  String currentEmployerId =
      currentEmployer != null ? currentEmployer.employerId : 'abc';
  String pathString = 'users/' +
      _currentUser.uid +
      '/employers/' +
      currentEmployerId +
      '/commission';

  final QuerySnapshot snapshot = await Firestore.instance
      .collection(pathString)
      .where('date', isGreaterThanOrEqualTo: formatedStartDate)
      .where('date', isLessThanOrEqualTo: formatedEndDate)
      .getDocuments();
  return _getAllCommissionsData(snapshot);
}

Map<String, dynamic> _getAllCommissionsData(QuerySnapshot snapshot) {
  Commission totalCommission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
   List<Commission> listCommissions = List<Commission>();
  List<DocumentSnapshot> documents = snapshot.documents;
  if (documents.length != 0) {
    List<DocumentSnapshot> retunredCommissions = snapshot.documents;

    retunredCommissions.forEach((commissionData) {
      listCommissions.add(Commission(
          commission: commissionData.data['commission'].toDouble(),
          raw: commissionData.data['raw'].toDouble(),
          tip: commissionData.data['tip'].toDouble(),
          total: commissionData.data['total'].toDouble(),
          //date: commissionData.data['date'],
          id: commissionData.documentID));
      totalCommission.raw += commissionData.data['raw'].toDouble();
      totalCommission.commission +=
          commissionData.data['commission'].toDouble();
      totalCommission.tip += commissionData.data['tip'].toDouble();
      totalCommission.total += commissionData.data['total'].toDouble();
      totalCommission.id == commissionData.documentID;
    });
  }

  listCommissions = listCommissions.reversed.toList();
  return {
    'listCommissions': listCommissions,
    'totalCommission': totalCommission
  };
}

Commission _getCommissionData(QuerySnapshot snapshot) {
  List<DocumentSnapshot> documents = snapshot.documents;
  if (documents.length != 0) {
    Commission commission =
        Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
    documents.forEach((commissionData) {
      commission.raw += commissionData.data['raw'].toDouble();
      commission.commission += commissionData.data['commission'].toDouble();
      commission.tip += commissionData.data['tip'].toDouble();
      commission.total += commissionData.data['total'].toDouble();
      commission.id = commissionData.documentID;
    });

    return commission;
  }
  return Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
}

DateTime _getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}
