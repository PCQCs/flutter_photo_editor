import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  // 모든 기능 완성 건드릴 필요 없음
  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;
  bool showSepia = false;

  late ColorFilterGenerator adj;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  adjust({b, c, s, h, se}) {
    adj = ColorFilterGenerator(name: 'Adjust', filters: [
      ColorFilterAddons.brightness(b ?? brightness),
      ColorFilterAddons.contrast(c ?? contrast),
      ColorFilterAddons.saturation(s ?? saturation),
      ColorFilterAddons.hue(h ?? hue),
      ColorFilterAddons.sepia(se ?? sepia),
    ]);
  }

  showSlider({b, c, s, h, se}) {
    setState(() {
      showBrightness = b != null ? true : false;
      showContrast = c != null ? true : false;
      showSaturation = s != null ? true : false;
      showHue = h != null ? true : false;
      showSepia = se != null ? true : false;
    });
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
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(adj.matrix),
                        child: Image.memory(value.currentImage!),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                              visible: showBrightness,
                              child: slider(
                                  value: brightness,
                                  onChanged: (value) {
                                    setState(() {
                                      brightness = value;
                                      adjust(b: brightness);
                                    });
                                  })),
                          Visibility(
                              visible: showContrast,
                              child: slider(
                                  value: contrast,
                                  onChanged: (value) {
                                    setState(() {
                                      contrast = value;
                                      adjust(c: contrast);
                                    });
                                  })),
                          Visibility(
                              visible: showSaturation,
                              child: slider(
                                  value: saturation,
                                  onChanged: (value) {
                                    setState(() {
                                      saturation = value;
                                      adjust(s: saturation);
                                    });
                                  })),
                          Visibility(
                              visible: showHue,
                              child: slider(
                                  value: hue,
                                  onChanged: (value) {
                                    setState(() {
                                      hue = value;
                                      adjust(h: hue);
                                    });
                                  })),
                          Visibility(
                              visible: showSepia,
                              child: slider(
                                  value: sepia,
                                  onChanged: (value) {
                                    setState(() {
                                      sepia = value;
                                      adjust(se: sepia);
                                    });
                                  })),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          brightness = 0;
                          contrast = 0;
                          saturation = 0;
                          hue = 0;
                          sepia = 0;
                          adjust(
                              b: brightness,
                              c: contrast,
                              s: saturation,
                              h: hue,
                              se: sepia);
                        });
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  height: 58,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _bottomBaItem(
                            Icons.brightness_4_rounded,
                            color: showBrightness ? Colors.blue : null,
                            "Brightness", onPress: () {
                          showSlider(b: true);
                        }),
                        _bottomBaItem(
                            Icons.contrast,
                            color: showContrast ? Colors.blue : null,
                            "Contrast", onPress: () {
                          showSlider(c: true);
                        }),
                        _bottomBaItem(
                            Icons.water_drop,
                            color: showSaturation ? Colors.blue : null,
                            "Saturation", onPress: () {
                          showSlider(s: true);
                        }),
                        _bottomBaItem(
                            Icons.filter_tilt_shift,
                            color: showHue ? Colors.blue : null,
                            "Hue", onPress: () {
                          showSlider(h: true);
                        }),
                        _bottomBaItem(
                            Icons.motion_photos_on,
                            color: showSepia ? Colors.blue : null,
                            "Sepia", onPress: () {
                          showSlider(se: true);
                        }),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBaItem(IconData icon, String title,
      {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color ?? Colors.white,
              size: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(color: color ?? Colors.white70),
            )
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
        max: 1,
        min: -0.9);
  }
}
