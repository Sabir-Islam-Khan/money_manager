// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager/models/user_profile_model.dart';
import 'package:money_manager/providers/user_provider.dart';
import 'package:money_manager/screens/shop_page/components/shop_bottom_modal.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  String? shopName;
  String? shopId;
  ShopPage({Key? key, @required this.shopName, @required this.shopId})
      : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    UserProfile _profile = Provider.of<UserProvider>(context).getUserProfile;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            widget.shopName!,
          ),
        ),
        floatingActionButton: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(_profile.uid)
              .collection("shops")
              .doc(widget.shopId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            } else if (snapshot.hasData) {
              return FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ShopBottomModal(
                      uid: widget.shopId,
                      shopDue: snapshot.data!["total_due"],
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator(
                color: Colors.green,
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(_profile.uid)
                .collection("shops")
                .doc(widget.shopId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error Fetching Data"),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Due :",
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(_profile.uid)
                          .collection("shops")
                          .doc(widget.shopId)
                          .collection("collections")
                          .orderBy(
                            "timestamp",
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error Fetching Data"),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.size,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              Timestamp time =
                                  snapshot.data!.docs[index]["timestamp"];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 2.0,
                                ),
                                child: ListTile(
                                  tileColor: snapshot.data!.docs[index]
                                              ["type"] ==
                                          "collection"
                                      ? Colors.green[400]
                                      : Colors.red[400],
                                  title: Text(
                                    snapshot.data!.docs[index]["amount"]
                                        .toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        time.toDate().day.toString() +
                                            "-" +
                                            time.toDate().month.toString() +
                                            "-" +
                                            time.toDate().year.toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        "Note : ${snapshot.data!.docs[index]["note"]}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
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
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
            },
          ),
        ));
  }
}
