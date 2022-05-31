import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/providers/user_provider.dart';
import 'package:money_manager/screens/create_profile/create_profile.dart';
import 'package:money_manager/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false)
        .checkUserProfile(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    bool hasCompletedProfile =
        Provider.of<UserProvider>(context).checkIfProfileCompleted;

    return hasCompletedProfile
        ? Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  _authService.signOut();
                },
                child: const Text("Sign Out"),
              ),
            ),
          )
        : const CreateProfile();
  }
}
