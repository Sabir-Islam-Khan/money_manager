import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager/models/user_profile_model.dart';
import 'package:money_manager/providers/user_provider.dart';
import 'package:money_manager/screens/create_profile/create_profile.dart';
import 'package:money_manager/screens/home_screen/components/custom_bottom_modal.dart';
import 'package:money_manager/screens/shop_page/shop_page.dart';
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

  @override
  Widget build(BuildContext context) {
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
                            return const CustomModalSheet();
                          },
                        );
                      },
                    ),
                    body: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(_profile.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total Due : ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.green,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      snapshot.data!["total_due"].toString(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[800],
                                      ),
                                    )
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return const Text("Error loading data");
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .collection("shops")
                              .orderBy("shopName")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.size,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 15.0,
                                      bottom: 10.0,
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15.0),
                                      elevation: 5.0,
                                      shadowColor: Colors.teal,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShopPage(
                                                shopName: snapshot.data!
                                                    .docs[index]["shopName"],
                                                shopId: snapshot
                                                    .data!.docs[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.green[400]!,
                                                Colors.green[300]!,
                                                Colors.green[200]!,
                                                Colors.green[100]!,
                                                Colors.green[50]!,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ["shopName"],
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ["shopLocation"],
                                                style: GoogleFonts.roboto(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  )
            : const CreateProfileScreen();
  }
}
