import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardNotes extends StatelessWidget {
  final Color color_id; // تعريف color_id هنا
  final Function()? ontap;
  final Function()? deleteButton;
  final notes_title;
  final notes_content;
  final creation_date;

  const CardNotes(
      {Key? key,
      required this.ontap,
      this.notes_title,
      this.notes_content,
      this.creation_date,
      required this.deleteButton,
      required this.color_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color_id,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("${notes_title}",
                      style: GoogleFonts.abel(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Spacer(),
                  IconButton(
                      onPressed: deleteButton,
                      icon: Icon(
                        Icons.highlight_remove_outlined,
                        color: Colors.red.shade700,
                      ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("${creation_date}", style: GoogleFonts.abel(fontSize: 13)),
              SizedBox(
                height: 5,
              ),
              Text("${notes_content}",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3),
            ],
          )),
    );
  }
}
