import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? uid;
  String? profilePicUrl;
  bool? isApproved;

  UserProfile({
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.uid,
    @required this.profilePicUrl,
    @required this.isApproved,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid,
      'profilePicUrl': profilePicUrl,
      'isApproved': isApproved,
    };
  }

  factory UserProfile.fromDocument(DocumentSnapshot document) {
    return UserProfile(
      username: document["username"] ?? "",
      firstName: document["firstName"] ?? "",
      lastName: document["lastName"] ?? "",
      email: document["email"] ?? "",
      uid: document["isApproved"] ?? "",
      profilePicUrl: document["profilePicUrl"] ?? "",
      isApproved: document["isApproved"] ?? "",
    );
  }
}
