import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({Key key, this.onTap, this.label, this.alignment}) : super(key: key);
  final Function onTap;
  final String label;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment!=null ? alignment : AlignmentDirectional.center,
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