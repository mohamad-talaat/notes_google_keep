// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:notes_google_keep/appStyle.dart';
import 'package:notes_google_keep/login_page.dart';
import 'package:notes_google_keep/operation/add_notes.dart';
import 'package:notes_google_keep/operation/card_notes.dart';
import 'package:notes_google_keep/operation/update_notes.dart';

class HomePage extends StatefulWidget {
  var color_id;
  HomePage({Key? key, this.color_id}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: appStyle.cardColor[widget.color_id],
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Center(
            child: Text(
              "Notes App",
              style:
                  GoogleFonts.abel(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  GoogleSignIn googleAccount = GoogleSignIn();
                  googleAccount.disconnect();

                  Get.off(loginPage());
                },
                icon: Icon(Icons.exit_to_app))
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("notes")
              .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }

            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return CardNotes(
                  color_id: appStyle.cardColor[index],
                  notes_title: "${snapshot.data!.docs[index]["notes_title"]}",
                  creation_date:
                      "${snapshot.data!.docs[index]["creation_date"]}",
                  notes_content:
                      "${snapshot.data!.docs[index]["notes_content"]}",
                  ontap: () {
                    Get.to(updateNotesPage(
                      oldName: snapshot.data!.docs[index]["notes_title"],
                      oldContent: snapshot.data!.docs[index]["notes_content"],
                      id: snapshot.data!.docs[index].id,
                    ));
                  },
                  deleteButton: () {
                    FirebaseFirestore.instance
                        .collection("notes")
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          String formattedDateTime =
              DateFormat('dd-MM-yyyy hh:mm a', 'en_US').format(DateTime.now());
          try {
            Get.off(AddNotesPage(
              creation_date: formattedDateTime,
            ));
          } catch (e) {
            print('Error parsing DateTime: $e');
          }
        },
        label: Text(
          "Add Notes",
          style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}
