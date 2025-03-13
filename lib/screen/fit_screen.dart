import 'dart:io';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/service/image_picker_service.dart';
import 'package:flutter_photo/service/textures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_photo/model/texture.dart' as t;

class Fit_screen extends StatefulWidget {
  const Fit_screen({super.key});

  @override
  State<Fit_screen> createState() => _Fit_screenState();
}

class _Fit_screenState extends State<Fit_screen> {
  // 아쉬운 부분: color의 color가 하나밖에 없는 것과 선택할때 자신이 뭐 선택했는지 확인이 불가능 함 추후 업데이트를 하여 고치기로 결정
  Color color = Colors.white;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  late t.Texture currentTexture;
  late List<t.Texture> textures;

  Uint8List? backgroundImage;
  Uint8List? currentImage;

  int x = 1;
  int y = 1;

  double blur = 0;

  int index = 0;

  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showTexture = false;

  bool showColorBackground = true;
  bool ShowImageBackground = false;
  bool showTextureBackground = false;

  @override
  void initState() {
    textures = Textures().list();
    currentTexture = textures[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  showActiveWidget({r, b, c, t}) {
    showRatio = r != null ? true : false;
    showBlur = b != null ? true : false;
    showColor = c != null ? true : false;
    showTexture = t != null ? true : false;
    setState(() {});
  }

  showBackgroundWidget({c, i, t}) {
    showColorBackground = c != null ? true : false;
    ShowImageBackground = i != null ? true : false;
    showTextureBackground = t != null ? true : false;
    setState(() {});
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
                      currentImage = value.currentImage;
                      backgroundImage ??= value.currentImage!;
                      return AspectRatio(
                          aspectRatio: x / y,
                          child: Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                if (showColorBackground)
                                  Container(
                                    color: color,
                                  ),
                                if (ShowImageBackground)
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                MemoryImage(backgroundImage!))),
                                  ).blurred(
                                    colorOpacity: 0,
                                    blur: blur,
                                  ),
                                if (showTextureBackground)
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                currentTexture.path!))),
                                  ),
                                Center(
                                  child: Image.memory(value.currentImage!),
                                )
                              ],
                            ),
                          ));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Stack(
                        children: [
                          if (showRatio) ratioWidget(),
                          if (showBlur) blurWidget(),
                          if (showColor) colorWidget(),
                          if (showTexture) textureWidget()
                        ],
                      )),
                      Row(
                        children: [
                          Expanded(
                            child: _bottomBaItem(Icons.aspect_ratio, "Ratio",
                                onPress: () {
                              showActiveWidget(r: true);
                            }),
                          ),
                          Expanded(
                            child: _bottomBaItem(Icons.blur_linear, "Blur",
                                onPress: () {
                              showBackgroundWidget(i: true);
                              showActiveWidget(b: true);
                            }),
                          ),
                          Expanded(
                            child: _bottomBaItem(Icons.texture, "Color",
                                onPress: () {
                              showBackgroundWidget(c: true);
                              showActiveWidget(c: true);
                            }),
                          ),
                          Expanded(
                            child: _bottomBaItem(Icons.crop_rotate, "Texture",
                                onPress: () {
                              showBackgroundWidget(t: true);
                              showActiveWidget(t: true);
                            }),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /* bottomNavigationBar: Container(
          width: double.infinity,
          height: 100,
          color: Colors.black,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Stack(
                      children: [
                        if (showRatio) ratioWidget(),
                        if (showBlur) blurWidget(),
                        if (showColor)
                          Container(
                            color: Colors.blue,
                          ),
                        if (showTexture)
                          Container(
                            color: Colors.yellow,
                          ),
                      ],
                    )),
                    Row(
                      children: [
                        Expanded(
                          child: _bottomBaItem(Icons.aspect_ratio, "Ratio",
                              onPress: () {
                            showActiveWidget(r: true);
                          }),
                        ),
                        Expanded(
                          child: _bottomBaItem(Icons.blur_linear, "Blur",
                              onPress: () {
                            showActiveWidget(b: true);
                          }),
                        ),
                        Expanded(
                          child: _bottomBaItem(Icons.texture, "Color",
                              onPress: () {
                            showActiveWidget(c: true);
                          }),
                        ),
                        Expanded(
                          child: _bottomBaItem(Icons.crop_rotate, "Texture",
                              onPress: () {
                            showActiveWidget(t: true);
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ))), */
    );
  }

  Widget _bottomBaItem(IconData icon, String title, {required onPress}) {
    return InkWell(
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
    );
  }

  Widget ratioWidget() {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 0;
                    x = 1;
                    y = 1;
                  });
                },
                child: Text(
                  "1:1",
                  style:
                      TextStyle(color: index == 0 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 1;
                    x = 2;
                    y = 1;
                  });
                },
                child: Text(
                  "2:1",
                  style:
                      TextStyle(color: index == 1 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 2;
                    x = 1;
                    y = 2;
                  });
                },
                child: Text(
                  "1:2",
                  style:
                      TextStyle(color: index == 2 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 3;
                    x = 4;
                    y = 3;
                  });
                },
                child: Text(
                  "4:3",
                  style:
                      TextStyle(color: index == 3 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 4;
                    x = 3;
                    y = 4;
                  });
                },
                child: Text(
                  "3:4",
                  style:
                      TextStyle(color: index == 4 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 5;
                    x = 16;
                    y = 9;
                  });
                },
                child: Text(
                  "16:9",
                  style:
                      TextStyle(color: index == 5 ? Colors.blue : Colors.white),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 6;
                    x = 9;
                    y = 16;
                  });
                },
                child: Text(
                  "9:16",
                  style:
                      TextStyle(color: index == 6 ? Colors.blue : Colors.white),
                )),
          ],
        ),
      ),
    );
  }

  Widget blurWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  AppImagePicker(source: ImageSource.gallery).pick(
                      onPick: (File? image) async {
                    backgroundImage = image!.readAsBytesSync();
                    setState(() {});
                  });
                },
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.blue,
                )),
            Expanded(
                child: Slider(
                    label: blur.toStringAsFixed(2),
                    value: blur,
                    max: 100,
                    min: 0,
                    onChanged: (value) {
                      setState(() {
                        blur = value;
                      });
                    }))
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  pickColor(context);
                },
                icon: const Icon(
                  Icons.colorize,
                  color: Colors.blue,
                ))
          ],
        ),
      ),
    );
  }

  Widget buildColorPicker() => ColorPicker(
      colorPickerWidth: 200,
      pickerColor: color,
      enableAlpha: false,
      onColorChanged: (color) => setState(() => this.color = color));

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
  Widget textureWidget() {
    return Container(
      color: Colors.black,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: textures.length,
          itemBuilder: (BuildContext context, int index) {
            t.Texture texture = textures[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentTexture = texture;
                          });
                        },
                        child: Image.asset(texture.path!),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
