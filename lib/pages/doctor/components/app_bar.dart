import 'package:flutter/material.dart';

class DoctorAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  DoctorAppBar({@required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Text('$title'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
