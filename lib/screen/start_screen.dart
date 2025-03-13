import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/service/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Start_screen extends StatefulWidget {
  const Start_screen({super.key});

  @override
  State<Start_screen> createState() => _Start_screenState();
}

class _Start_screenState extends State<Start_screen> {
/*   InterstitialAd? _interstitialAd; */
  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.height;
    double height = mediaQueryData.size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  onTap: () async {
                    await [Permission.storage].request();
                    AppImagePicker(source: ImageSource.gallery).pick(
                        onPick: (File? image) {
                      Provider.of<AppImageProvider>(context, listen: false)
                          .changeImageFile(image!);
                      Navigator.of(context).pushReplacementNamed('/home');
                    });
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 220, 233, 244)),
                          child: const Icon(
                            Icons.photo,
                            size: 35,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "이미지 선택",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* 
                }); */
/* Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Image Editor",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black),
            ),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 30,
              childAspectRatio: 1.2,
              padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                InkWell(
                  onTap: () {
                    AppImagePicker(source: ImageSource.gallery).pick(
                        onPick: (File? image) {
                      Provider.of<AppImageProvider>(context, listen: false)
                          .changeImageFile(image!);
                      Navigator.of(context).pushReplacementNamed('/home');
                    });
                  },
                  child: Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.shade100,
                              Colors.purple.shade300
                            ]),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.photo_outlined,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Galley",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AppImagePicker(source: ImageSource.camera).pick(
                        onPick: (File? image) {
                      Provider.of<AppImageProvider>(context, listen: false)
                          .changeImageFile(image!);
                      Navigator.of(context).pushReplacementNamed('/home');
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.shade100,
                              Colors.purple.shade300
                            ]),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ) */
