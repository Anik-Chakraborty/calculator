import 'dart:math';

import 'package:calculator/config/strings.dart';
import 'package:calculator/models/HistoryModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String replaceCubeRoots(String input) {
  RegExp regex = RegExp(r'cbrt\((\d+(\.\d+)?)\)');
  String modifiedString = input.replaceAllMapped(regex, (Match match) {
    double value = double.parse(match.group(1)!);
    return cbrt(value).toString();
  });
  return modifiedString;
}

num cbrt(double x) {
  return pow(x, 1/3);
}

String removeTrailingZeros(String input) {
  List<String> parts = input.split('.');
  if (parts.length == 2) {
    // Remove trailing zeros from the fractional part
    parts[1] = parts[1].replaceAll(RegExp(r'0*$'), '');
    if (parts[1].isEmpty) {
      // If the fractional part is empty after removing zeros, remove the decimal point as well
      return parts[0];
    }
    // Join the parts back together with a decimal point
    return '${parts[0]}.${parts[1]}';
  }
  return input;
}


saveHistory(String? value, String? expression) async{
  if(value!=null && expression != null && expression.isNotEmpty && expression != '0' && (expression.contains('+') || expression.contains('-') || expression.contains('×') || expression.contains('÷') || expression.contains('%'))){

    final directory = await getApplicationDocumentsDirectory();

    final collection = await BoxCollection.open(
      AppConstants.calculatorDB, // Name of your database
      {AppConstants.historyBox}, // Names of your boxes
      path: directory.path, // Path where to store your boxes (Only used in Flutter / Dart IO)
    );

    final historyBox = await collection.openBox<Map>(AppConstants.historyBox);

    Random random = Random();

    // Generate a random three-digit number
    int randomNumber = random.nextInt(900) + 100;

    HistoryModel data = HistoryModel(expression, value.toString(), DateFormat('MMM dd yyyy').format(DateTime.now()));
    await historyBox.put(randomNumber.toString(), data.toMap());

  }
}