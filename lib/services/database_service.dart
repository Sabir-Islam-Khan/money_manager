import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkIfUserExists(String uid) async {
  var user =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

  if (user.exists) {
    return true;
  } else {
    return false;
  }
}
