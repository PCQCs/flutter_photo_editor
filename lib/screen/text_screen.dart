import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo/model/fonts.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:sticker_view/stickerview.dart';
import 'package:text_editor/text_editor.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  //텍스트 정상적으로 나오게만 하면 끝, 회전이랑 사이즈 조절 가능하게
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();

  bool showEditor = true;

  double index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    Uint8List? image = await controller.saveAsUint8List();
                    imageProvider.changeImage(image!);
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
                        return LindiStickerWidget(
                            controller: controller,
                            child: Image.memory(value.currentImage!));
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          /* Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: index,
                    onChanged: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                  )
                ],
              )), */
          bottomNavigationBar: Container(
            width: double.infinity,
            height: 50,
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showEditor = true;
                  });
                },
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
            ),
          ),
        ),
        if (showEditor)
          Scaffold(
              backgroundColor: Colors.black.withOpacity(0.75),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color: Colors.white),
                  minFontSize: 10,
                  maxFontSize: 70,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if (text.isNotEmpty) {
                        controller.addWidget(
                          Text(
                            text,
                            textAlign: align,
                            style: style,
                          ),
                        );
                      }
                    });
                  },
                ),
              )))
      ],
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
