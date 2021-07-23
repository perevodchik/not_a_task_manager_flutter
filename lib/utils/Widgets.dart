import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Const.dart';

Future<dynamic> showAppDialog(Widget widget) async {
  return await showDialog(
      context: appKey.currentContext!,
      builder: (c) => Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                    color: Colors.transparent,
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10
                        ),
                        child: widget
                    )
                )
              ]
          )
      )
  );
}

Future<void> progressDialog({BuildContext? context}) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context ?? appKey.currentContext!,
      builder: (BuildContext context) {
        return Center(
            child: CircularProgressIndicator()
        );
      }
  );
}