// ignore_for_file: file_names, prefer_const_constructors, unnecessary_this, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteswithsqllite/utils/database_helper.dart';

import 'models/note.dart';

class Addoreditnotes extends StatefulWidget {
  // const Addoreditnotes({Key? key}) : super(key: key);
  final String appbarTitle;
  final Note note;

  const Addoreditnotes(this.note, this.appbarTitle, {Key? key})
      : super(key: key);

  @override
  _AddoreditnotesState createState() =>
      _AddoreditnotesState(this.note, this.appbarTitle);
}

class _AddoreditnotesState extends State<Addoreditnotes> {
  static var priorities = ['High', 'Low'];
  String appbarTitle;
  Note note;
  _AddoreditnotesState(this.note, this.appbarTitle);

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController discriptioncontroller = TextEditingController();

  DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: priorities.map((String X) {
                  return DropdownMenuItem<String>(value: X, child: Text(X));
                }).toList(),
                value: getpriorityasString(note.priority),
                onChanged: (changed) {
                  setState(() {
                    updatepriorityasInt(changed);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titlecontroller,
                onChanged: (changed) {
                  note.title = titlecontroller.text;
                },
                decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: discriptioncontroller,
                onChanged: (changed) {
                  note.description = discriptioncontroller.text;
                },
                decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              save();
                            });
                          },
                          child: Text('SAVE'))),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            delete();
                          },
                          child: Text('DELETE'))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatepriorityasInt(Object? value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getpriorityasString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = priorities[0];
        break;
      case 2:
        priority = priorities[1];
        break;
    }
    return priority;
  }

  void save() async {
    Navigator.pop(context, true);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result = 0;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void delete() async {
    Navigator.pop(context, true);
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleated');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleated Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleating Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
