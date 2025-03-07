import 'package:todoo/Data/database.dart';
import 'package:todoo/Utils/dialog_box1.dart';
import 'package:flutter/material.dart';
import 'package:todoo/Utils/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text Controller
  final _controller = TextEditingController();

  final _mybox = Hive.box('mybox');

  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();

    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    // Show welcome message every time the app starts
    Future.delayed(Duration(milliseconds: 500), () {
      showWelcomeDialog();
    });
  }

  void showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation for better design
                Lottie.asset(
                  'assets/animation/astronot.json',
                  repeat: true,
                  animate: true,
                  reverse: true,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                // Welcome Text
                Text(
                  "Welcome Back! 🎉",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10),

                // Description
                Text(
                  "Let's continue where you left off.\nKeep being productive!",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // OK Button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Let's Go!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // Checkbox toggle function (Immutable update)
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList = List.from(db.toDoList); // Clone the list to trigger UI updates
      db.toDoList[index] = [db.toDoList[index][0], value ?? false]; // Immutable update
    });
    db.updateDataBase();
  }

  // Save new task
  void saveNewTask() {
    if (_controller.text.trim().isEmpty) {
      // Show an error message if the task is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Idiot! There is no task inputted."),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop execution if empty
    }

    setState(() {
      db.toDoList.add([_controller.text.trim(), false]); // Save trimmed input
      _controller.clear();
    });

    db.updateDataBase(); // Update database

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Good Job! Task added successfully! 🎉"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop(); // Close dialog
  }

  // Create new task dialog
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSaved: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index) {
    String deletedTask = db.toDoList[index][0]; // Store deleted task name

    setState(() {
      db.toDoList.removeAt(index);
    });

    db.updateDataBase(); // Update database

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🗑️Task deleted successfully!"),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.white,
          onPressed: () {
            // Restore deleted task
            setState(() {
              db.toDoList.insert(index, [deletedTask, false]);
            });
            db.updateDataBase(); // Update again
          },
        ),
      ),
    );
  }

  void editTask(int index) {
    _controller.text = db.toDoList[index][0]; // Prefill with existing task

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSaved: () {
            String newTask = _controller.text.trim(); // Get new task name

            if (newTask.isNotEmpty) {
              setState(() {
                db.toDoList[index][0] = newTask; // Update task
              });
              db.updateDataBase();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("✏️Task updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              // Show error message if input is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Idiot! Just delete the task if you will save it empty. ❌"),
                  backgroundColor: Colors.red,
                ),
              );
            }

            _controller.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: Drawer(
      // ),
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        // title: Transform.translate(
        //   offset: Offset(-2, 0),  // Adjust manually (-20 works in most cases)
        //   child: Text(
        //     'ToDo',
        //     style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //
        //     )
        //   ),
        // ),
        title: const Center(
          child: Text(
            "JUST DO IT!",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 40,  // Set custom width
        height: 40, // Set custom height
        child: FloatingActionButton(
          onPressed: createNewTask,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
          child: Icon(Icons.add, size: 20), // Adjust icon size if needed
        ),
      ),
      body: Stack(
        children: [
          // Background Lottie Animation
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.5, // Adjust transparency to make it blend nicely
                child: Lottie.network(
                  'https://lottie.host/5413471d-0d05-42cc-a1e6-e7be33984e61/r5Bs07PfGr.json',
                  fit: BoxFit.cover,
                  // Ensures it covers the whole screen
                ),
              ),
            ),
          ),

          // Foreground: To-Do List
          ListView.builder(
            itemCount: db.toDoList.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: db.toDoList[index][0],
                taskCompleted: db.toDoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
                editFunction: (context) => editTask(index),
              );
            },
          ),
        ],
      ),
    );
  }
}