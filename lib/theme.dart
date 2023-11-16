import 'package:flutter/material.dart';

const lightGreen =  Color(0xFFB3BEB6);
const neutral = Color(0xFFFFFAF1);
const darkTeal = Color(0xFF0D4B5F);
const peach = Color(0xFFF2BB9B);
const darkGray = Color(0xFF4F646F);
const white = Color(0xFFFFFFFF); 
const black = Color(0xFF000000);
const lightGray = Color(0xFFb71c1c); // wrong color, have to find it 
const darkRed = Color(0xFFB0413E);
const brightRed = Color(0xFFF00000);


class BabyStepsColorScheme {

  static ColorScheme _myColorScheme() {
    return ColorScheme.fromSeed(
        seedColor: darkTeal, // not important to us, just required to be there

        background: lightGreen,
        onBackground: neutral,
        surface: neutral,
        onSurface: black,
        onSurfaceVariant: lightGray,
        primary: peach,
        onPrimary: black,
        secondary: darkTeal,
        onSecondary: neutral,
        tertiary: darkGray,
        onTertiary: neutral,
        error: darkRed,
        onError: neutral,
    );
  }
}



class BabyStepsTheme {

  ThemeData themedata = ThemeData(

    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: darkTeal, // not important to us, just required to be there

      background: lightGreen,
      onBackground: neutral,
      surface: neutral,
      onSurface: black,
      onSurfaceVariant: lightGray,
      primary: peach,
      onPrimary: black,
      secondary: darkTeal,
      onSecondary: neutral,
      tertiary: darkGray,
      onTertiary: neutral,
      error: darkRed,
      onError: neutral,
    ),

    // textTheme: TextTheme(
    //   displayLarge: const TextStyle(
    //     fontSize: 72,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   // ···
    //   titleLarge: GoogleFonts.oswald(
    //     fontSize: 30,
    //     fontStyle: FontStyle.italic,
    //   ),
    //   bodyMedium: GoogleFonts.merriweather(),
    //   displaySmall: GoogleFonts.pacifico(),
    // ),
  );
  

}