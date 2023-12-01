import 'package:flutter/material.dart';


// GENERALLY WORKS: 
// The widget usually already has the right context/ThemeData, then you can access it with:
// color: Theme.of(context).colorScheme.titleOfColor

// ALTERNATE:
// Pass to the widget: Theme.of(context)
// In the widget add this.theme and attribute final ThemeData theme   
// Then to access it do:   color: theme.colorScheme.titleOfColor

// Color title guide:
// background green = "background"
// neutral beige = "surface" (and "onBackground", "onSecondary", "onTertiary", and "onError")
// peach = "primary"
// blue = "secondary"
// dark gray = "tertiary"
// black = "onSurface" and "onPrimary"
// light gray = "onSurfaceVariant"
// dark red = "error"

// Note: You can't apply theme to const values (just get rid of const label to fix)


Color lightGreen =  Color(0xFFB3BEB6);
Color neutral = Color(0xFFFFFAF1);
Color darkTeal = Color(0xFF0D4B5F);
Color peach = Color(0xFFF2BB9B);
Color darkGray = Color(0xFF4F646F);
Color white = Color(0xFFFFFFFF); 
Color black = Color(0xFF000000);
Color lightGray = Color.fromARGB(115, 0, 0, 0); 
Color darkRed = Color(0xFFB0413E);
Color brightRed = Color(0xFFF00000);

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