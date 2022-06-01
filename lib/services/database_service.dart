import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_manager/models/user_profile_model.dart';

class DatabaseService {
  Future<bool> checkIfUserExists(String uid) async {
    var user =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (user.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createProfile(
    String username,
    String firstName,
    String lastName,
    String uid,
    String email,
    String picLink,
  ) async {
    Reference reference =
        FirebaseStorage.instance.ref("profile_pictures/$uid.png");

    final TaskSnapshot snapshot = await reference.putFile(
      File(picLink),
    );

    String url = await snapshot.ref.getDownloadURL();

    UserProfile profile = UserProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      uid: uid,
      profilePicUrl: url,
      isApproved: false,
      totalDue: 0,
    );

    FirebaseFirestore.instance.collection("users").doc(uid).set(
          profile.toMap(),
        );

    bool isCreated = await checkIfUserExists(uid);

    return isCreated;
  }
}
