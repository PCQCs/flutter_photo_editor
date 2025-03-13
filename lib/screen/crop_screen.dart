import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class Crop_Screen extends StatefulWidget {
  const Crop_Screen({super.key});

  @override
  State<Crop_Screen> createState() => _Crop_ScreenState();
}

class _Crop_ScreenState extends State<Crop_Screen> {
  //구현 완료
  final controller = CropController(
      aspectRatio: 1, defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));

  int index = 1;

  late AppImageProvider imageProvider;

  @override
  void initState() {
    index = 1;
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.height;
    double height = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                ui.Image bitmap = await controller.croppedBitmap();
                ByteData? data =
                    await bitmap.toByteData(format: ui.ImageByteFormat.png);
                Uint8List bytes = data!.buffer.asUint8List();

                Provider.of<AppImageProvider>(context, listen: false)
                    .changeImage(bytes);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done, color: Colors.white))
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Container(
                  child: Consumer<AppImageProvider>(
                      builder: (BuildContext context, value, Widget? child) {
                    if (value.currentImage != null) {
                      return CropImage(
                        image: Image.memory(
                          value.currentImage!,
                          fit: BoxFit.contain,
                        ),
                        controller: controller,
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _bottomBarItem(
                            child: const Icon(
                                Icons.rotate_90_degrees_ccw_outlined,
                                color: Colors.white),
                            onPress: () {
                              controller.rotateLeft();
                            }),
                        _bottomBarItem(
                            child: const Icon(
                                Icons.rotate_90_degrees_cw_outlined,
                                color: Colors.white),
                            onPress: () {
                              controller.rotateRight();
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            color: Colors.white70,
                            height: 30,
                            width: 1,
                          ),
                        ),
                        _bottomBarItem(
                            child: Text("Free",
                                style: TextStyle(
                                    color: index == 0
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 0;
                              });
                              controller.aspectRatio = -1;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("1:1",
                                style: TextStyle(
                                    color: index == 1
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 1;
                              });
                              controller.aspectRatio = 1;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("2:1",
                                style: TextStyle(
                                    color: index == 2
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 2;
                              });
                              controller.aspectRatio = 2;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("1:2",
                                style: TextStyle(
                                    color: index == 3
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 3;
                              });
                              controller.aspectRatio = 1 / 2;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("4:3",
                                style: TextStyle(
                                    color: index == 4
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 4;
                              });
                              controller.aspectRatio = 4 / 3;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("3:4",
                                style: TextStyle(
                                    color: index == 5
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 5;
                              });
                              controller.aspectRatio = 3 / 4;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("16:9",
                                style: TextStyle(
                                    color: index == 6
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 6;
                              });
                              controller.aspectRatio = 16 / 9;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                        _bottomBarItem(
                            child: Text("9:16",
                                style: TextStyle(
                                    color: index == 7
                                        ? Colors.blue
                                        : Colors.white)),
                            onPress: () {
                              setState(() {
                                index = 7;
                              });
                              controller.aspectRatio = 9 / 16;
                              controller.crop =
                                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                            }),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
      /* bottomNavigationBar: Container(
          width: double.infinity,
          height: 58,
          color: Colors.black,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBarItem(
                    child: Icon(Icons.rotate_90_degrees_ccw_outlined,
                        color: Colors.white),
                    onPress: () {
                      controller.rotateLeft();
                    }),
                _bottomBarItem(
                    child: Icon(Icons.rotate_90_degrees_cw_outlined,
                        color: Colors.white),
                    onPress: () {
                      controller.rotateRight();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    color: Colors.white70,
                    height: 30,
                    width: 1,
                  ),
                ),
                _bottomBarItem(
                    child: Text("Free", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = -1;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("1:1", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 1;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("2:1", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 2;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("1:2", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 1 / 2;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("4:3", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 4 / 3;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("3:4", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 3 / 4;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("16:9", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 16 / 9;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
                _bottomBarItem(
                    child: Text("9:16", style: TextStyle(color: Colors.white)),
                    onPress: () {
                      controller.aspectRatio = 9 / 16;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }),
              ],
            ),
          )), */
    );
  }

  Widget _bottomBarItem({required child, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
