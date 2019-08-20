import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({Key key, this.onTap, this.label, this.alignment})
      : super(key: key);
  final Function onTap;
  final String label;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment != null ? alignment : AlignmentDirectional.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            margin: EdgeInsets.all(10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Theme.of(context).accentColor,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 20.0),
            )),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton({Key key, this.onTap, this.icon}) : super(key: key);
  final Function onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          margin: EdgeInsets.all(10.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Theme.of(context).accentColor,
          ),
          child: icon),
    );
  }
}

class CustomButtonBar extends StatelessWidget {
  CustomButtonBar({Key key, this.onTap, this.text}) : super(key: key);
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Theme.of(context).accentColor,
            ),
            child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ))
                ])));
  }
}

class CustomInlineButton extends StatelessWidget {
  CustomInlineButton({Key key, this.onTap, this.text}) : super(key: key);
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            //margin: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: Text(text,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  //fontWeight: FontWeight.bold,
                ))));
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({Key key, this.onTap, this.title, this.subtitle})
      : super(key: key);
  final Function onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
