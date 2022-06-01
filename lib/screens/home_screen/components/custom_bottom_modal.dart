import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_profile_model.dart';
import '../../../providers/user_provider.dart';

class CustomModalSheet extends StatefulWidget {
  const CustomModalSheet({Key? key}) : super(key: key);

  @override
  State<CustomModalSheet> createState() => _CustomModalSheetState();
}

class _CustomModalSheetState extends State<CustomModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopLocationController = TextEditingController();
  final TextEditingController _shopNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    UserProfile _profile = Provider.of<UserProvider>(context).getUserProfile;
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  right: 18.0,
                  left: 18.0,
                ),
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Shop    ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: totalWidth * 0.5,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop Name';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        controller: _shopNameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Uttora Biponi",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  right: 18.0,
                  left: 18.0,
                ),
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: totalWidth * 0.5,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop location';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        controller: _shopLocationController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration.collapsed(
                          hintText: "BDR Gate",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  right: 18.0,
                  left: 18.0,
                ),
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Number",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: totalWidth * 0.5,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop phone number.';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        controller: _shopNumberController,
                        keyboardType: TextInputType.phone,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration.collapsed(
                          hintText: " 01XXXXXXXXX",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(_profile.uid)
                      .collection("shops")
                      .add(
                    {
                      "shopName": _shopNameController.value.text,
                      "shopLocation": _shopLocationController.value.text,
                      "shopNumber": _shopNumberController.value.text,
                      "total_due": 0,
                    },
                  ).then(
                    (value) {
                      log("Adding Shop Successfull",
                          name: "Homepage bottom sheet");
                      Navigator.pop(context);
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Data'),
                    ),
                  );
                }
              },
              child: const Text("Add Shop"),
            )
          ],
        ),
      ),
    );
  }
}
