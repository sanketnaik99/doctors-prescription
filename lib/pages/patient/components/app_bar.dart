import 'package:flutter/material.dart';

class PatientAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  PatientAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "$title",
      ),
      backgroundColor: Colors.green,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
