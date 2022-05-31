import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/user_profile_model.dart';
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
    loader();
    Provider.of<UserProvider>(context, listen: false)
        .checkUserProfile(FirebaseAuth.instance.currentUser!.uid);
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserProfile(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  final AuthService _authService = AuthService();
  bool isLoading = true;

  void loader() async {
    Future.delayed(
      const Duration(milliseconds: 1000),
    ).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopLocationController = TextEditingController();
  final TextEditingController _shopNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    bool hasCompletedProfile =
        Provider.of<UserProvider>(context).checkIfProfileCompleted;
    UserProfile _profile = Provider.of<UserProvider>(context).getUserProfile;

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          )
        : hasCompletedProfile
            ? _profile.isApproved! == false
                ? const Scaffold(
                    body: Center(
                      child: Text(
                        'Please Wait for Admin to Approve',
                      ),
                    ),
                  )
                : Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      centerTitle: true,
                      title: const Text("Dashboard"),
                      backgroundColor: Colors.green,
                      actions: [
                        IconButton(
                          onPressed: () {
                            _authService.signOut();
                          },
                          icon: const Icon(
                            Icons.logout,
                          ),
                        )
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.green,
                      elevation: 5.0,
                      child: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
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
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Shop    ",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: totalWidth * 0.5,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter shop Name';
                                                  }
                                                  return null;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _shopNameController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration:
                                                    const InputDecoration
                                                        .collapsed(
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
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Location",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: totalWidth * 0.5,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter shop location';
                                                  }
                                                  return null;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    _shopLocationController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration:
                                                    const InputDecoration
                                                        .collapsed(
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
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Number",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: totalWidth * 0.5,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter shop phone number.';
                                                  }
                                                  return null;
                                                },
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller:
                                                    _shopNumberController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration:
                                                    const InputDecoration
                                                        .collapsed(
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
                                              "shopName": _shopNameController
                                                  .value.text,
                                              "shopLocation":
                                                  _shopLocationController
                                                      .value.text,
                                              "shopNumber":
                                                  _shopNumberController
                                                      .value.text,
                                            },
                                          ).then(
                                            (value) {
                                              log("Adding Shop Successfull",
                                                  name:
                                                      "Homepage bottom sheet");
                                              Navigator.pop(context);
                                            },
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                          },
                        );
                      },
                    ),
                  )
            : const CreateProfileScreen();
  }
}
