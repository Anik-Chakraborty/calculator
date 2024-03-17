import 'package:calculator/config/colors.dart';
import 'package:calculator/views/BasicCal.dart';
import 'package:calculator/views/History.dart';
import 'package:calculator/views/ScientificCal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedScreenIndex = 0;

  final screens = [
    BasicCal(),
    ScientificCal(),
    History()
  ];

  btmNavBar(){
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calculator),
          label: 'Basic',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.squareRootVariable),
          label: 'Scientific',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.clock),
          label: 'History',
        ),
      ],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: GoogleFonts.montserrat(),
      selectedLabelStyle: GoogleFonts.montserrat(),
      selectedItemColor: AppColors.primaryColor,
      currentIndex: selectedScreenIndex,
      onTap: (value) {
        setState(() {
          selectedScreenIndex = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: btmNavBar(),
      body: screens[selectedScreenIndex]
    );
  }
}