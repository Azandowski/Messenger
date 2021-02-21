import 'package:flutter/material.dart';

abstract class AppColors {
  static get primary => Color.fromRGBO(0xA8, 0x67, 0x26, 1.0);
  static get iconSelected => Colors.white;
  static get paleFontColor => Color(0xff676766);
  static get greyColor => Color(0xff898989);
  static get indicatorColor => Color(0xff9357CD);
  static get accentBlueColor => Color(0xff396FB4);
}

abstract class AppFontStyles {
  static get headingBlackStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22);
  static get mainStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      );
  static get mainStylePale => TextStyle(
        color: AppColors.paleFontColor,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      );
  static get percentInvestStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      );
  static get mediumTextStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );
  static get blackMediumStyle => TextStyle(
        color: Colors.black,
        fontSize: 14,
      );
  static get greyPhoneStyle => TextStyle(
        color: Color(0xffE0E0E0),
        fontWeight: FontWeight.w400,
        fontSize: 12,
      );
  static get paleStyle => TextStyle(
        color: AppColors.paleFontColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      );
  static get labelTextStyle => TextStyle(
      color: AppColors.paleFontColor,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      height: -16);

  static get paleHeading => TextStyle(
        color: AppColors.paleFontColor,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      );
  static get headingTextSyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  static get headingBoldStyle =>
      TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
  static get hintAppTextStyle => TextStyle(
        color: Color(0xffE0E0E0),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      );
  static get nameWhiteStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  static get headingWhite2 => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      );
  static get referralNameStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      );
  static get referralPhone => TextStyle(
        color: Color(0xffE0E0E0),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      );
  static get phoneListStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
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
}

abstract class AppTheme {
  static get light => ThemeData(
        primaryColor: Color.fromRGBO(39, 48, 101, 1),
        accentColor: Colors.white,
        backgroundColor: Color.fromRGBO(25, 41, 88, 1),
        scaffoldBackgroundColor: Colors.white,
        highlightColor: Color(0xff292969),
        indicatorColor: Color(0xff9357CD),
        bottomAppBarColor: Color.fromRGBO(39, 53, 126, 1),
        appBarTheme: AppBarTheme(color: Colors.white),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
            headline2: TextStyle(
                color: Colors.white,
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
