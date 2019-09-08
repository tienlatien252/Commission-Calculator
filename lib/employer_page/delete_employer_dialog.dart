import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/services/employer_service.dart';


class DeleteEmployerDialogView extends StatefulWidget {
  DeleteEmployerDialogView({Key key, this.employer}) : super(key: key);
  final Employer employer;

  @override
  _DeleteEmployerDialogViewState createState() =>
      _DeleteEmployerDialogViewState();
}

class _DeleteEmployerDialogViewState extends State<DeleteEmployerDialogView> {
  _deleteEmployer() async {
    EmployerService employerService = Provider.of<EmployerService>(context);
    employerService.deleteEmployer(widget.employer);
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
