// import 'package:flutter/cupertino.dart';
//
// import 'db_helper.dart';
//
// class DBProvider extends ChangeNotifier {
//   final DBHelper dbHelper;
//
//   DBProvider({required this.dbHelper});
//
//   List<Map<String, dynamic>> mData = [];
//   List<Map<String, dynamic>> notesToShow = [];
//   List<Map<String, dynamic>> findNotes = [];
//
//   Future<void> addNote(String title, String desc, String time, String category) async {
//     bool check = await dbHelper.addNote(
//       Title: title,
//       Desc: desc,
//       time: time,
//       category: category,
//     );
//     if (check) {
//       notesToShow = mData;
//       findNotes = mData;
//       notifyListeners();
//     }
//   }
//
//   Future<void> deleteNote(int id) async {
//     bool check = await dbHelper.deleteNote(id: id);
//     if (check) {
//       notesToShow = mData;
//       findNotes = mData;
//       notifyListeners();
//     }
//   }
//
//   Future<void> update(int id, String category, String title, String desc, String time) async {
//     await dbHelper.updateNote(title: title, desc: desc, time: time, id: id);
//     notesToShow = mData;
//       findNotes = mData;
//       notifyListeners();
//
//   }
//
//   List<Map<String, dynamic>> getAllNotes() => mData;
//
//   List<Map<String, dynamic>> getFindNotes() => findNotes;
//
//   Future<void> getInitialNotes() async {
//     mData = await dbHelper.getAllNotes();
//     notesToShow = mData;
//     findNotes = mData;
//     notifyListeners();
//   }
//
//   Future<void> getSpecificNotes(String category) async {
//     List<Map<String, dynamic>> specificNotes = await dbHelper.getAllNotes(category: category);
//     notesToShow = category == "All" ? mData : specificNotes;
//     findNotes = notesToShow;
//     notifyListeners();
//   }
//
//   void filterNotes(String keyword) {
//     findNotes = keyword.isEmpty
//         ? notesToShow
//         : notesToShow
//         .where((note) =>
//     note[DBHelper.NOTE_COLUMN_TITLE].toString().toLowerCase().contains(keyword.toLowerCase()))
//         .toList();
//     notifyListeners();
//   }
// }
import 'package:flutter/cupertino.dart';
import 'db_helper.dart';

class DBProvider extends ChangeNotifier {
  final DBHelper dbHelper;
  bool _isLoading=true;
  bool get isLoading=>_isLoading;

  DBProvider({required this.dbHelper});

  List<Map<String, dynamic>> _allNotes = [];
  String _currentFilter = '';
  String _currentCategory = 'All';
  List<Map<String, dynamic>> get allNotes => _allNotes;
  List<Map<String, dynamic>> get filteredNotes => _filterNotes();
  String get currentCategory => _currentCategory;

  Future<void> initialize() async {
    await _refreshAllNotes();
  }

  Future<void> _refreshAllNotes() async {
    _isLoading=true;
    notifyListeners();
    _allNotes = await dbHelper.getAllNotes();
    _isLoading=false;
    notifyListeners();
  }

  Future<bool> addNote(String title, String desc, String time, String category) async {
    try {
      final success = await dbHelper.addNote(
        Title: title,
        Desc: desc,
        time: time,
        category: category,
      );
      if (success) {
        await _refreshAllNotes();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding note: $e');
      return false;
    }
  }

  Future<bool> deleteNote(int id) async {
    try {
      final success = await dbHelper.deleteNote(id: id);
      if (success) {
        await _refreshAllNotes();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      return false;
    }
  }

  Future<bool> updateNote(int id, String category, String title, String desc, String time) async {
    try {
      await dbHelper.updateNote(
          title: title,
          desc: desc,
          time: time,
          id: id
      );
      await _refreshAllNotes();
      return true;
    } catch (e) {
      debugPrint('Error updating note: $e');
      return false;
    }
  }

  Future<void> filterByCategory(String category) async {
    _currentCategory = category;
    if (category == 'All') {
      await _refreshAllNotes();
    } else {
      _allNotes = await dbHelper.getAllNotes(category: category);
    }
    notifyListeners();
  }

  void filterByKeyword(String keyword) {
    _currentFilter = keyword.toLowerCase();
    notifyListeners();
  }

  List<Map<String, dynamic>> _filterNotes() {
    if (_currentFilter.isEmpty) {
      return _allNotes;
    }

    return _allNotes.where((note) {
      final title = note[DBHelper.NOTE_COLUMN_TITLE]?.toString().toLowerCase() ?? '';
      return title.contains(_currentFilter);
    }).toList();
  }
}
