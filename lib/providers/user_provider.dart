import 'package:flutter/material.dart';
import 'package:money_manager/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  bool hasCompletedProfile = false;

  void checkUserProfile(String uid) async {
    bool profile = await checkIfUserExists(uid);

    hasCompletedProfile = profile;
  }

  get checkIfProfileCompleted {
    return hasCompletedProfile;
  }
}
