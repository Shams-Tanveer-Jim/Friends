import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends/consts/assets.dart';
import 'package:friends/consts/styles.dart';
import 'package:friends/views/screens/parent_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/colors.dart';

// Splash Screen exists for 2 seconds and then automatically move to the next parent screen.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.offAll(
        ParentScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(seconds: 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: StyleConstant.linearGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsConstant.logo,
              scale: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "FRIENDS",
              style: GoogleFonts.comicNeue(
                  fontSize: 46,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
