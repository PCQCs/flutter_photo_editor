import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  // blur이 작동이 되긴 하는데 애메함
  ScreenshotController screenshotController = ScreenshotController();
  late AppImageProvider imageProvider;

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Consumer<AppImageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    return Screenshot(
                      controller: screenshotController,
                      child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              tileMode: tileMode,
                              sigmaX: sigmaX,
                              sigmaY: sigmaY),
                          child: Image.memory(
                            value.currentImage!,
                          )),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text('X: ',
                                style: TextStyle(color: Colors.white)),
                            Expanded(
                              child: Slider(
                                value: sigmaX,
                                onChanged: (value) {
                                  setState(() {
                                    sigmaX = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Y: ',
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Slider(
                                value: sigmaY,
                                onChanged: (value) {
                                  setState(() {
                                    sigmaY = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),

      /*  Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('X: ', style: TextStyle(color: Colors.white)),
                    Expanded(
                      child: Slider(
                        value: sigmaX,
                        onChanged: (value) {
                          setState(() {
                            sigmaX = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Y: ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        value: sigmaY,
                        onChanged: (value) {
                          setState(() {
                            sigmaY = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 38,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomBaItem('Decal',
                    color: tileMode == TileMode.decal ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.decal;
                  });
                }),
                _bottomBaItem('Clamp',
                    color: tileMode == TileMode.clamp ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.clamp;
                  });
                }),
                _bottomBaItem('Mirror',
                    color: tileMode == TileMode.mirror ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.mirror;
                  });
                }),
                _bottomBaItem('Repeated',
                    color: tileMode == TileMode.repeated ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.repeated;
                  });
                }),
              ],
            ),
          )), */
    );
  }

  Widget _bottomBaItem(String title, {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            title,
            style: TextStyle(color: color ?? Colors.white70),
          )),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        onChanged: onChanged,
        max: 2,
        min: -1);
  }
}
