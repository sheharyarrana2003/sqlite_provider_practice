import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_practice_flutter/Screens/home_screen.dart';
import 'package:sqlite_practice_flutter/modules/db_helper.dart';
import '../modules/cutom_text_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DBHelper? dbRef;
  String? _selectedCategory;

  List<String> categories = [
    'Work', 'Personal', 'Health', 'Family', 'Finance',
    'Shopping', 'Education', 'Travel', 'Goals',
  ];

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance();
  }

  String getCurrentTime() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLargeScreen = width > 600;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard when tapping outside
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Add Note", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.blue.shade600,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Container(
            width: isLargeScreen ? width * 0.5 : width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 3),
              ],
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height * 0.6,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create a New Note",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        label: "Title",
                        hint: "Enter note title",
                        controller: _noteController,
                        isPass: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a note title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        maxLines: 5,
                        label: "Description",
                        hint: "Enter note description",
                        controller: _desController,
                        isPass: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        icon: const Icon(Icons.category_rounded, color: Colors.blue),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        items: categories.map((String category) {
                          return DropdownMenuItem(value: category, child: Text(category));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Category",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a category";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            String currentTime = getCurrentTime();
                            if (_formKey.currentState!.validate()) {
                              await dbRef!.addNote(
                                Title: _noteController.text.trim(),
                                Desc: _desController.text.trim(),
                                category: _selectedCategory!,
                                time: currentTime,
                              );
                              Navigator.of(context).pop(true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Save Note",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
