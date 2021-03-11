import 'package:flutter/material.dart';

abstract class AppColors {
  static get primary => Colors.white;
  static get secondary => Colors.grey[200];
  static get iconSelected => Color.fromRGBO(66, 115, 175, 1);
  static get indicatorColor => Color(0xff9357CD);
  static get accentBlueColor => Color(0xff396FB4);
  static get greyColor => Color(0xff898989);
  static get successGreenColor => Color(0xff3BE388);
  static get lightPinkColor => Color(0xff9357CD).withAlpha(15);
  static get pinkBackgroundColor => Color(0xffECE9F8);
  static get messageBlueBackground => Color(0xff4C4FB4);
}

abstract class AppFontStyles {
  
  // Header Style
  static get headingBlackStyle =>
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22);
  
  static get headingTextSyle => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  static get logoHeadingStyle => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );
  // Normal Text Style
  static get headerMediumStyle => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  // For Medium Texts
  static get mediumStyle => TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  static get placeholderMedium => TextStyle(
    color: AppColors.greyColor,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  // For Grey Placeholders
  static get placeholderStyle => TextStyle(
    color: Color(0xff828282),
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
  
  // Action Button Style
  static get actionButtonStyle => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  static get indicatorSmallStyle => TextStyle(
    color: AppColors.indicatorColor,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
  
  static get blueSmallStyle => TextStyle(
    color: AppColors.accentBlueColor,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

   static get black14w400 => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontSize: 14,
  );

  static get white14w400 => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontSize: 14,
  );

  static get whiteGrey12w400 => TextStyle(
    color: Colors.grey[200],
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static get grey12w400 => TextStyle(
    color: Color(0xff828282),
    fontWeight: FontWeight.w400,
    height: 0.75,
    fontSize: 12,
  );

  static get grey14w400 => TextStyle(
    color: Color(0xff828282),
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static get white12w400 => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    height: 0.75,
    fontSize: 12,
  );
}

abstract class AppTheme {
  static get light => ThemeData(
    primaryColor: AppColors.secondary,
    accentColor: Colors.black,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    highlightColor: Color(0xff292969),
    indicatorColor: Color(0xff9357CD),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(color: Color(0xffFAF9FF)),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
      headline2: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 20)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 4,
      selectedIconTheme: IconThemeData(
        color: AppColors.iconSelected,
      ),
      selectedLabelStyle:
          TextStyle(color: AppColors.iconSelected, fontSize: 12),
      unselectedLabelStyle: TextStyle(
          color: Color.fromRGBO(0x72, 0x72, 0x72, 1.0), fontSize: 12),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}

abstract class AppGradinets {
  static get mainButtonGradient => LinearGradient(colors: [
        Color(
          0xff396FB4,
        ),
        Color(0xff8F4BCF),
      ], begin: Alignment.centerLeft, end: Alignment.centerRight);
}

abstract class AppContainerDecoration {
  static get buttonGradinetDec => BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          Color(0xffD010FF),
          Color(0xff5A0E99),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      );
}
