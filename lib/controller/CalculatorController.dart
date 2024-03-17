import 'package:get/get.dart';

class CalculatorController extends GetxController{
  RxString result = "0".obs;
  RxString equation = "0".obs;

  updateResult(String res){
    result.value = res;
  }

  updateEquation(String equ){
    equation.value = equ;
  }

}