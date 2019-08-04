import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/employer.dart';
import 'package:Calmission/common/employer_service.dart';


class DeleteEmployerDialogView extends StatefulWidget {
  DeleteEmployerDialogView({Key key, this.employer}) : super(key: key);
  final Employer employer;

  @override
  _DeleteEmployerDialogViewState createState() =>
      _DeleteEmployerDialogViewState();
}

class _DeleteEmployerDialogViewState extends State<DeleteEmployerDialogView> {
  _deleteEmployer() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String id = currentUser.uid;
    String pathString = 'users/' + id + '/employers';
    Map<String, dynamic> data = {
          'name': widget.employer.name,
          'commission_rate': widget.employer.commissionRate,
          'isDeleted': true
    };
    Employer currentEmployer = await getCurrentEmployer();
    if (currentEmployer!= null && currentEmployer.employerId==widget.employer.employerId){
      await deleteCurrentEmployer();
    }
    Firestore.instance
        .collection(pathString)
        .document(widget.employer.employerId)
        .setData(data).whenComplete(() {
      //employers.remove(widget.employer.employerId);
    }).catchError((e) => print(e));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are You Sure?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('All the employer\'s data will be deleted.'),
            Text('and will NOT be able to recover.'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),FlatButton(
            textColor: Colors.red,
            child: Text('Yes'),
            onPressed: () => _deleteEmployer()
          )
        ,
      ],
    );
  }
}
