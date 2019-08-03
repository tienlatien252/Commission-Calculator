import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:collection';

class Employer {
  const Employer({this.name, this.commissionRate, this.employerId});
  final String name;
  final double commissionRate;
  final String employerId;
}

class EmployersModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Employer> _employers = [];
  Employer currentEmployer;

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Employer> get employers =>
      UnmodifiableListView(_employers);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Employer employer) {
    _employers.add(employer);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void load(List<Employer> employersList) {
    employersList.forEach((Employer employer) {
      _employers.add(employer);
    });
    // This call tells the widgets that are listening to this model to rebuild.
  }

  void remove(String id) {
    _employers.removeWhere((Employer employer) => employer.employerId == id);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void choose({Employer employer}) {
    if (employer == null) {
      currentEmployer = _employers[0];
    } else {
      currentEmployer = new Employer(
          employerId: employer.employerId,
          name: employer.name,
          commissionRate: employer.commissionRate);
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
