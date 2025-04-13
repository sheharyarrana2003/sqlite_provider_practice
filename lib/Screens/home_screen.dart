import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_practice_flutter/Screens/profile_screen.dart';
import 'package:sqlite_practice_flutter/modules/category_color.dart';
import 'package:sqlite_practice_flutter/modules/db_helper.dart';
import '../modules/cutom_text_field.dart';
import '../modules/db_provider.dart';
import '../modules/theme_provider.dart';
import '../modules/theme_toggle.dart';
import '../modules/update_dialog.dart';
import 'add_task.dart';
import 'note_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbRef;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController=TextEditingController();
  List<String> categories = [
    'All','Work', 'Personal', 'Health', 'Family', 'Finance',
    'Shopping', 'Education', 'Travel', 'Goals',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DBProvider>().initialize();
    });
  }


  String getCurrentTime() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: themeProvider.getBackgroundColor(),
        appBar: AppBar(
          backgroundColor: themeProvider.getPrimaryColor(),
          title: Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              icon: Icon(Icons.person, color: Colors.white),
            ),
            ThemeToggle(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeProvider.getPrimaryColor(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          icon: Icon(Icons.add, color: Colors.white),
          label: Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTask()));
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
              child: Consumer<DBProvider>(
                builder: (context, provider, _) {
                  return TextField(
                    controller: _searchController,
                    onChanged: provider.filterByKeyword,
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
                      suffixIcon: Icon(Icons.search, color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
                      filled: true,
                      fillColor: themeProvider.getSurfaceColor(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: h * 0.01),
            // Categories row
            Consumer<DBProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      final isSelected = categories[index] == provider.currentCategory;
                      return GestureDetector(
                        onTap: () => provider.filterByCategory(categories[index]),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.008),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeProvider.getPrimaryColor().withOpacity(0.8)
                                : getCategoryColor(categories[index]),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
            // Notes list
            Expanded(
              child: Consumer<DBProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator(
                      color: themeProvider.getPrimaryColor(),
                    ));
                  }

                  final notes = provider.filteredNotes;
                  if (notes.isEmpty) {
                    return Center(
                      child: Text(
                        "No ${provider.currentCategory} Notes yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteItem(
                          note: notes[index],
                          width: w,
                          height: h,
                          backgroundColor: themeProvider.getSurfaceColor(),
                          textColor: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                          onLongPress: () {
                            _noteController.text = notes[index][DBHelper.NOTE_COLUMN_TITLE];
                            _desController.text = notes[index][DBHelper.NOTE_COLUMN_DESC];
                            showDialog(
                              context: context,
                              builder: (context) => UpdateNoteDialog(
                                color: themeProvider.getTextColor(),
                                id: notes[index][DBHelper.NOTE_COLUMN_ID],
                                category: notes[index][DBHelper.NOTE_COLUMN_CATERGORY],
                                noteController: _noteController,
                                desController: _desController,
                                formKey: _formKey,
                                getCurrentTime: getCurrentTime,
                                width: w,
                                height: h,
                                backgroundColor: themeProvider.getSurfaceColor(),
                                textColor: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                              ),
                            );
                          },
                          onDelete: () => provider.deleteNote(notes[index][DBHelper.NOTE_COLUMN_ID]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
