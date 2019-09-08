import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EditDataView extends StatefulWidget {
  EditDataView({Key key, this.title, this.date, this.commission})
      : super(key: key);
  final String title;
  final DateTime date;
  final Commission commission;

  @override
  _EditDataViewState createState() => _EditDataViewState();
}

class _EditDataViewState extends State<EditDataView> {
  final _formKey = GlobalKey<FormState>();
  Commission _comissionData =
      Commission(raw: 0.0, tip: 0.0, commission: 0.0, total: 0.0);

  onPresscancel() {
    //FocusScope.of(context).detach();
    Navigator.pop(context);
  }

  void onSubmit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      EmployerService employerService =
          Provider.of<EmployerService>(context, listen: false);
      Employer currentEmployer = employerService.currentEmployer;
      await saveCommission(currentEmployer, _comissionData, widget.date);

      Navigator.pop(context);
    }
  }

  String _validateNumber(String value) {
    try {
      double.parse(value);
    } catch (e) {
      return 'The field must be a number.';
    }

    return null;
  }

  void _onSave(String value) async {
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    Employer currentEmployer = employerService.currentEmployer;
    _comissionData.id = widget.commission.id;
    _comissionData.raw = double.parse(value);
    _comissionData.commission =
        (_comissionData.raw * currentEmployer.commissionRate);
    _comissionData.total += _comissionData.commission;
  }

  @override
  Widget build(BuildContext context) {
    String initRaw =
        widget.commission.id != null ? widget.commission.raw.toString() : "";
    String initTip =
        widget.commission.id != null ? widget.commission.tip.toString() : "";

    initRaw = initRaw.endsWith(".0")
        ? initRaw.substring(0, initRaw.length - 2)
        : initRaw;
    initTip = initTip.endsWith(".0")
        ? initTip.substring(0, initTip.length - 2)
        : initTip;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: CustomButtonBar(onTap: onSubmit, text: "Save"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: true,
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                  initialValue: initRaw,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    prefixText: '\$',
                    labelText: 'Raw',
                  ),
                  validator: _validateNumber,
                  onSaved: (String value) => _onSave(value)),
              TextFormField(
                  initialValue: initTip,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                  decoration: new InputDecoration(
                    prefixText: '\$',
                    labelText: 'Tip',
                  ),
                  validator: _validateNumber,
                  onSaved: (String value) {
                    _comissionData.tip = double.parse(value);
                    _comissionData.total += _comissionData.tip;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
