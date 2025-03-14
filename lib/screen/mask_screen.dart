import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo/model/shapes.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/widget/gesture_detector_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:widget_mask/widget_mask.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({super.key});

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? currentImage;
  late AppImageProvider imageProvider;

  BlendMode blendMode = BlendMode.dstIn;
  IconData iconData = Shapes().list()[0];
  double opacity = 1;

  int index = 1;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 9,
              child: Center(
                child: Consumer<AppImageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    return Screenshot(
                        controller: screenshotController,
                        child: WidgetMask(
                          childSaveLayer: true,
                          blendMode: blendMode,
                          mask: Center(
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                GestureDetectorWidget(
                                  child: Icon(
                                    iconData,
                                    color: Colors.white.withOpacity(opacity),
                                    size: 250,
                                  ),
                                )
                              ],
                            ),
                          ),
                          child: Image.memory(value.currentImage!),
                        ));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: 110,
                color: Colors.black,
                child: SafeArea(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.dstIn;
                                    opacity = 1;
                                  });
                                },
                                child: const Text(
                                  "DstIn",
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.overlay;
                                  });
                                },
                                child: const Text(
                                  "Overlay",
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.screen;
                                    opacity = 0.7;
                                  });
                                },
                                child: const Text(
                                  "Screen",
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.saturation;
                                  });
                                },
                                child: const Text(
                                  "Saturation",
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.modulate;
                                  });
                                },
                                child: const Text(
                                  "Modulate",
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    blendMode = BlendMode.difference;
                                  });
                                },
                                child: const Text(
                                  "Difference",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int i = 0; i < Shapes().list().length; i++)
                              _bottomBaItem(Shapes().list()[i], onPress: () {
                                setState(() {
                                  iconData = Shapes().list()[i];
                                });
                              })
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomBaItem(IconData icon, {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
