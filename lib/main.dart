import 'package:currency_converter/screens/homepage.dart';
import 'package:currency_converter/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kurrency Converter',
      theme: ThemeData(
        dialogTheme: DialogTheme(
            backgroundColor: Color(0xff0F111E),
            titleTextStyle: GoogleFonts.urbanist(
                color: Color(0xffFFFFFF),
                fontSize: 24,
                fontWeight: FontWeight.w500),
            contentTextStyle: GoogleFonts.urbanist(
                color: Color(0xffFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF)),
          bodyLarge: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF)),
        ),
      ),
      home: const HomePage(),
    );
  }
}
