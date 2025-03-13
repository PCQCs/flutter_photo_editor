import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo/model/tints.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/service/tint.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({super.key});

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  late AppImageProvider imageProvider;
  late List<Tint> tints;

  int index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
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
                          child: Image.memory(
                            value.currentImage!,
                            color: tints[index]
                                .color
                                .withOpacity(tints[index].opacity),
                            colorBlendMode: BlendMode.color,
                          ));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Slider(
                          value: tints[index].opacity,
                          onChanged: (value) {
                            setState(() {
                              tints[index].opacity = value;
                            });
                          },
                        )
                      ],
                    )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    height: 58,
                    color: Colors.black,
                    child: SafeArea(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: tints.length,
                          itemBuilder: (BuildContext context, int index) {
                            Tint tint = tints[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  this.index = index;
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: CircleAvatar(
                                    backgroundColor: this.index == index
                                        ? Colors.white
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: CircleAvatar(
                                        backgroundColor: tint.color,
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    )),
              )
            ],
          )) /* Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: tints[index].opacity,
                onChanged: (value) {
                  setState(() {
                    tints[index].opacity = value;
                  });
                },
              )
            ],
          )), */
      ,
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        onChanged: onChanged,
        max: 1,
        min: 0);
  }
}
