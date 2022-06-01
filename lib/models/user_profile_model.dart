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
  int? totalDue;

  UserProfile({
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.uid,
    @required this.profilePicUrl,
    @required this.isApproved,
    @required this.totalDue,
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
      'total_due': totalDue,
    };
  }

  factory UserProfile.fromDocument(DocumentSnapshot document) {
    return UserProfile(
      username: document["username"] ?? "",
      firstName: document["firstName"] ?? "",
      lastName: document["lastName"] ?? "",
      email: document["email"] ?? "",
      uid: document["uid"] ?? "",
      profilePicUrl: document["profilePicUrl"] ?? "",
      isApproved: document["isApproved"] ?? "",
      totalDue: document["total_due"] ?? 0,
    );
  }
}
