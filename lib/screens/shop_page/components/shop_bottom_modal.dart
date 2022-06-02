import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/user_profile_model.dart';
import '../../../providers/user_provider.dart';

class ShopBottomModal extends StatefulWidget {
  String? uid;
  int? shopDue;
  ShopBottomModal({
    Key? key,
    @required this.uid,
    @required this.shopDue,
  }) : super(key: key);

  @override
  State<ShopBottomModal> createState() => _ShopBottomModalState();
}

class _ShopBottomModalState extends State<ShopBottomModal> {
  final TextEditingController _money = TextEditingController();
  final TextEditingController _collection = TextEditingController();
  final TextEditingController _note = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    UserProfile _profile = Provider.of<UserProvider>(context).getUserProfile;
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(_profile.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
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
                                "Note",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: totalWidth * 0.5,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _note,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "A note to remember.",
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
                                "Due",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: totalWidth * 0.5,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _money,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "0000",
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () async {
                          int due = snapshot.data!["total_due"];
                          int shopDue = widget.shopDue!;
                          int currentDue = int.parse(_money.value.text);
                          int dueToSet = due + currentDue;
                          log(
                            "total due is $due , current due is $currentDue  due to set is $dueToSet \n",
                            name: "add collection",
                          );
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .collection("shops")
                              .doc(widget.uid)
                              .collection("collections")
                              .add(
                            {
                              "amount": currentDue,
                              'timestamp': Timestamp.now(),
                              "type": "due",
                              "note": _note.value.text,
                            },
                          );

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .collection("shops")
                              .doc(widget.uid)
                              .update(
                            {
                              "total_due": shopDue + currentDue,
                            },
                          );
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .update(
                            {
                              "total_due": dueToSet,
                            },
                          ).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Add Due"),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: Text(
                          "Or",
                          style: GoogleFonts.roboto(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
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
                                "Collection",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: totalWidth * 0.5,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _collection,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "0000",
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () async {
                          int due = snapshot.data!["total_due"];
                          int shopDue = widget.shopDue!;
                          int collection = int.parse(_collection.value.text);
                          int dueToSet = due - collection;
                          log(
                            "total due is $due , current collection is $collection  due to set is $dueToSet \n",
                            name: "add collection",
                          );
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .collection("shops")
                              .doc(widget.uid)
                              .collection("collections")
                              .add(
                            {
                              "amount": collection,
                              'timestamp': Timestamp.now(),
                              'type': "collection",
                              "note": _note.value.text,
                            },
                          );
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .collection("shops")
                              .doc(widget.uid)
                              .update(
                            {
                              "total_due": shopDue - collection,
                            },
                          );
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(_profile.uid)
                              .update(
                            {
                              "total_due": dueToSet,
                            },
                          ).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Add Collection"),
                      ),
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
        ],
      ),
    );
  }
}
