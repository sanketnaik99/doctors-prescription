import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorPatientCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String imagePath;
  final String title;
  final double elevation;
  DoctorPatientCard({
    this.backgroundColor,
    this.imagePath,
    this.title,
    this.elevation,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 80.0,
                height: 80.0,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
