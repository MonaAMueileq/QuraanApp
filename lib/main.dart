import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _items = [];
  String SurahName = '';
  PageController _pageController = PageController();

  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["sura"];
    });
  }
  void _search(String searchValue) {
    int pageNumber = -1;
    for (Map ayahData in _items) {
      if (ayahData['sura_name_ar'] == searchValue) {
        pageNumber = ayahData['page'];
        break;
      }
    }
    if (pageNumber != -1) {
      _pageController.jumpToPage(pageNumber - 1);
    }
  }
  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbce0c5),
      body: PageView.builder(
        controller: _pageController,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          if (_items.isNotEmpty) {
            String byPage = '';
            String surahName = '';
            int jozzNum = 0;
            bool isBasmalahShown = false;

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                byPage = byPage + ' ${ayahData['aya_text']}';
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                surahName = ayahData['sura_name_ar'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                jozzNum = ayahData['jozz'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                if (ayahData['aya_no'] == 1 &&
                    ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                    ayahData['sura_name_ar'] != 'التوبَة') {
                  isBasmalahShown = true;
                  break;
                }
              }
            }

            return SafeArea(
              child: Container(
                decoration: index % 2 == 0
                    ? const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight))
                    : const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.only(left: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search Surah Name",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              _search(value);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الجزء $jozzNum',
                                  style: const TextStyle(
                                      fontFamily: 'Kitab', fontSize: 20),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  surahName,
                                  style: const TextStyle(
                                      fontFamily: 'Kitab', fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isBasmalahShown
                                  ? const Text(
                                "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              )
                                  : Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                byPage,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  fontFamily: 'Kitab', fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator(
              backgroundColor: Color(0xffbce0c5),
            ));
          }
        },
      ),
    );
  }
}