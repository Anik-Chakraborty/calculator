import 'package:calculator/config/colors.dart';
import 'package:calculator/controller/CalculatorController.dart';
import 'package:calculator/controller/functions.dart';
import 'package:calculator/widget/calc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class ScientificCal extends StatefulWidget {
  const ScientificCal({Key? key}) : super(key: key);

  @override
  State<ScientificCal> createState() => _ScientificCalState();
}

class _ScientificCalState extends State<ScientificCal> {

  CalculatorController calController = Get.put(CalculatorController());
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    // used to check if the result contains a decimal
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }
      return result;
    }

    if (buttonText == "AC") {
      calController.equation.value = "0";
      calController.result.value = "0";
    } else if (buttonText == "⌫") {

      String lastCh = calController.equation.value[calController.equation.value.length-1];

      if(lastCh == 'g' || lastCh == 'n' || lastCh == 's'){
        if(calController.equation.value[calController.equation.value.length-2] == 'l'){
          calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 2);
        }
        else{
          calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 3);
        }
      }
      else if(lastCh =='(' && calController.equation.value.length>=3 && calController.equation.value.substring(calController.equation.value.length - 3, calController.equation.value.length) == "lg("){
        calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 3);
      }
      else if(lastCh =='(' && calController.equation.value.length>=3 && calController.equation.value.substring(calController.equation.value.length - 3, calController.equation.value.length) == "\u00B3√("){
        calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 3);
      }
      else if(lastCh =='(' && calController.equation.value.length>=2 && calController.equation.value.substring(calController.equation.value.length - 2, calController.equation.value.length) == "√("){
        calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 2);
      }
      else{
        calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length - 1);
      }
      if (calController.equation.value == "") {
        calController.equation.value = "0";
      }
    } else if (buttonText == "+/-") {
      if (calController.equation.value[0] != '-') {
        calController.equation.value = "-${calController.equation.value}";
      } else {
        calController.equation.value = calController.equation.value.substring(1);
      }
    } else if (buttonText == "=") {
      expression = calController.equation.value;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll('%', '%');
      expression = expression.replaceAll('\u00B3√', 'cbrt');
      expression = expression.replaceAll('\u00B2', '^2');
      expression = expression.replaceAll('\u00B3', '^3');
      expression = expression.replaceAll('lg', 'log2');
      expression = expression.replaceAll('√', 'sqrt');

      expression = replaceCubeRoots(expression);

      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);

        ContextModel cm = ContextModel();
        calController.result.value = '${exp.evaluate(EvaluationType.REAL, cm)}';
        if (expression.contains('%')) {
          calController.result.value = doesContainDecimal(calController.result.value);
        }

        if(calController.result.value.contains('.')){
          calController.result.value = double.parse(calController.result.value).toStringAsFixed(5);
          if(calController.result.value[calController.result.value.length-1] == "0"){
            calController.result.value = removeTrailingZeros(calController.result.value);
          }
        }

        saveHistory(calController.result.value, calController.equation.value);

      } catch (e) {
        calController.result.value = "Error";
      }
    } else {
      if (calController.equation.value == "0" && (buttonText == '-' || buttonText == 'ln' || buttonText == 'tan' || buttonText == 'lg(' || buttonText == 'cos' || buttonText == 'sin' || buttonText == '√(' || buttonText == '\u00B3√(')) {
        calController.equation.value = buttonText;
      }
      else if((calController.equation.value == "0" || calController.equation.value == "-") && (buttonText == '+' || buttonText == '×' || buttonText == '÷' || buttonText == '%')){
        //do nothing
      }
      else if((calController.equation.value[calController.equation.value.length-1] == '(' && buttonText == '(') || (calController.equation.value[calController.equation.value.length-1] == ')' && buttonText == ')')){
        //do nothing
      }
      else if((buttonText == '-' || buttonText == '+' || buttonText == '×' || buttonText == '÷' || buttonText == '%') && (calController.equation.value.endsWith('+') || calController.equation.value.endsWith('-') || calController.equation.value.endsWith('×') || calController.equation.value.endsWith('÷') || calController.equation.value.endsWith('%'))){
        calController.equation.value = calController.equation.value.substring(0, calController.equation.value.length-1)+buttonText;
      }
      else if(calController.equation.value == "0" && (buttonText == "0" || buttonText == "1" || buttonText == "2" || buttonText == "3" || buttonText == "4" || buttonText == "5" || buttonText == "6" || buttonText == "7" || buttonText == "8" || buttonText == "9")){
        calController.equation.value = buttonText;
      }
      else {
        calController.equation.value = calController.equation.value + buttonText;
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      // height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Obx(()=> Text(calController.result.value,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 60))),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    border: Border.all(color: Colors.transparent)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        child: Obx(()=> Text(calController.equation.value,
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              color: Colors.grey,
                            ))),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onLongPress: () {
                        calController.equation.value = "0";
                        calController.result.value = "0";
                      },
                      child: IconButton(
                        icon: const Icon(Icons.backspace,
                            color: Colors.black38, size: 25),
                        onPressed: () {
                          buttonPressed("⌫");
                        },
                      ),
                    ),],
                ),
              ),
              Container(
                  color: Colors.black.withOpacity(0.9),
                  height: MediaQuery.of(context).size.width * 1.26,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          calcButton(context, 'ac', Colors.black, () => buttonPressed('AC')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '(', Colors.grey, () => buttonPressed('(')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'x\u00B2', Colors.grey, () => buttonPressed('\u00B2')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '√', Colors.grey, () => buttonPressed('√(')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'sin', Colors.grey, () => buttonPressed('sin')),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Column(
                        children: [
                          calcButton(context, '%', Colors.black, () => buttonPressed('%')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, ')', Colors.grey, () => buttonPressed(')')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'x\u00B3', Colors.grey, () => buttonPressed('\u00B3')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '\u00B3√', Colors.grey, () => buttonPressed('\u00B3√(')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'cos', Colors.grey, () => buttonPressed('cos')),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Column(
                        children: [
                          calcButton(context, '÷', Colors.black, () => buttonPressed('÷')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '!', Colors.grey, () => buttonPressed('!')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'lg', Colors.grey, () => buttonPressed('lg(')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'ln', Colors.grey, () => buttonPressed('ln')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, 'tan', Colors.grey, () => buttonPressed('tan')),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Column(
                        children: [
                          calcButton(context, "×", Colors.black, () => buttonPressed('×')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '-', Colors.black, () => buttonPressed('-')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '+', Colors.black, () => buttonPressed('+')),
                          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                          calcButton(context, '=', AppColors.primaryColor, () => buttonPressed('=')),
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
        ));
  }
}
