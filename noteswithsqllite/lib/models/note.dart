//! to Create Database Table
// ignore_for_file: unnecessary_this

class Note {
  int? _id;
  String _title;
  String _description;
  String _date;
  int _priority;

//Constructor with optional description
  Note(this._title, this._date, this._priority, this._description);
  //Named Constructor
  Note.withID(
      this._id, this._title, this._date, this._priority, this._description);

//Getters
  int? get id => _id;
  String get title => _title;
  String get date => _date;
  String get description => _description;
  int get priority => _priority;

//Setters [id setter not required bcoz it is self generated]
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      //Validation layer
      this._title = newTitle;
    }
  }

  set date(String newDate) {
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //SQFlite deals only with map objects
  //before Saving data you must convert Note obj to Map obj
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    //In key/value value is dynamic bcoz it can be both String and int. Key is always String
    //for insert id = null, for Update id = (some value)
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //before Retrieving data you must convert Map obj to Note obj
  Note.fromMapObject(Map<String, dynamic> map) {
    //Named Constructor
    this._id = map['id'];
    this._description = map['description'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
