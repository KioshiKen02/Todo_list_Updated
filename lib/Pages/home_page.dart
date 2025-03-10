import 'package:todoo/Data/database.dart';
import 'package:todoo/Utils/dialog_box1.dart';
import 'package:flutter/material.dart';
import 'package:todoo/Utils/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _mybox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  late ConfettiController _confettiController;
  late ConfettiController _rightConfettiController;

  @override
  void initState() {
    super.initState();

    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    _confettiController = ConfettiController(duration: Duration(seconds: 3));

    // Show welcome message every time the app starts
    Future.delayed(Duration(milliseconds: 500), () {
      showWelcomeDialog();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void showWelcomeDialog() {
    _confettiController.play(); // Start confetti animation

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lottie Animation
                    Lottie.asset(
                      'assets/animation/astronot.json',
                      repeat: true,
                      animate: true,
                      reverse: true,
                      height: 120,
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: 10),

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
                      onPressed: () {
                        _confettiController.stop();
                        Navigator.of(context).pop();
                      },
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

              // 🎉 Confetti Animation 🎉
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
                    gravity: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Checkbox toggle function (Immutable update)
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList = List.from(db.toDoList);
      db.toDoList[index] = [db.toDoList[index][0], value ?? false];
    });
    db.updateDataBase();
  }

  // Save new task
  void saveNewTask() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Idiot! There is no task inputted."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      db.toDoList.add([_controller.text.trim(), false]);
      _controller.clear();
    });

    db.updateDataBase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Good Job! Task added successfully! 🎉"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
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

  // Delete task
  void deleteTask(int index) {
    String deletedTask = db.toDoList[index][0];

    setState(() {
      db.toDoList.removeAt(index);
    });

    db.updateDataBase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🗑️Task deleted successfully!"),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              db.toDoList.insert(index, [deletedTask, false]);
            });
            db.updateDataBase();
          },
        ),
      ),
    );
  }

  // Edit task
  void editTask(int index) {
    _controller.text = db.toDoList[index][0];

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSaved: () {
            String newTask = _controller.text.trim();

            if (newTask.isNotEmpty) {
              setState(() {
                db.toDoList[index][0] = newTask;
              });
              db.updateDataBase();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("✏️Task updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
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
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          "JUST DO IT!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Lottie.network(
                  'https://lottie.host/5413471d-0d05-42cc-a1e6-e7be33984e61/r5Bs07PfGr.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
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
