import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/wrapper.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';

class MoneyManagerApp extends StatefulWidget {
  const MoneyManagerApp({Key? key}) : super(key: key);

  @override
  State<MoneyManagerApp> createState() => _MoneyManagerAppState();
}

class _MoneyManagerAppState extends State<MoneyManagerApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("SOmething went wrong"),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<AuthService>(
                create: (_) => AuthService(),
              ),
            ],
            child: const MaterialApp(
              home: Wrapper(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
