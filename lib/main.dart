import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_manager/money_manager_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();
  runApp(
    const MoneyManagerApp(),
  );
}
