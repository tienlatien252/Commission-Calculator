import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../services/employer_service.dart';

Future setCurrentEmployer(Employer employer) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('currentEmployerId', employer.employerId);
  await prefs.setString('currentEmployerName', employer.name);
  await prefs.setDouble(
      'currentEmployerCommissionRate', employer.commissionRate);
}

Future resetCurrentEmployer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('seen');
  await prefs.remove('currentEmployerId');
  await prefs.remove('currentEmployerName');
  await prefs.remove('currentEmployerCommissionRate');
}

Future deleteCurrentEmployer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('currentEmployerId');
  await prefs.remove('currentEmployerName');
  await prefs.remove('currentEmployerCommissionRate');
}

Future<Employer> getCurrentEmployer() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String currentEmployerId = prefs.getString('currentEmployerId');
  String currentEmployerName = prefs.getString('currentEmployerName');
  double currentEmployerCommissionRate =
      prefs.getDouble('currentEmployerCommissionRate');

  if (currentEmployerId != null) {
    Employer currentEmployer = new Employer(
        employerId: currentEmployerId,
        name: currentEmployerName,
        commissionRate: currentEmployerCommissionRate);
    return currentEmployer;
  }

  return null;
}

Future<Null> seenFirstSetup({bool seen}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (seen != null) {
    await prefs.setBool('seen', seen);
  } else {
    await prefs.remove('seen');
  }
}
