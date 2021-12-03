// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:noteswithsqllite/addoreditNotes.dart';
import 'package:noteswithsqllite/models/note.dart';
import 'package:noteswithsqllite/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'addoreditNotes.dart';

class Notespage extends StatefulWidget {
  const Notespage({Key? key}) : super(key: key);

  @override
  _NotespageState createState() => _NotespageState();
}

class _NotespageState extends State<Notespage> {
  DatabaseHelper databaseHelper = DatabaseHelper(); //singleton instance
  List<Note> noteList = <Note>[];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    // if (noteList == null) {
    //   noteList = <Note>[];//if initially null then instanciate it
    //   //instanciate:- to the creation of an object (or an “instance” of a given class)
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      getPriorityColor(this.noteList[position].priority!),
                  child: getPriorityIcon(this.noteList[position].priority!),
                ),
                title: Text(this.noteList[position].title!),
                subtitle: Text(this.noteList[position].date!),
                trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      _delete(context, noteList[position]);
                      navigateToDetail(this.noteList[position], 'Edit Note');
                    }),
                // onTap: Navigator.push(context,
                //     MaterialPageRoute(builder: (context) {
                //   return Addoreditnotes();
                // })),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 2, ''), 'Add Note');
        },
        tooltip: "Add Notes",
        child: Icon(Icons.add),
      ),
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      SnackBar(
        content: Text('Note Deleated Successfully'),
      );
      updateListView(note);
    }
  }

  void updateListView(Note note) {
    //Singleton instance of Database
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList(note);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void navigateToDetail(Note note, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Addoreditnotes(note, title);
    }));
  }
}
