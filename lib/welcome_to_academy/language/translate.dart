import 'package:academy/main.dart';
import 'ENG.dart';
import 'TH.dart';

Future<String>? futureLoadData;
Future<String> loadData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate a network call
  return 'Data Loaded';
}

Future<void> allTranslate() async {
  if (selectedRadio == 1) {
    TH();
  } else if (selectedRadio == 2) {
    ENG();
  }
}

String Search = '';
String Search1 = '';
String Search2 = '';
String Search3 = '';
String Search4 = '';
String Search5 = '';
String Search6 = '';
String Search7 = '';
String Search8 = '';
String Search9 = '';
String Search10 = '';
String Search11 = '';
String Search12 = '';
String Search13 = '';
String Search14 = '';
String Search15 = '';
String Search16 = '';
String Search17 = '';
String Search18 = '';
String Search19 = '';
String Search20 = '';
String Search21 = '';
String Search22 = '';
String Search23 = '';
String Search24 = '';
String Search25 = '';
String Search26 = '';
String Search27 = '';
String Search28 = '';
String Search29 = '';
String Search30 = '';
