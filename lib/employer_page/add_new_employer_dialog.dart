import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';

class AddEmployerView extends StatefulWidget {
  AddEmployerView({Key key, this.title, this.employer}) : super(key: key);
  final String title;
  final Employer employer;

  @override
  _AddEmployerViewState createState() => _AddEmployerViewState();
}

class _AddEmployerViewState extends State<AddEmployerView> {
  double _comissionRate = 60.0;
  String employerName = "";

  final _formKey = GlobalKey<FormState>();

  _saveNewEmployer() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      Future future = Provider.of<EmployerService>(context, listen: false)
          .saveNewEmployer(_comissionRate, employerName, widget.employer);

      future.whenComplete(() {
        //FocusScope.of(context).detach();
        Navigator.pop(context);
      }).catchError((e) => print(e));
    }
  }

  @override
  void initState() {
    super.initState();
    _comissionRate = widget.employer != null
        ? widget.employer.commissionRate * 100
        : _comissionRate;
  }

  onPresscancel() {
    //FocusScope.of(context).detach();
    Navigator.pop(context);
  }

  String _validateNameString(String value) {
    if (value.length == 0) {
      return 'The name field must not be empty';
    }
    return null;
  }

  _showRatePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.decimal(
            minValue: 1,
            maxValue: 100,
            initialDoubleValue: _comissionRate,
            title: new Text("Enter Commmission Rate"),
          );
        }).then((value) {
      if (value != null) {
        setState(() => _comissionRate = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String initName = widget.employer != null ? widget.employer.name : "";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.store_mall_directory),
                title: Form(
                  key: _formKey,
                  child: TextFormField(
                      autofocus: true,
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                      initialValue: initName,
                      decoration: new InputDecoration(labelText: 'Name'),
                      validator: _validateNameString,
                      onSaved: (String value) {
                        employerName = value;
                      }),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text("Commission Rate",
                      style: TextStyle(fontSize: 25.0, color: Colors.black54)),
                  trailing: new Text(
                    "$_comissionRate %",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  onTap: () => _showRatePicker(context))
            ],
          )),
      floatingActionButton:
          CustomButtonBar(onTap: _saveNewEmployer, text: "Save"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
