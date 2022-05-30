import 'package:flutter/material.dart';
import 'package:money_manager/screens/home_screen/home_screen.dart';

import 'package:provider/provider.dart';
import 'dart:developer';

import 'models/user_model.dart';
import 'screens/landing_page/landing_page.dart';
import 'services/auth_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String className = "Wrapper";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Called!", name: "Wrapper");
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? const LandingScreen() : const HomeScreen();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
