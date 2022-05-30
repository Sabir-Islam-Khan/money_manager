import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../screens/landing_page/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/user_model.dart';

import '../screens/login/login_screen.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    } else {
      return User(user.uid, user.email);
    }
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  String getUserUid() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<User?> signinWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    log("Signing in with email $email and password $password",
        name: "Firebase login");

    try {
      final creds = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(creds.user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(
            milliseconds: 2000,
          ),
          content: Text(
            "Email or Password is incorrect!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    log("Creating user with email $email and password $password",
        name: "Firebase auth, services.dart");
    try {
      final creds = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(creds.user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(
            milliseconds: 2000,
          ),
          content: Text(
            "User already exists!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LandingScreen(),
        ),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    log("Signing Out", name: "services/auth_service");
    return await _firebaseAuth.signOut();
  }
}
