import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:park_ai/main_pages/root.dart';
import 'package:park_ai/providers/tremor_provider.dart';
import 'package:park_ai/providers/chat_provider.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TremorProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Health App UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define a clear, bright primary color
          primaryColor: const Color(0xFF0D47A1), // A deep blue for accent
          // Use a consistent font if needed, but default is fine
          fontFamily: 'Inter',
          // Set up the color scheme for Material 3 look
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF1976D2), // Standard blue
            secondary: Colors.blueAccent,
            surface: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const RootScreen(),
      ),
    );
  }
}


