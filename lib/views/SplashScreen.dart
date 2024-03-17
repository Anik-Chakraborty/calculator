import 'package:calculator/config/colors.dart';
import 'package:calculator/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen(),)));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.calculator, color: AppColors.primaryColor, size: 60),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Calculator', style: GoogleFonts.montserrat(
                fontSize: 20,
                color: AppColors.primaryColor
              ),),
            ],
          )
        ],
      ),
    );
  }

}