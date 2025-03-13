import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo/model/filter.dart';
import 'package:flutter_photo/provider/image_provider.dart';
import 'package:flutter_photo/service/filters.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class Filter_screen extends StatefulWidget {
  const Filter_screen({super.key});

  @override
  State<Filter_screen> createState() => _Filter_screenState();
}

class _Filter_screenState extends State<Filter_screen> {
  //구현 완료
  //나중에 필터 조금 더 추가 예정
  late Filter currentFilter;
  late List<Filter> filters;

  int index = 0;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
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
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          )
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
                            colorFilter:
                                ColorFilter.matrix(currentFilter.matrix),
                            child: Image.memory(value.currentImage!),
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: SafeArea(
                  child: Consumer<AppImageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (BuildContext context, int index) {
                            Filter filter = filters[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentFilter = filter;
                                              this.index = index;
                                            });
                                          },
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.matrix(
                                                filter.matrix),
                                            child: Image.memory(
                                                value.currentImage!),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    filter.filterName,
                                    style: TextStyle(
                                        color: this.index == index
                                            ? Colors.blue
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      /* bottomNavigationBar: Container(
          height: 100,
          width: double.infinity,
          color: Colors.black,
          child: SafeArea(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (BuildContext context, int index) {
                      Filter filter = filters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentFilter = filter;
                                    });
                                  },
                                  child: ColorFiltered(
                                    colorFilter:
                                        ColorFilter.matrix(filter.matrix),
                                    child: Image.memory(value.currentImage!),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              filter.filterName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ) 
      /*  Container(
          width: double.infinity,
          height: 100,
          color: Colors.black,
          child: SafeArea(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GridView.builder(
                      itemCount: filters.length,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.1 / 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Filter filter = filters[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentFilter = filter;
                                      });
                                    },
                                    child: ColorFiltered(
                                      colorFilter:
                                          ColorFilter.matrix(filter.matrix),
                                      child: Image.memory(value.currentImage!),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                filter.filterName,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ) */
      /* bottomNavigationBar: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            color: const Color.fromARGB(255, 155, 71, 71),
            child: SafeArea(
              child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (BuildContext context, int index) {
                        Filter filter = filters[index];
                        return Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {},
                                  child: ColorFiltered(
                                    colorFilter:
                                        ColorFilter.matrix(filter.matrix),
                                    child: Image.memory(value.currentImage!),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                },
              ),
            ),
          )
        ],
      ), */ */
    );
  }
}
