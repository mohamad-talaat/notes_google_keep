// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_google_keep/home_page.dart';

class AddNotesPage extends StatefulWidget {
  late String creation_date;
  final color_id; // تعريف color_id هنا

  AddNotesPage({
    Key? key,
    required this.creation_date,
    this.color_id,
  }) : super(key: key);

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  var notes_title = TextEditingController();

  var notes_content = TextEditingController();

  // var color_id;

  Future<void> addNote() {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance.collection("notes").add({
      'notes_title': notes_title.text, // John Doe
      'notes_content': notes_content.text, // Stokes and Sons
      'creation_date': widget.creation_date.toString(),
      "id": FirebaseAuth.instance.currentUser!.uid,
      "color_id": widget.color_id
    }).then(((value) {
      print("User Added");
      Get.to(HomePage());
    })).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Add Your Note",
                style:
                    GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: notes_title,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: "notes title", border: InputBorder.none)),
              SizedBox(
                height: 15,
              ),
              // Text("${creation_date ?? 'Default Value'}"),
              SizedBox(
                height: 15,
              ),
              TextField(
                  controller: notes_content,
                  maxLines: 5,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: "notes content", border: InputBorder.none)),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addNote();
        },
        label: Text("Add Notes"),
        icon: Icon(Icons.tips_and_updates),
      ),
    );
  }
}
