import 'dart:io';

import 'package:Calmission/common_widgets/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformLoadingIndicator extends PlatformWidget {
  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoActivityIndicator();
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return CircularProgressIndicator();
  } 
}