import 'package:todoo/Utils/my_button.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSaved;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSaved,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Create New Task
            TextField(
              controller: controller,
              maxLines: null, // Allows unlimited lines (text wraps automatically)
              keyboardType: TextInputType.multiline, // Enables multi-line input
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                  borderSide: BorderSide(color: Colors.black, width: 2), // Black border
                ),
                enabledBorder: OutlineInputBorder( // Border when not focused
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder( // Border when focused
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2.5), // Thicker when focused
                ),
                hintText: "Create New Task",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
                labelText: "To Do List",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15), // Spacing between TextField & Buttons
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                    text: "Save",
                    onPressed: onSaved,
                ),
                const SizedBox(width: 10),
                MyButton(
                    text: "Cancel",
                    onPressed: onCancel,
                    color: Colors.black,
                    txtcolor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
