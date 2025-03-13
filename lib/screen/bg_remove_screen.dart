import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BgRemoveScreen extends StatefulWidget {
  const BgRemoveScreen({super.key});

  @override
  State<BgRemoveScreen> createState() => _BgRemoveScreenState();
}

class _BgRemoveScreenState extends State<BgRemoveScreen> {
  Uint8List? image;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

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
      body: Center(
        child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
          if (value.currentImage != null) {
            return Screenshot(
                controller: screenshotController,
                child: Image.memory(value.currentImage!));
          }
          if (image != null) {
            return Screenshot(
                controller: screenshotController, child: Image.memory(image!));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 50,
          color: Colors.black,
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Add Text",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
