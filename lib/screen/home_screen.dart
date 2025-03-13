import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/provider/thme_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* final InterstitialAdManager _interstitialAdManager = InterstitialAdManager(); */
  List<XFile> imageFileList = [];
  final List<Uint8List> _images = [];

  late PageController _controller;
  final controller = ScreenshotController();
  final bool _isDownloading = false;

  late AppImageProvider appImageProvider;
  late ThemeProvider themeProvider;

  _savePhoto() async {
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(
        Provider.of<AppImageProvider>(context, listen: false).currentImage!,
        quality: 100,
        name: "${DateTime.now().millisecondsSinceEpoch}");
    if (!mounted) return false;
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image Save to Gallery")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Somethin went wrong!")));
    }
  }

  @override
  void initState() {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.height;
    double height = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          Consumer<AppImageProvider>(builder: (context, value, child) {
            return IconButton(
                onPressed: () {
                  appImageProvider.undo();
                },
                icon: Icon(Icons.undo_outlined,
                    color: Provider.of<ThemeProvider>(context).lightModeEnable
                        ? (value.cansUndo
                            ? Colors.white
                            : Colors.white30) // white모드가 블랙일 경우 작동
                        : (value.cansUndo ? Colors.black : Colors.grey)));
          }),
          Consumer<AppImageProvider>(builder: (context, value, child) {
            return IconButton(
                onPressed: () {
                  appImageProvider.redo();
                },
                icon: Icon(
                  Icons.redo_outlined,
                  color: value.cansRedo ? Colors.white : Colors.white38,
                ));
          }),
          /* Consumer<ThemeProvider>(builder: (context, value, child) {
            return IconButton(
                onPressed: () {
                  value.changeMode();
                },
                icon: Icon(
                  Provider.of<ThemeProvider>(context).lightModeEnable
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Provider.of<ThemeProvider>(context).lightModeEnable
                      ? Color(0xFFFFFFFF)
                      : Color.fromARGB(255, 22, 22, 22),
                ));
          }), */
          TextButton(
              onPressed: () async {
                _savePhoto();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Save'))
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 6,
                child: Screenshot(
                    controller: controller,
                    child: Center(
                      child: Container(
                        child: Consumer<AppImageProvider>(builder:
                            (BuildContext context, value, Widget? child) {
                          if (value.currentImage != null) {
                            return Image.memory(
                              value.currentImage!,
                              fit: BoxFit.contain,
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                      ),
                    ))),
            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      _bottomBaItem(Icons.crop_rotate, "Crop", onPress: () {
                        Navigator.of(context).pushNamed('/crop');
                      }),
                      _bottomBaItem(Icons.fitbit_outlined, "Filters",
                          onPress: () {
                        Navigator.of(context).pushNamed('/filter');
                      }),
                      _bottomBaItem(Icons.tune, "Adjust", onPress: () {
                        Navigator.of(context).pushNamed('/adjust');
                      }),
                      _bottomBaItem(Icons.fit_screen, "Fit", onPress: () {
                        Navigator.of(context).pushNamed('/fit');
                      }),
                      _bottomBaItem(Icons.format_color_fill_outlined, "Tint",
                          onPress: () {
                        Navigator.of(context).pushNamed('/tint');
                      }),
                      _bottomBaItem(Icons.blur_circular, "Blur", onPress: () {
                        Navigator.of(context).pushNamed('/blur');
                      }), //추후의 괜찮아지면 추가 하도록 예정
                      _bottomBaItem(Icons.text_fields, "Text", onPress: () {
                        Navigator.of(context).pushNamed('/text');
                      }),
                      _bottomBaItem(Icons.draw, "Draw", onPress: () {
                        Navigator.of(context).pushNamed('/draw');
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      _bottomBaItem(Icons.star_border, "Mask", onPress: () {
                        Navigator.of(context).pushNamed('/mask');
                      }), //확인 결과 Mask 이동이 확인이 안되는 게 보임 나중 업데이트를 통해 해결 하도록 결정
                      /* InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/bgrm");
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported_outlined,
                                    color: Colors.white),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "BG_Remove",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                )
                              ],
                            ),
                          ),
                        ), */
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _bottomBaItem(IconData icon, String title, {required onPress}) {
    return Container(
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}
