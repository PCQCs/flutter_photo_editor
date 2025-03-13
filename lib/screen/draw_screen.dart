import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  Color color = Colors.white;
  ScreenshotController screenshotController = ScreenshotController();
  late AppImageProvider imageProvider;
  final PainterController _controller = PainterController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.transparent;
    super.initState();
  }

  PainterController newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
    return controller;
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
              flex: 7,
              child: Center(
                child: Consumer<AppImageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    return Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          Image.memory(value.currentImage!),
                          Positioned.fill(child: Painter(_controller))
                        ],
                      ),
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
                            Icon(
                              Icons.circle,
                              color: _controller.drawColor,
                              size: _controller.thickness + 3,
                            ),
                            Expanded(
                                child: Slider(
                              value: _controller.thickness,
                              max: 20,
                              min: 1,
                              onChanged: (value) {
                                setState(() {
                                  _controller.thickness = value;
                                });
                              },
                            ))
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _bottomBaItem(
                            Icons.undo,
                            onPress: () {
                              _controller.undo();
                            },
                          ),
                        ),
                        Expanded(
                          child: _bottomBaItem(
                            Icons.color_lens_outlined,
                            onPress: () {
                              setState(() {
                                pickColor(context);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _bottomBaItem(
                            Icons.delete,
                            onPress: () {
                              _controller.clear();
                            },
                          ),
                        ),
                        Expanded(
                            child: RotatedBox(
                          quarterTurns: _controller.eraseMode ? 2 : 0,
                          child: _bottomBaItem(
                            Icons.create,
                            onPress: () {
                              setState(() {
                                _controller.eraseMode = !_controller.eraseMode;
                              });
                            },
                          ),
                        ))
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
      /* Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: _controller.drawColor,
                      size: _controller.thickness + 3,
                    ),
                    Expanded(
                        child: Slider(
                      value: _controller.thickness,
                      max: 20,
                      min: 1,
                      onChanged: (value) {
                        setState(() {
                          _controller.thickness = value;
                        });
                      },
                    ))
                  ],
                )
              ],
            ),
          )), */
    );
  }

  Widget buildColorPicker() => ColorPicker(
      colorPickerWidth: 200,
      pickerColor: color,
      enableAlpha: false,
      onColorChanged: (color) => setState(() => _controller.drawColor = color));

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Pick Color"),
          content: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildColorPicker(),
                  TextButton(
                    child: const Text(
                      "SELECT",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            ],
          )));

  Widget _bottomBaItem(IconData icon, {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      onChanged: onChanged,
      max: 20,
    );
  }
}
