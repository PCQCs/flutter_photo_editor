import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/provider/thme_provider.dart';
import 'package:flutter_photo/screen/adjust_screen.dart';
import 'package:flutter_photo/screen/bg_remove_screen.dart';
import 'package:flutter_photo/screen/blur_screen.dart';
import 'package:flutter_photo/screen/crop_screen.dart';
import 'package:flutter_photo/screen/draw_screen.dart';
import 'package:flutter_photo/screen/filter_screen.dart';
import 'package:flutter_photo/screen/fit_screen.dart';
import 'package:flutter_photo/screen/home_screen.dart';
import 'package:flutter_photo/screen/mask_screen.dart';
import 'package:flutter_photo/screen/start_screen.dart';
import 'package:flutter_photo/screen/sticker_screen.dart';
import 'package:flutter_photo/screen/text_screen.dart';
import 'package:flutter_photo/screen/tint_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AppImageProvider(),
      ),
      ChangeNotifierProvider(create: (_) => ThemeProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Application name
      title: 'Flutter Hello World',
      theme: ThemeData(
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          scaffoldBackgroundColor: Colors.white,
          // useMaterial3: false,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              color: Colors.black, centerTitle: true, elevation: 0)),
      routes: <String, WidgetBuilder>{
        '/': (_) => const Start_screen(),
        '/home': (_) => const HomeScreen(),
        '/crop': (_) => const Crop_Screen(),
        '/filter': (_) => const Filter_screen(),
        '/adjust': (_) => const AdjustScreen(),
        '/fit': (_) => const Fit_screen(),
        '/tint': (_) => const TintScreen(),
        '/blur': (_) => const BlurScreen(),
        '/sticker': (_) => const StickerScreen(),
        '/text': (_) => const TextScreen(),
        '/draw': (_) => const DrawScreen(),
        '/mask': (_) => const MaskScreen(),
        '/bgrm': (_) => const BgRemoveScreen(),
      },
      initialRoute: '/',
    );
  }
}
