import 'dart:async';

import 'package:ai_smart/models/user_preference_model.dart';
import 'package:ai_smart/shared/shared.dart';
import 'package:ai_smart/views/pages/pages.dart';
import 'package:ai_smart/views/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      900: const Color(0XFF27DD17),
      800: const Color(0XFF32E821),
      700: const Color(0XFF43EA34),
      600: const Color(0XFF54EC46),
      500: const Color(0XFF65EE59),
      400: const Color(0XFF76EF6B),
      300: const Color(0XFF88F17E),
      200: const Color(0XFF99F391),
      100: const Color(0XFFAAF5A3),
      50: const Color(0XFFBBF7B6),
    };
    MaterialColor primaryCustomColor = MaterialColor(hexPrimaryColor, color);
    // MaterialColor accentCustomColor = MaterialColor(0xff27DD17, color);
    return MaterialApp(
        title: 'AISmart',
        theme: ThemeData(
            primarySwatch: primaryCustomColor,
            scaffoldBackgroundColor: kWhiteColor,
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: kWhiteColor),
                titleTextStyle: whiteTextStyle.copyWith(fontSize: 20))),
        home: const SplashPage());
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> loadingScreen() async {
      try {
        SharedPreferences preferences = await GlobalService.sharedPreference;
        String? userID = preferences.getString(UserPreferenceModel.userID);
        Timer(const Duration(milliseconds: 3000), () async {
          if (userID != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
                (route) => false);
            return;
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreenPage()),
              (route) => false);
        });
      } catch (e) {
        Utilities.showAlertDialog(context, alertPeringatan, e.toString());
      }
    }

    return Scaffold(
        body: FutureBuilder(
            future: loadingScreen(),
            builder: (context, snapshot) {
              return SizedBox(
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 200,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        '$assetImagePath/logo_primary.png')))),
                        const WidgetLoadingProcess()
                      ]));
            }));
  }
}
