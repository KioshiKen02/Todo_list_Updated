import 'package:flutter/material.dart';
import 'package:todoo/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Open the Hive box
    await Hive.openBox('mybox');
  } catch (e) {
    debugPrint("Error initializing Hive: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set the whole app background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black, // AppBar background black
          elevation: 0, // Remove shadow
          iconTheme: IconThemeData(color: Colors.white), // Icons should be white for visibility
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Title should be white
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black, // Use black as primary color
          secondary: Colors.white, // Secondary elements in white
        ),
      ),

    );
  }
}
