import "package:flutter/material.dart";
import 'package:stork_uz/pages/auth/auth_ui_config.dart';

class ErrorMessageValidator extends StatelessWidget {
  const ErrorMessageValidator({
    Key? key,
    required this.err,
  }) : super(key: key);

  final String err;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: LoginCardWith,
      margin: EdgeInsets.only(top: 5),
        child: Text(err,style: TextStyle(color: Colors.red.withOpacity(0.8),fontSize: 12),),
    );
  }
}
