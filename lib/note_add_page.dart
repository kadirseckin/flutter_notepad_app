import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes_app/database/database_helper.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';

class NoteAddPage extends StatefulWidget {
  String noteInfo;
  Note note;

  NoteAddPage(this.noteInfo, this.note);

  @override
  _NoteAddPageState createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  var key = GlobalKey<FormState>();
  DatabaseHelper databaseHelper;
  int priorityValue;
  String noteTitle;
  String noteContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    if (widget.note == null) {
      priorityValue = 1;
    } else {
      priorityValue = widget.note.notePriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.noteInfo),
      ),
      body: Form(
        key: key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                initialValue:
                    widget.note == null ? "" : (widget.note.noteTitle),
                onSaved: (newValue) {
                  noteTitle = newValue;
                },
                validator: (value) {
                  if (value.length == 0) {
                    return "Please enter the title";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //always shows label text
                  labelText: "Content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onSaved: (newValue) {
                  noteContent = newValue;
                },
                validator: (value) {
                  if (value.length == 0) {
                    return "Please enter the content";
                  } else {
                    return null;
                  }
                },
                initialValue:
                    widget.note == null ? "" : (widget.note.noteContent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Priority : ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.teal, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        value: priorityValue,
                        onChanged: (value) {
                          setState(() {
                            priorityValue = value;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text("Low"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Medium"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("High"),
                            value: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                onPressed: () {
                  String hour;
                  if (DateTime.now().hour < 12 && DateTime.now().hour != 0) {
                    debugPrint(DateTime.now().hour.toString());
                    hour = "hh";
                  } else {
                    hour = "HH";
                  }

                  if (key.currentState.validate()) {
                    key.currentState.save();
                    if (widget.note == null) {
                      databaseHelper.addNote(Note(
                          noteTitle,
                          noteContent,
                          formatDate(DateTime.now(), [
                            dd,
                            '/',
                            mm,
                            '/',
                            yyyy,
                            ' - ',
                            '$hour',
                            ':',
                            'nn'
                          ]).toString(),
                          priorityValue));
                      Navigator.pop(context);
                    } else {
                      databaseHelper.updateNote(Note.withID(
                          widget.note.noteID,
                          noteTitle,
                          noteContent,
                          formatDate(DateTime.now(), [
                            dd,
                            '/',
                            mm,
                            '/',
                            yyyy,
                            ' - ',
                            '$hour',
                            ':',
                            'nn'
                          ]).toString(),
                          priorityValue));
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.lightGreen),
          ],
        ),
      ),
    );
  }
}
