import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


mixin AppImages {

 static const Widget welcomeImage = Image(
    image: AssetImage('assets/images/welcome_screen.png'),
    fit: BoxFit.fill,
  );

  static const Widget headerImage = Image(
    image: AssetImage('assets/images/header.png'),
    fit: BoxFit.cover,
  );

static const AssetImage welcomeBackground =
      AssetImage('assets/images/bg_logo.png');

  static const AssetImage sideMenuBackground = AssetImage(
    'assets/images/side_menu_top_background.png',
  );

  static final Widget airtelLogo = SvgPicture.asset(
    'assets/icons/airtel_logo.svg',
    semanticsLabel: 'Airtel logo',
    fit: BoxFit.fill,
  );

  static final Widget splashLogo = SvgPicture.asset(
      'assets/images/splash_logo.svg',
      semanticsLabel: 'info error handling banner icon');

  static final Widget splashNew = Image.asset(
    'assets/images/splash_new.png',
  );

static final Widget alertInfo = SvgPicture.asset(
    'assets/icons/icon/alert/info.svg',
    semanticsLabel: 'alert info icon',
    height: 77,
    width: 77,
  );
  static final Widget alertError = SvgPicture.asset(
    'assets/icons/icon/alert/error.svg',
    semanticsLabel: 'alert error icon',
    height: 77,
    width: 77,
  );
  static final Widget alertWarning = Image.asset(
    'assets/icons/icon/alert/warning_orange.png',
    semanticLabel: "alert warning icon",
    width: 77,
    height: 77,
  );
  static final Widget alertSuccess = SvgPicture.asset(
    'assets/icons/icon/alert/success.svg',
    semanticsLabel: 'alert success icon',
    height: 77,
    width: 77,
  );
}