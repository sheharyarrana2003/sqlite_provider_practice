import 'package:flutter/cupertino.dart';

import 'db_helper.dart';

class DBProvider extends ChangeNotifier {
  final DBHelper dbHelper;

  DBProvider({required this.dbHelper});

  List<Map<String, dynamic>> mData = [];
  List<Map<String, dynamic>> notesToShow = [];
  List<Map<String, dynamic>> findNotes = [];

  Future<void> addNote(String title, String desc, String time, String category) async {
    bool check = await dbHelper.addNote(
      Title: title,
      Desc: desc,
      time: time,
      category: category,
    );
    if (check) {
      notesToShow = mData;
      findNotes = mData;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id) async {
    bool check = await dbHelper.deleteNote(id: id);
    if (check) {
      notesToShow = mData;
      findNotes = mData;
      notifyListeners();
    }
  }

  Future<void> update(int id, String category, String title, String desc, String time) async {
    await dbHelper.updateNote(title: title, desc: desc, time: time, id: id);
    notesToShow = mData;
      findNotes = mData;
      notifyListeners();

  }

  List<Map<String, dynamic>> getAllNotes() => mData;

  List<Map<String, dynamic>> getFindNotes() => findNotes;

  Future<void> getInitialNotes() async {
    mData = await dbHelper.getAllNotes();
    notesToShow = mData;
    findNotes = mData;
    notifyListeners();
  }

  Future<void> getSpecificNotes(String category) async {
    List<Map<String, dynamic>> specificNotes = await dbHelper.getAllNotes(category: category);
    notesToShow = category == "All" ? mData : specificNotes;
    findNotes = notesToShow;
    notifyListeners();
  }

  void filterNotes(String keyword) {
    findNotes = keyword.isEmpty
        ? notesToShow
        : notesToShow
        .where((note) =>
    note[DBHelper.NOTE_COLUMN_TITLE].toString().toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
