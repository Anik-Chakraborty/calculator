import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget calcButton(
context,
    String buttonText, Color buttonColor, void Function()? buttonPressed) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.24,
    height: MediaQuery.of(context).size.width *  (buttonText == '=' ? 0.5 : 0.24),
    padding: const EdgeInsets.all(0),
    child: ElevatedButton(
      onPressed: buttonPressed,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: buttonColor),
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(fontSize: 30, color: Colors.white),
      ),
    ),
  );
}