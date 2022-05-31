import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/user_profile_model.dart';
import 'package:money_manager/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  bool hasCompletedProfile = false;

  void checkUserProfile(String uid) async {
    bool profile = await DatabaseService().checkIfUserExists(uid);

    hasCompletedProfile = profile;
    notifyListeners();
  }

  void fetchUserProfile(uid) async {
    var data =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    profile = UserProfile.fromDocument(data);
    notifyListeners();
  }

  UserProfile profile = UserProfile(
    username: "",
    firstName: "",
    lastName: "",
    email: "",
    uid: "",
    profilePicUrl: "",
    isApproved: false,
  );

  get checkIfProfileCompleted {
    return hasCompletedProfile;
  }

  get getUserProfile {
    return profile;
  }
}
