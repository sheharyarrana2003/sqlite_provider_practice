import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_practice_flutter/Screens/profile_screen.dart';
import 'package:sqlite_practice_flutter/modules/db_helper.dart';
import 'package:sqlite_practice_flutter/modules/db_provider.dart';
import '../modules/cutom_text_field.dart';
import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Map<String, dynamic>> allNotes = [];
  // List<Map<String, dynamic>> specificNotes = [];
  // List<Map<String, dynamic>> filteredNotes = [];
  // DBHelper? dbRef;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController=TextEditingController();
  List<String> categories = [
    'All','Work', 'Personal', 'Health', 'Family', 'Finance',
    'Shopping', 'Education', 'Travel', 'Goals',
  ];
  bool isSearch=false;
  String selectedCategory="All";
  // List<Map<String, dynamic>> notesToShow=[];
  // List<Map<String, dynamic>> findNotes=[];

  Color applyColor(String ct,{bool isSelected=false}){
    if(isSelected){
      return Colors.grey.shade400;
    }
    switch(ct){
      case "Work":
        return Colors.blue.shade400;
      case "Personal":
        return Colors.green.shade400;
      case "Health":
        return Colors.red.shade400;
      case "Family":
        return Colors.orange.shade400;
      case "Finance":
        return Colors.purple.shade400;
      case "Shopping":
        return Colors.teal.shade400;
      case "Education":
        return Colors.amber.shade400;
      case "Travel":
        return Colors.cyan.shade400;
      case "Goals":
        return Colors.pink.shade400;
      case "All":
        return Colors.black45;
      default:
        return Colors.grey.shade400;

    }
  }
  @override
  void initState() {
    super.initState();
    context.read<DBProvider>().getInitialNotes();
  }

  String getCurrentTime() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    print("Build Context");
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person, color: Colors.white),
            )
          ],
        ),
        floatingActionButton: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
          ),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTask()));
            context.read<DBProvider>().getInitialNotes();
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        body: Consumer<DBProvider>(
          builder: (ctx,provider,__){
            print("Consumer");
            return LayoutBuilder(
              builder: (ctx, constraints) {
                List<Map<String,dynamic>> allNotes=provider.getAllNotes();
                return allNotes.isNotEmpty ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: TextField(
                        onChanged: (value){
                          print("Search");
                          provider.filterNotes(value);
                        },
                        decoration: InputDecoration(
                            labelText: "Search",
                            suffixIcon: Icon(Icons.search)
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          bool isSelected=categories[index]==selectedCategory;
                          return GestureDetector(
                            onTap: (){
                              print("Category Build");
                              selectedCategory=categories[index];
                              provider.getSpecificNotes(selectedCategory);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                              padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.008),
                              decoration: BoxDecoration(
                                color: applyColor(categories[index],isSelected: isSelected),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                categories[index],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
                            child: showNotes(w: w, h: h,selectedCategory: selectedCategory,ctx: ctx)
                        )

                    ),
                  ],
                ) : const Center(child: Text("No Notes yet", style: TextStyle(fontSize: 16)));
              },
            );
          },
        ),
      ),
    );
  }
  Widget showNotes({required double w,required double h,required String selectedCategory,required BuildContext ctx}){
    //notesToShow = selectedCategory == "All" ? allNotes : specificNotes;
    List<Map<String,dynamic>> findNotes= ctx.read<DBProvider>().getFindNotes();
    return findNotes.isNotEmpty ? ListView.builder(
      itemCount: findNotes.length,
      itemBuilder: (context, index) {
        print("Show Notes");
        String category = findNotes[index][DBHelper.NOTE_COLUMN_CATERGORY] ?? "Other";
        return GestureDetector(
          onLongPress: () {
            _noteController.text = findNotes[index][DBHelper.NOTE_COLUMN_TITLE];
            _desController.text = findNotes[index][DBHelper.NOTE_COLUMN_DESC];
            showDialog(
              context: context,
              builder: (context) => getDialog(id: findNotes[index][DBHelper.NOTE_COLUMN_ID],w: w,h: h,category: selectedCategory),
            );
          },
          child: Card(
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: h * 0.01),
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    findNotes[index][DBHelper.NOTE_COLUMN_TITLE],
                    style: TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    findNotes[index][DBHelper.NOTE_COLUMN_DESC],
                    style: TextStyle(color: Colors.grey.shade700, fontSize: w * 0.04),
                  ),
                  SizedBox(height: h * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.008),
                        decoration: BoxDecoration(
                          color: applyColor(category),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: w * 0.04),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            findNotes[index][DBHelper.NOTE_COLUMN_TIME],
                            style: TextStyle(color: Colors.blue.shade600, fontSize: w * 0.035),
                          ),
                          IconButton(
                            onPressed: () async {
                              print("Delete");
                              context.read<DBProvider>().deleteNote(findNotes[index][DBHelper.NOTE_COLUMN_ID]);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ): Center(child: Text("No $selectedCategory Notes yet", style: TextStyle(fontSize: 16)));
  }
  Widget getDialog({required int id,required double w,required double h,required String category}) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Update Note", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(label: "Note", hint: "Enter note", controller: _noteController, isPass: false,validator: (value){
              if(value==null || value.isEmpty){
                return "Please enter note";
              }
              return null;
            },),
            SizedBox(height: 10),
            CustomTextField(label: "Description", hint: "Enter description", controller: _desController, isPass: false,validator: (value){
              if(value==null || value.isEmpty){
                return "Please enter description";
              }
              return null;
            },),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            padding: EdgeInsets.symmetric(vertical: h*0.01,horizontal: w*0.04),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4
          ),
          onPressed: () async{
            String currentTime=getCurrentTime();
            if(_formKey.currentState!.validate()){
              print("Update");
              context.read<DBProvider>().update(id, category, _noteController.text.toString().trim(), _desController.text.toString().trim(), currentTime);
              Navigator.pop(context);
            }
          },
          child: const Text("Update",style: TextStyle(color: Colors.white,fontSize: 15),),
        ),
        ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red.shade600,
    padding: EdgeInsets.symmetric(vertical: h*0.01,horizontal: w*0.04),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4
    ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 15),),
        ),
      ],
    );
  }
  
}
