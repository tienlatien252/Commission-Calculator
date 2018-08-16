import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'l10n/localization.dart';

enum ProvidersTypes { email, google, facebook, twitter, phone }

ProvidersTypes stringToProvidersType(String value) {
  if (value.toLowerCase().contains('facebook')) return ProvidersTypes.facebook;
  if (value.toLowerCase().contains('google')) return ProvidersTypes.google;
  if (value.toLowerCase().contains('password')) return ProvidersTypes.email;
//TODO  if (value.toLowerCase().contains('twitter')) return ProvidersTypes.twitter;
//TODO  if (value.toLowerCase().contains('phone')) return ProvidersTypes.phone;
  return null;
}

// Description button
class ButtonDescription extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color color;
  final String logo;
  final String name;
  final VoidCallback onSelected;

  const ButtonDescription(
      {@required this.logo,
      @required this.label,
      @required this.name,
      this.onSelected,
      this.labelColor = Colors.grey,
      this.color = Colors.white});

  ButtonDescription copyWith({
    String label,
    Color labelColor,
    Color color,
    String logo,
    String name,
    VoidCallback onSelected,
  }) {
    return ButtonDescription(
        label: label ?? this.label,
        labelColor: labelColor ?? this.labelColor,
        color: color ?? this.color,
        logo: logo ?? this.logo,
        name: name ?? this.name,
        onSelected: onSelected ?? this.onSelected);
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback _onSelected = onSelected ?? () => {};
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: RaisedButton(
          color: color,
          child: Row(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 16.0, right: 32.0),
                  child: Image.asset('assets/$logo')),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: labelColor),
                ),
              )
            ],
          ),
          onPressed: _onSelected),
    );
  }
}

Map<ProvidersTypes, ButtonDescription> providersDefinitions(
        BuildContext context) =>
    {
      ProvidersTypes.facebook: ButtonDescription(
          color: const Color.fromRGBO(59, 87, 157, 1.0),
          logo: "fb-logo.png",
          label: FFULocalizations.of(context).signInFacebook,
          name: "Facebook",
          labelColor: Colors.white),
      ProvidersTypes.google: ButtonDescription(
          color: Colors.white,
          logo: "go-logo.png",
          label: FFULocalizations.of(context).signInGoogle,
          name: "Google",
          labelColor: Colors.grey),
      ProvidersTypes.email: ButtonDescription(
          color: const Color.fromRGBO(219, 68, 55, 1.0),
          logo: "email-logo.png",
          label: FFULocalizations.of(context).signInEmail,
          name: "Email",
          labelColor: Colors.white),
    };

Future<Null> showErrorDialog(BuildContext context, String message,
    {String title}) {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message ?? FFULocalizations.of(context).errorOccurred),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text(FFULocalizations.of(context).cancelButtonLabel),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
  );
}
