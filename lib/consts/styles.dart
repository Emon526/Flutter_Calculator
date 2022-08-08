import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.black : Colors.white,
      ),
      scaffoldBackgroundColor:
          //0A1931  // white yellow 0xFFFCF8EC
          isDarkTheme ? Colors.black : Colors.white,
      primaryColor:
          isDarkTheme ? const Color(0xffF9D002) : const Color(0xff0074E9),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary:
                // isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
                isDarkTheme ? const Color(0xff828282) : const Color(0xff777778),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      buttonColor:
          isDarkTheme ? const Color(0xffD5D5D5) : const Color(0xffD5D5D5),
      cardColor:
          isDarkTheme ? const Color(0xff141416) : const Color(0xffFFFFFF),
      canvasColor:
          isDarkTheme ? const Color(0xff212121) : const Color(0xffE5E0E0),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          buttonColor:
              isDarkTheme ? const Color(0xffD5D5D5) : const Color(0xffD5D5D5),
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}
