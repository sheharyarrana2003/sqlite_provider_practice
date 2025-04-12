import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  DBHelper._();
static DBHelper getInstance(){
  return DBHelper._();
}
  Database? myDB;
static final String NOTE_TABLE="notes";
static final String NOTE_COLUMN_ID="ID_no";
static final String NOTE_COLUMN_TITLE="title";
  static final String NOTE_COLUMN_DESC="desc";
  static final String NOTE_COLUMN_TIME="time";
  static final String NOTE_COLUMN_CATERGORY="category";


  //db oepn (path-> if exists then open else create db)
  Future<Database> getDB() async {
    if(myDB!=null){
      return myDB!;
    }
    else{
      myDB=await openDB();
      return myDB!;
    }
    //alternate of above condition
    // myDB ??=await openDB();
    // return myDB!;
    // OR
    // myDB=myDB ?? await openDB();
    // return myDB!;
  }
  Future<Database> openDB() async {
    Directory appDir=await getApplicationDocumentsDirectory();
    String dbPath=join(appDir.path,"noteDB.db");
    return await openDatabase(dbPath,onCreate: (db,version){
      db.execute("create table $NOTE_TABLE ($NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE text,$NOTE_COLUMN_DESC text, $NOTE_COLUMN_TIME text,$NOTE_COLUMN_CATERGORY text)");
    },version: 1);
  }

  // all queries
  // insertion query
  Future<bool> addNote({required String Title,required String Desc,required String time,required String category}) async {
    var db=await getDB();
    int rowsEffected=await db.insert(NOTE_TABLE, {
      NOTE_COLUMN_TITLE:Title,
      NOTE_COLUMN_DESC:Desc,
      NOTE_COLUMN_TIME: time,
      NOTE_COLUMN_CATERGORY:category
    });
    return rowsEffected>0;

    // when ever we insert any row in db then it basic rule of sql it return how many row effected
    // specific query if it greater then 0 means any data insert or any query placed

  }
  Future<List<Map<String,dynamic>>> getAllNotes({String? category}) async {
    var db=await getDB();
    if(category==null || category=="All"){
      return await db.query(NOTE_TABLE);
    }
    else{
      return await db.query(NOTE_TABLE,where: "$NOTE_COLUMN_CATERGORY=?",whereArgs: [category]);
    }
    //select * from notes
    // List<Map<String,dynamic>> allNotes=await db.query(NOTE_TABLE);
    // return allNotes;
//    List<Map<String,dynamic>> allNotes=await db.query(NOTE_TABLE,columns: [NOTE_COLUMN_TITLE,NOTE_COLUMN_ID]); for specific columns
    //    List<Map<String,dynamic>> allNotes=await db.querFuture<void>TE_TABLE,wher async e..);// for where to specific conditions
  }

  Future<bool> updateNote({required String title,required String desc, required String time, required int id}) async {
    var db=await getDB();
    int rowEffected=await db.update(NOTE_TABLE, {
     NOTE_COLUMN_TITLE:title,
      NOTE_COLUMN_DESC:desc,
      NOTE_COLUMN_TIME:time
    },where: "$NOTE_COLUMN_ID=$id");
    return rowEffected>0;
  }

  Future<bool> deleteNote({required int id})async{
    var db=await getDB();
    // int rowsEffected=await db.delete(NOTE_TABLE,where:"$NOTE_COLUMN_ID=$id" );
    int rowsEffected=await db.delete(NOTE_TABLE,where:"$NOTE_COLUMN_ID= ?",whereArgs: ['$id'] );
    return rowsEffected>0;
  }


}