import 'package:flutter/material.dart';

//hidecurrentsnackbar because we want to close the existing one before showing another snackbar
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}
