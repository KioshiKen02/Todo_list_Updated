import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {

  List toDoList = [];

  //reference the box
  final _mybox = Hive.box('mybox');


  // run this method if this is the first time opening the app
  void createInitialData() {
    toDoList = [];
    updateDataBase();
  }

  //load data from database
  void loadData() {
    toDoList = _mybox.get("TODOLIST");

  }

  //update database
void updateDataBase() {
    _mybox.put("TODOLIST", toDoList);
}
}
