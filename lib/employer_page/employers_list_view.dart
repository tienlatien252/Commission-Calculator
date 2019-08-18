import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/employer_page/add_new_employer_dialog.dart';
import 'package:Calmission/employer_page/delete_employer_dialog.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';

class EmployersListView extends StatelessWidget {
  EmployersListView({Key key, this.isDrawer}) : super(key: key);
  final bool isDrawer;

  @override
  Widget build(BuildContext context) {
    EmployerService employerService = Provider.of<EmployerService>(context);
    return FutureBuilder<List<Employer>>(
        future: employerService.getListEmployers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: PlatformLoadingIndicator());
          if (snapshot.data.isEmpty) return Text('No Employer');

          Employer currentEmployer = employerService.currentEmployer;

          String currentEmployerID = currentEmployer != null
              ? currentEmployer.employerId
              : snapshot.data[0].employerId;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Employer employer = snapshot.data[index];
                return EmployerCard(
                    isDrawer: isDrawer,
                    employer: employer,
                    currentEmployerID: currentEmployerID);
              });
        });
  }
}

class EmployerCard extends StatelessWidget {
  EmployerCard(
      {Key key,
      @required this.employer,
      @required this.isDrawer,
      @required this.currentEmployerID})
      : super(key: key);
  final Employer employer;
  final bool isDrawer;
  final String currentEmployerID;

  Future<Null> _openEditEmployerDialog(
      BuildContext context, Employer employer) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(
                  title: "Edit Employer", employer: employer);
            },
            fullscreenDialog: true));
  }

  Future<Null> _openDeleteEmployerDialog(
      BuildContext context, Employer employer) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteEmployerDialogView(employer: employer);
        });
  }

  Future<Null> selectEmployer(BuildContext context,
      EmployerService employerService, Employer employer) async {
    await employerService.setCurrentEmployer(employer);
    //if (isDrawer) {
    // Navigator.pop(context);
    //}
  }

  Widget _buildEmployerManage(BuildContext context) {
    if (!isDrawer) {
      return Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _openEditEmployerDialog(context, employer);
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _openDeleteEmployerDialog(context, employer);
            })
      ]);
    } else {
      return Container(height: 0); //or any other widget but not null
    }
  }

  ShapeDecoration _getShapeDecoration() {
    double radius = isDrawer ? 5.0 : 5.0;
    return ShapeDecoration(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService = Provider.of<EmployerService>(context);
    return Container(
      decoration: ShapeDecoration(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Colors.white,
    ),
      margin: isDrawer
          ? EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0)
          : EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: ListTileTheme(
        selectedColor: Theme.of(context).textSelectionColor,
        child: ListTile(
          onTap: () => selectEmployer(context, employerService, employer),
          selected: employer.employerId == currentEmployerID,
          leading: const Icon(Icons.store),
          subtitle: Text((employer.commissionRate * 100).toString() + "%"),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                employer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              _buildEmployerManage(context),
            ],
          ),
        ),
      ),
    );
  }
}
