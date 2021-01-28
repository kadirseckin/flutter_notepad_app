import 'package:flutter/material.dart';
import 'package:flutter_notes_app/database/database_helper.dart';
import 'package:flutter_notes_app/note_add_page.dart';

import 'models/note.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteAddPage("New note", null),
                )).then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.post_add_rounded),
        ),
        body: FutureBuilder(
          future: databaseHelper.getNotesList(),
          builder: (context, AsyncSnapshot<List<Note>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: changePriorityColor(
                                snapshot.data[index].notePriority),
                            radius: 14,
                          ),
                        ],
                      ),
                      title: Text(snapshot.data[index].noteTitle),
                      subtitle: Text(snapshot.data[index].noteDate),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return NoteAddPage(
                                        "Edit note", snapshot.data[index]);
                                  },
                                )).then((value) {
                                  setState(() {});
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  databaseHelper
                                      .deleteNote(snapshot.data[index].noteID);
                                });
                              }),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Color changePriorityColor(int notePriority) {
    if (notePriority == 1) {
      return Colors.green.shade500;
    } else if (notePriority == 2) {
      return Colors.yellow.shade600;
    } else if (notePriority == 3) {
      return Colors.red.shade400;
    }
  }
}
