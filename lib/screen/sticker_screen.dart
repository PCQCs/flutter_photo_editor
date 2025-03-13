import 'package:flutter/material.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({super.key});

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();

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
                  /* Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
                if (!mounted) return;
                Navigator.of(context).pop(); */
                },
                icon: const Icon(Icons.done))
          ],
        ),
        body: Center(
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
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 100,
          color: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.blue,
                )),
                const Row(
                  children: [],
                )
              ],
            ),
          ),
        ));
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
}
