import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_google_keep/home_page.dart';

TextEditingController notes_title = TextEditingController();
TextEditingController notes_content = TextEditingController();

class updateNotesPage extends StatefulWidget {
  final oldName;
  final oldContent;
  final id;

  updateNotesPage({
    Key? key,
    this.oldName,
    this.oldContent,
    this.id,
  }) : super(key: key);

  @override
  State<updateNotesPage> createState() => _AddNotesState();
}

class _AddNotesState extends State<updateNotesPage> {
  Future<void> updateNote() {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection("notes")
        .doc(widget.id)
        .update({
      'notes_title': notes_title.text,
      'notes_content': notes_content.text,
      "creation_date":
          DateFormat('dd-MM-yyyy hh:mm a', 'en_US').format(DateTime.now())
    }).then(((value) {
      print("User updated");
      Get.off(HomePage());
    })).catchError((error) => print("Failed to update user: $error"));
  }

  void initState() {
    notes_title.text = widget.oldName;
    notes_content.text = widget.oldContent;

    super.initState();
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
                height: 40,
              ),
              Text(
                "update Your Note",
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
                height: 20,
              ),
              TextField(
                  controller: notes_content,
                  maxLines: 10,
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
          updateNote();
        },
        label: Text(
          "update Notes",
          style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.tips_and_updates),
      ),
    );
  }
}
